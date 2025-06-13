// notification_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:innovahub_app/core/Api/notificationapi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static const String baseUrl = 'https://innova-hub.premiumasp.net/api';
  static const String notificationHistoryEndpoint =
      '$baseUrl/Notification/history';

  // Get stored token from SharedPreferences
  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Get notification history
  Future<NotificationResponse> getNotificationHistory({
    String? fromDate,
    String? toDate,
    String? messageType,
    bool? isRead,
    int page = 1,
    int pageSize = 50,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      // Build query parameters
      Map<String, String> queryParams = {
        'page': page.toString(),
        'pageSize': pageSize.toString(),
      };

      if (fromDate != null) queryParams['fromDate'] = fromDate;
      if (toDate != null) queryParams['toDate'] = toDate;
      if (messageType != null) queryParams['messageType'] = messageType;
      if (isRead != null) queryParams['isRead'] = isRead.toString();

      // Build URI with query parameters
      final uri = Uri.parse(notificationHistoryEndpoint).replace(
        queryParameters: queryParams,
      );

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        return NotificationResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load notifications: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching notifications: $e');
    }
  }

  // Mark notification as read
  Future<bool> markAsRead(int notificationId) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await http.put(
        Uri.parse('$baseUrl/Notification/$notificationId/mark-read'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error marking notification as read: $e');
      return false;
    }
  }

  // Get unread notification count
  Future<int> getUnreadCount() async {
    try {
      final token = await _getToken();
      if (token == null) {
        return 0;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/Notification/unread-count'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        return jsonData['count'] ?? 0;
      }
      return 0;
    } catch (e) {
      print('Error fetching unread count: $e');
      return 0;
    }
  }
}
