import 'package:signalr_netcore/signalr_client.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';

class SignalRService {
  // ── Singleton ────────────────────────────────────────────────────
  static final SignalRService _instance = SignalRService._internal();
  factory SignalRService() => _instance;
  SignalRService._internal();

  HubConnection? _hubConnection;
  bool _isConnected = false;

  bool get isConnected => _isConnected;
  HubConnection? get hub => _hubConnection;

  // ── Connect ──────────────────────────────────────────────────────
  Future<void> connect() async {
  if (_isConnected && _hubConnection?.state == HubConnectionState.Connected) {
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

    // ── Reconnection events ──────────────────────────────────
    _hubConnection!.onreconnecting(({error}) {
      _isConnected = false;
      print('SignalR: reconnecting... error=$error');
    });

    _hubConnection!.onreconnected(({connectionId}) {
      _isConnected = true;
      print('SignalR: reconnected! id=$connectionId');
    });

    _hubConnection!.onclose(({error}) {
      _isConnected = false;
      print('SignalR: connection closed. error=$error');
    });

    // ── Listeners ────────────────────────────────────────────
    _hubConnection!.on("ReceiveMessage", (args) {
      if (args == null || args.isEmpty) return;
      final msg = args[0] as Map<String, dynamic>;
      print('SignalR ReceiveMessage: $msg');
      onMessageReceived?.call(msg);
    });

    _hubConnection!.on("MessagesRead", (args) {
      if (args == null || args.isEmpty) return;
      onMessagesRead?.call(args[0].toString());
    });

    _hubConnection!.on("UserOnline", (args) {
      if (args == null || args.isEmpty) return;
      onUserOnline?.call(args[0].toString());
    });

    _hubConnection!.on("UserOffline", (args) {
      if (args == null || args.isEmpty) return;
      onUserOffline?.call(args[0].toString());
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

  // ── Send message ─────────────────────────────────────────────────
  Future<void> sendMessage(String receiverId, String content) async {
  // Reconnect if disconnected
  if (!_isConnected || _hubConnection?.state != HubConnectionState.Connected) {
    print('SignalR: reconnecting...');
    await connect();
  }
  
  if (_hubConnection == null) {
    print('SignalR: still not connected');
    return;
  }
  
  await _hubConnection!.invoke("SendMessage", args: [
    {
      "receiverId": receiverId,
      "messageContent": content,
    }
  ]);
  print('SignalR: sent "$content" to $receiverId');
}

  // ── Mark as read ─────────────────────────────────────────────────
  Future<void> markAsRead(String otherUserId) async {
    if (!_isConnected || _hubConnection == null) return;
    await _hubConnection!.invoke("MarkAsRead", args: [otherUserId]);
    print('SignalR: marked as read for $otherUserId');
  }

  // ── Disconnect ───────────────────────────────────────────────────
  Future<void> disconnect() async {
    await _hubConnection?.stop();
    _isConnected = false;
    _hubConnection = null;
    print('SignalR: disconnected');
  }

  // ── Callbacks (set these from your cubit) ────────────────────────
  void Function(Map<String, dynamic> msg)? onMessageReceived;
  void Function(String byUserId)? onMessagesRead;
  void Function(String userId)? onUserOnline;
  void Function(String userId)? onUserOffline;
}