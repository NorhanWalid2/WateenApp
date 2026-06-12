// lib/features/notifications/data/repository/notification_repository.dart

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import '../models/notification_model.dart';

class NotificationRepository {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'https://wateen.runasp.net'),
  );

  // GET /api/Notification/my?pageNumber=1&pageSize=50
  Future<List<NotificationModel>> getNotifications() async {
    final token = AppPrefs.token;

    // ── DEBUG: decode JWT to see role claim ──────────────────────────
    try {
      final parts = token?.split('.') ?? [];
      if (parts.length >= 2) {
        String payload = parts[1];
        while (payload.length % 4 != 0) payload += '=';
        final decoded = String.fromCharCodes(base64Url.decode(payload));
        final claims = jsonDecode(decoded) as Map<String, dynamic>;
        final role = claims['role'] ??
            claims['http://schemas.microsoft.com/ws/2008/06/identity/claims/role'];
        final exp = claims['exp'];
        final expDate = exp != null
            ? DateTime.fromMillisecondsSinceEpoch((exp as int) * 1000)
            : null;
        print('NOTIFICATION TOKEN ROLE: $role');
        print('NOTIFICATION TOKEN EXPIRES: $expDate');
        print('NOTIFICATION TOKEN EXPIRED: ${expDate != null && expDate.isBefore(DateTime.now())}');
      }
    } catch (e) {
      print('TOKEN DECODE ERROR: $e');
    }

    if (token == null || token.isEmpty) {
      throw Exception('No auth token');
    }

    final response = await _dio.get(
      '/api/Notification/my',
      queryParameters: {'pageNumber': 1, 'pageSize': 50},
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );
    print(response.data);

    print('NOTIFICATIONS RAW: ${response.data}');

    final raw = response.data;
    List data = [];
    if (raw is Map) {
      data = raw['data'] as List? ?? [];
    } else if (raw is List) {
      data = raw;
    }

    return data
        .whereType<Map>()
        .map((e) => NotificationModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> markAsRead(String notificationId) async {
    final token = AppPrefs.token ?? '';
    await _dio.put(
      '/api/Notification/read/$notificationId',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  Future<void> markAllAsRead() async {
    final token = AppPrefs.token ?? '';
    await _dio.put(
      '/api/Notification/read-all',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}