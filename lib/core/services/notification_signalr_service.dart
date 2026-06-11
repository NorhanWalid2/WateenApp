// lib/core/services/notification_signalr_service.dart

import 'dart:convert';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';

class NotificationSignalRService {
  static final NotificationSignalRService _instance =
      NotificationSignalRService._internal();
  factory NotificationSignalRService() => _instance;
  NotificationSignalRService._internal();

  HubConnection? _hub;
  bool _isConnected = false;
  bool get isConnected => _isConnected;

  final List<void Function(Map<String, dynamic>)> _listeners = [];

  void addListener(void Function(Map<String, dynamic>) listener) {
    if (!_listeners.contains(listener)) _listeners.add(listener);
  }

  void removeListener(void Function(Map<String, dynamic>) listener) {
    _listeners.remove(listener);
  }

  Future<void> connect() async {
    if (_isConnected && _hub?.state == HubConnectionState.Connected) return;

    _isConnected = false;
    _hub = null;

    try {
      _hub = HubConnectionBuilder()
          .withUrl(
            "https://wateen.runasp.net/hubs/notifications",
            options: HttpConnectionOptions(
              accessTokenFactory: () async => AppPrefs.token ?? '',
            ),
          )
          .withAutomaticReconnect()
          .build();

      _hub!.onreconnecting(({error}) {
        _isConnected = false;
        print('NotificationHub: reconnecting...');
      });

      _hub!.onreconnected(({connectionId}) {
        _isConnected = true;
        print('NotificationHub: reconnected');
      });

      _hub!.onclose(({error}) {
        _isConnected = false;
        print('NotificationHub: closed. error=$error');
      });

      // ── Listen for real-time notifications ───────────────────────
      _hub!.on("ReceiveNotification", (args) {
        print('NotificationHub RAW ARGS: $args');
        print('NotificationHub ARGS TYPE: ${args?.runtimeType}');
        if (args != null && args.isNotEmpty) {
          print('NotificationHub ARG[0] TYPE: ${args[0]?.runtimeType}');
          print('NotificationHub ARG[0] VALUE: ${args[0]}');
        }

        if (args == null || args.isEmpty) return;

        try {
          final data = _parseArg(args[0]);
          if (data == null) {
            print('NotificationHub: could not parse arg to Map');
            return;
          }
          print('NotificationHub PARSED: $data');
          for (final listener in List.from(_listeners)) {
            listener(data);
          }
        } catch (e, s) {
          print('NotificationHub parse error: $e');
          print('NotificationHub parse stack: $s');
        }
      });

      await _hub!.start();
      _isConnected = true;
      print('NotificationHub: connected successfully');
    } catch (e) {
      _isConnected = false;
      _hub = null;
      print('NotificationHub: connection failed - $e');
    }
  }

  /// Safely convert whatever SignalR sends into Map<String, dynamic>
  Map<String, dynamic>? _parseArg(Object? arg) {
    if (arg == null) return null;

    // Already the right type
    if (arg is Map<String, dynamic>) return arg;

    // Map with wrong generic types (common with signalr_netcore)
    if (arg is Map) {
      return arg.map((k, v) => MapEntry(k.toString(), v));
    }

    // JSON string — parse it
    if (arg is String) {
      try {
        final decoded = jsonDecode(arg);
        if (decoded is Map) {
          return decoded.map((k, v) => MapEntry(k.toString(), v));
        }
      } catch (_) {}
    }

    return null;
  }

  Future<void> disconnect() async {
    await _hub?.stop();
    _isConnected = false;
    _hub = null;
    _listeners.clear();
  }
}