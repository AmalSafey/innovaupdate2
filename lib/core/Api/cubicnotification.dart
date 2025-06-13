// notification_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innovahub_app/core/Api/notificationapi.dart';
import 'package:innovahub_app/core/Api/notificationservice.dart';

abstract class NotificationState {}

class NotificationInitialState extends NotificationState {}

class NotificationLoadingState extends NotificationState {}

class NotificationSuccessState extends NotificationState {
  final NotificationResponse notificationResponse;

  NotificationSuccessState({required this.notificationResponse});
}

class NotificationErrorState extends NotificationState {
  final String message;

  NotificationErrorState({required this.message});
}

class NotificationMarkReadState extends NotificationState {
  final int notificationId;

  NotificationMarkReadState({required this.notificationId});
}

// Cubit
class NotificationCubit extends Cubit<NotificationState> {
  final NotificationService _notificationService = NotificationService();

  NotificationCubit() : super(NotificationInitialState());

  // Get notification history
  Future<void> getNotifications({
    String? fromDate,
    String? toDate,
    String? messageType,
    bool? isRead,
    int page = 1,
    int pageSize = 50,
  }) async {
    emit(NotificationLoadingState());

    try {
      final response = await _notificationService.getNotificationHistory(
        fromDate: fromDate,
        toDate: toDate,
        messageType: messageType,
        isRead: isRead,
        page: page,
        pageSize: pageSize,
      );

      emit(NotificationSuccessState(notificationResponse: response));
    } catch (e) {
      emit(NotificationErrorState(message: e.toString()));
    }
  }

  // Mark notification as read
  Future<void> markNotificationAsRead(int notificationId) async {
    try {
      final success = await _notificationService.markAsRead(notificationId);
      if (success) {
        emit(NotificationMarkReadState(notificationId: notificationId));
        // Refresh notifications after marking as read
        await getNotifications(isRead: false);
      }
    } catch (e) {
      emit(NotificationErrorState(message: 'Failed to mark as read: $e'));
    }
  }

  // Get unread notifications only
  Future<void> getUnreadNotifications() async {
    await getNotifications(isRead: false);
  }

  // Get notifications by type
  Future<void> getNotificationsByType(String messageType) async {
    await getNotifications(messageType: messageType, isRead: false);
  }

  // Refresh notifications
  Future<void> refreshNotifications() async {
    await getNotifications(isRead: false);
  }
}
