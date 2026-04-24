import 'package:dio/dio.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/features/patient/messages/data/models/chat_message_model.dart';
import 'package:wateen_app/features/patient/messages/data/models/conversation_model.dart';

class ChatRepository {
  static final ChatRepository _instance = ChatRepository._internal();
  factory ChatRepository() => _instance;
  ChatRepository._internal();

  final Dio _dio = Dio(
    BaseOptions(baseUrl: "http://wateen.runasp.net"),
  );

  Options get _authOptions => Options(
        headers: {"Authorization": "Bearer ${AppPrefs.token}"},
      );

 List<Map<String, dynamic>> _extractList(dynamic body) {
  if (body is List) {
    return body
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  if (body is Map) {
    final data = body['data'];

    if (data is List) {
      return data
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
  }

  return [];
}

  Future<List<ChatMessageModel>> loadHistory(String otherUserId) async {
    final response = await _dio.get(
      "/api/Chat/$otherUserId/history",
      options: _authOptions,
    );

    print('HISTORY RAW: ${response.data}');

    final List data = _extractList(response.data);

    return data
        .whereType<Map<String, dynamic>>()
        .map(
          (e) => ChatMessageModel.fromJson(
            e,
            currentUserId: AppPrefs.userId ?? '',
          ),
        )
        .toList();
  }

Future<List<ConversationModel>> loadConversations() async {
  final response = await _dio.get(
    "/api/Chat",
    options: _authOptions,
  );

  print('CONVERSATIONS RAW: ${response.data}');

  final data = _extractList(response.data);

  return data
      .whereType<Map<String, dynamic>>()
      .map((e) => ConversationModel.fromJson(e))
      .where((conversation) => conversation.lastMessage.trim().isNotEmpty)
      .toList();
}

  Future<void> markAsRead(String otherUserId) async {
    await _dio.put(
      "/api/Chat/$otherUserId/read",
      options: _authOptions,
    );
  }
}