import 'package:dio/dio.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'models/chat_message_model.dart';
import 'models/conversation_model.dart';

class ChatRepository {
  // ── Singleton ────────────────────────────────────────────────────
  static final ChatRepository _instance = ChatRepository._internal();
  factory ChatRepository() => _instance;
  ChatRepository._internal();

  final Dio _dio = Dio(
    BaseOptions(baseUrl: "http://wateen.runasp.net"),
  );

  Options get _authOptions => Options(
    headers: {"Authorization": "Bearer ${AppPrefs.token}"},
  );

  // ── Load history ─────────────────────────────────────────────────
  Future<List<ChatMessageModel>> loadHistory(String otherUserId) async {
    final response = await _dio.get(
      "/api/Chat/$otherUserId/history",
      options: _authOptions,
    );
    print('HISTORY RAW: ${response.data}');

    if (response.data == null) return [];
    final List data = response.data is List ? response.data as List : [];
    return data
        .map((e) => ChatMessageModel.fromJson(
              e,
              currentUserId: AppPrefs.userId ?? '',
            ))
        .toList();
  }

  // ── Load all conversations ────────────────────────────────────────
  Future<List<ConversationModel>> loadConversations() async {
    final response = await _dio.get(
      "/api/Chat",
      options: _authOptions,
    );
    print('CONVERSATIONS RAW: ${response.data}');

    if (response.data == null) return [];
    final List data = response.data is List ? response.data as List : [];
    return data.map((e) => ConversationModel.fromJson(e)).toList();
  }

  // ── Mark as read ─────────────────────────────────────────────────
  Future<void> markAsRead(String otherUserId) async {
    await _dio.put(
      "/api/Chat/$otherUserId/read",
      options: _authOptions,
    );
  }
}