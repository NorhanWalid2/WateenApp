// lib/features/patient/ai_assistant/presentation/cubit/ai_assistant_cubit.dart

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/features/patient/ai_assistant/data/models/chat_message_model.dart';
import 'ai_assistant_state.dart';

class AiAssistantCubit extends Cubit<AiAssistantState> {
  final Dio _backendDio = Dio(
    BaseOptions(baseUrl: "https://wateen.runasp.net"),
  );

  // Claude API via Anthropic
  final Dio _claudeDio = Dio(
    BaseOptions(
      baseUrl: "https://api.anthropic.com",
      headers: {"Content-Type": "application/json"},
    ),
  );

  final List<ChatMessage> _messages = [
    ChatMessage(
      text: "Hello! I'm your AI health assistant. How can I help you today?",
      sender: MessageSender.ai,
      time: DateTime.now().subtract(const Duration(minutes: 2)),
      type: MessageType.text,
    ),
  ];

  // Keep conversation history for Claude context
  final List<Map<String, String>> _conversationHistory = [];

  AiAssistantCubit() : super(AiAssistantInitial());

  Options get _backendAuthOptions => Options(
        headers: {"Authorization": "Bearer ${AppPrefs.token}"},
      );

  List<ChatMessage> get messages => List.unmodifiable(_messages);

  // ── Send message ──────────────────────────────────────────────────
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    final userMsg = ChatMessage(
      text: text.trim(),
      sender: MessageSender.user,
      time: DateTime.now(),
      type: MessageType.text,
    );
    _messages.add(userMsg);
    emit(AiAssistantLoaded(List.from(_messages), isTyping: true));

    // Check if it's a calorie question → use backend API
    if (_isCalorieQuestion(text)) {
      await _handleCalorieQuestion(text);
    } else {
      await _handleClaudeChat(text);
    }
  }

  // ── Detect calorie questions ──────────────────────────────────────
  bool _isCalorieQuestion(String text) {
    final lower = text.toLowerCase();
    final calorieKeywords = [
      'calori', 'calories', 'سعر', 'سعرات', 'كالوري',
      'how many calories', 'kcal', 'كم سعر',
    ];
    return calorieKeywords.any((k) => lower.contains(k));
  }

  // ── Extract food name from calorie question ───────────────────────
  String _extractFoodName(String text) {
    // Remove common calorie question patterns and return the food
    String food = text
        .toLowerCase()
        .replaceAll(RegExp(r'(how many calories|calories in|كم سعر حراري في|كم سعرات|سعرات حرارية في|calorie|calories)', caseSensitive: false), '')
        .replaceAll(RegExp(r'[؟?]'), '')
        .trim();
    return food.isNotEmpty ? food : text.trim();
  }

  // ── Handle calorie query via backend ─────────────────────────────
  // GET /api/AI/GetAICalories?food={foodName}
  Future<void> _handleCalorieQuestion(String text) async {
    try {
      final food = _extractFoodName(text);
      print('Calorie query for: $food');

      final response = await _backendDio.get(
        "/api/AI/GetAICalories",
        queryParameters: {"food": food},
        options: _backendAuthOptions,
      );

      print('CALORIES RAW: ${response.data}');

      final data = response.data;
      String aiResponse = '';

      if (data is Map) {
        final calories = data['calories'];
        final foodEn = data['food_En'] ?? data['foodEn'] ?? food;
        final foodAr = data['food_Ar'] ?? data['foodAr'] ?? '';
        final source = data['source'] ?? '';

        aiResponse = '🍽️ **$foodEn**${foodAr.isNotEmpty ? ' ($foodAr)' : ''}\n\n'
            '**Calories: $calories kcal** per serving\n\n'
            '${source == 'ai' ? '*(Estimated by AI)*' : '*(From nutrition database)*'}\n\n'
            'Remember to consider portion sizes. For personalized nutrition advice, consult your doctor.';
      } else {
        aiResponse = 'I found calorie info: $data';
      }

      _addAiMessage(aiResponse);
    } on DioException catch (e) {
      print('CALORIE API ERROR: ${e.response?.data}');
      // Fallback to Claude if backend fails
      await _handleClaudeChat(text);
    } catch (e) {
      print('CALORIE ERROR: $e');
      await _handleClaudeChat(text);
    }
  }

  // ── Handle general health chat via Claude ─────────────────────────
  Future<void> _handleClaudeChat(String text) async {
    try {
      // Build conversation history for context
      _conversationHistory.add({"role": "user", "content": text.trim()});

      final response = await _claudeDio.post(
        "/v1/messages",
        data: jsonEncode({
          "model": "claude-sonnet-4-20250514",
          "max_tokens": 1000,
          "system": """You are a compassionate AI health assistant for Wateen, a healthcare app.
You provide helpful, accurate health information in a warm, professional tone.
Always remind patients to consult their doctors for serious medical concerns.
Keep responses concise and easy to understand.
If the user writes in Arabic, respond in Arabic. If in English, respond in English.
Never diagnose conditions. Never prescribe medications.
You can discuss symptoms, general wellness, nutrition, and healthy lifestyle tips.""",
          "messages": _conversationHistory,
        }),
      );

      final content = response.data['content'] as List;
      final aiText = content
          .where((c) => c['type'] == 'text')
          .map((c) => c['text'] as String)
          .join('\n');

      // Add to history for context in next message
      _conversationHistory.add({"role": "assistant", "content": aiText});

      // Keep history manageable (last 10 exchanges)
      if (_conversationHistory.length > 20) {
        _conversationHistory.removeRange(0, 2);
      }

      _addAiMessage(aiText);
    } on DioException catch (e) {
      print('CLAUDE API ERROR: ${e.response?.statusCode} - ${e.response?.data}');
      _addAiMessage(
        'I\'m having trouble connecting right now. Please try again in a moment.',
      );
    } catch (e) {
      print('CLAUDE ERROR: $e');
      _addAiMessage(
        'Something went wrong. Please try again.',
      );
    }
  }

  // ── Add AI response to messages ───────────────────────────────────
  void _addAiMessage(String text) {
    if (isClosed) return;
    _messages.add(ChatMessage(
      text: text,
      sender: MessageSender.ai,
      time: DateTime.now(),
      type: MessageType.text,
    ));
    emit(AiAssistantLoaded(List.from(_messages), isTyping: false));
  }

  // ── Clear conversation ────────────────────────────────────────────
  void clearConversation() {
    _messages.clear();
    _conversationHistory.clear();
    _messages.add(ChatMessage(
      text: "Hello! I'm your AI health assistant. How can I help you today?",
      sender: MessageSender.ai,
      time: DateTime.now(),
      type: MessageType.text,
    ));
    emit(AiAssistantLoaded(List.from(_messages), isTyping: false));
  }
}