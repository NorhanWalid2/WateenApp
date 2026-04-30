// lib/core/services/signalr_service.dart

import 'package:signalr_netcore/signalr_client.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';

class SignalRService {
  static final SignalRService _instance = SignalRService._internal();
  factory SignalRService() => _instance;
  SignalRService._internal();

  HubConnection? _hubConnection;
  bool _isConnected = false;
  bool get isConnected => _isConnected;

  // ── Multiple listeners support ────────────────────────────────────
  // Instead of a single callback, use lists so both cubits can listen
  final List<void Function(Map<String, dynamic>)> _onMessageReceivedListeners = [];
  final List<void Function(String)> _onMessagesReadListeners = [];
  final List<void Function(String)> _onUserOnlineListeners = [];
  final List<void Function(String)> _onUserOfflineListeners = [];

  void addOnMessageReceived(void Function(Map<String, dynamic>) listener) {
    if (!_onMessageReceivedListeners.contains(listener)) {
      _onMessageReceivedListeners.add(listener);
    }
  }

  void removeOnMessageReceived(void Function(Map<String, dynamic>) listener) {
    _onMessageReceivedListeners.remove(listener);
  }

  void addOnMessagesRead(void Function(String) listener) {
    if (!_onMessagesReadListeners.contains(listener)) {
      _onMessagesReadListeners.add(listener);
    }
  }

  void removeOnMessagesRead(void Function(String) listener) {
    _onMessagesReadListeners.remove(listener);
  }

  // Keep old single-callback API for backward compatibility
  // These just add to the list
  set onMessageReceived(void Function(Map<String, dynamic>)? cb) {
    _onMessageReceivedListeners.clear();
    if (cb != null) _onMessageReceivedListeners.add(cb);
  }

  set onMessagesRead(void Function(String)? cb) {
    _onMessagesReadListeners.clear();
    if (cb != null) _onMessagesReadListeners.add(cb);
  }

  set onUserOnline(void Function(String)? cb) {
    _onUserOnlineListeners.clear();
    if (cb != null) _onUserOnlineListeners.add(cb);
  }

  set onUserOffline(void Function(String)? cb) {
    _onUserOfflineListeners.clear();
    if (cb != null) _onUserOfflineListeners.add(cb);
  }

  // ── Connect ───────────────────────────────────────────────────────
  Future<void> connect() async {
    if (_isConnected &&
        _hubConnection?.state == HubConnectionState.Connected) {
      print('SignalR: already connected');
      return;
    }

    _isConnected = false;
    _hubConnection = null;

    try {
      _hubConnection = HubConnectionBuilder()
          .withUrl(
            "http://wateen.runasp.net/hubs/chat",
            options: HttpConnectionOptions(
              accessTokenFactory: () async => AppPrefs.token ?? '',
            ),
          )
          .withAutomaticReconnect()
          .build();

      _hubConnection!.onreconnecting(({error}) {
        _isConnected = false;
        print('SignalR: reconnecting...');
      });

      _hubConnection!.onreconnected(({connectionId}) {
        _isConnected = true;
        print('SignalR: reconnected! id=$connectionId');
      });

      _hubConnection!.onclose(({error}) {
        _isConnected = false;
        print('SignalR: closed. error=$error');
      });

      // ── ReceiveMessage → notify ALL listeners ─────────────────────
      _hubConnection!.on("ReceiveMessage", (args) {
        if (args == null || args.isEmpty) return;
        try {
          final msg = args[0] as Map<String, dynamic>;
          print('SignalR ReceiveMessage: $msg');
          for (final listener in List.from(_onMessageReceivedListeners)) {
            listener(msg);
          }
        } catch (e) {
          print('SignalR ReceiveMessage error: $e');
        }
      });

      // ── MessagesRead → notify ALL listeners ───────────────────────
      _hubConnection!.on("MessagesRead", (args) {
        if (args == null || args.isEmpty) return;
        try {
          final byUserId = args[0].toString();
          print('SignalR MessagesRead by: $byUserId');
          for (final listener in List.from(_onMessagesReadListeners)) {
            listener(byUserId);
          }
        } catch (e) {
          print('SignalR MessagesRead error: $e');
        }
      });

      _hubConnection!.on("UserOnline", (args) {
        if (args == null || args.isEmpty) return;
        final userId = args[0].toString();
        for (final l in List.from(_onUserOnlineListeners)) l(userId);
      });

      _hubConnection!.on("UserOffline", (args) {
        if (args == null || args.isEmpty) return;
        final userId = args[0].toString();
        for (final l in List.from(_onUserOfflineListeners)) l(userId);
      });

      await _hubConnection!.start();
      _isConnected = true;
      print('SignalR: connected successfully');
    } catch (e) {
      _isConnected = false;
      _hubConnection = null;
      print('SignalR: connection failed - $e');
    }
  }

  // ── Send ──────────────────────────────────────────────────────────
  Future<void> sendMessage(String receiverId, String content) async {
    if (!_isConnected ||
        _hubConnection?.state != HubConnectionState.Connected) {
      await connect();
    }
    if (_hubConnection == null) return;

    try {
      await _hubConnection!.invoke(
        "SendMessage",
        args: [{"receiverId": receiverId, "messageContent": content}],
      );
      print('SignalR: sent "$content" to $receiverId');
    } catch (e) {
      print('SignalR send error: $e');
      rethrow;
    }
  }

  // ── Mark as read ──────────────────────────────────────────────────
  Future<void> markAsRead(String otherUserId) async {
    if (!_isConnected || _hubConnection == null) return;
    try {
      await _hubConnection!.invoke(
        "MarkAsRead",
        args: [otherUserId],
      );
      print('SignalR: markAsRead for $otherUserId');
    } catch (e) {
      print('SignalR markAsRead error: $e');
    }
  }

  Future<void> disconnect() async {
    await _hubConnection?.stop();
    _isConnected = false;
    _hubConnection = null;
  }
}