// deal_acceptance_model.dart
import 'package:innovahub_app/core/Api/notificationapi.dart';

class DealAcceptanceData {
  final int id;
  final int dealId;
  final String senderName;
  final String messageText;
  final String createdAt;
  final String projectName;
  final String offerAmount;
  final String offerPercentage;
  final String investorName;
  final bool isVerified;
  final String senderid;

  DealAcceptanceData({
    required this.senderid,
    required this.id,
    required this.dealId,
    required this.senderName,
    required this.messageText,
    required this.createdAt,
    this.projectName = '',
    this.offerAmount = '',
    this.offerPercentage = '',
    this.investorName = '',
    this.isVerified = false,
  });

  factory DealAcceptanceData.fromNotification(NotificationData notification) {
    // Parse the message text to extract deal details
    String projectName = '';
    String offerAmount = '';
    String offerPercentage = '';
    String investorName = notification.senderName;

    // Try to extract project name from message
    // Example: "Deal offer accepted for your project: The Samsung Galaxy S25 Ultra"
    final projectMatch =
        RegExp(r'project:\s*([^.]+)').firstMatch(notification.messageText);
    if (projectMatch != null) {
      projectName = projectMatch.group(1)?.trim() ?? '';
    }

    // Try to extract offer details if available in message
    final amountMatch =
        RegExp(r'amount[:\s]*([^\s]+)').firstMatch(notification.messageText);
    if (amountMatch != null) {
      offerAmount = amountMatch.group(1) ?? '';
    }

    final percentageMatch =
        RegExp(r'(\d+)%').firstMatch(notification.messageText);
    if (percentageMatch != null) {
      offerPercentage = percentageMatch.group(1) ?? '';
    }

    return DealAcceptanceData(
      senderid: notification.senderid,
      id: notification.id,
      dealId: notification.dealId,
      senderName: notification.senderName,
      messageText: notification.messageText,
      createdAt: notification.createdAt,
      projectName: projectName,
      offerAmount: offerAmount,
      offerPercentage: offerPercentage,
      investorName: investorName,
      isVerified: true, // Assuming verified users
    );
  }

  // Helper method to format time
  String getFormattedTime() {
    try {
      DateTime dateTime = DateTime.parse(createdAt.replaceAll(' ', 'T'));
      DateTime now = DateTime.now();
      Duration difference = now.difference(dateTime);

      if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else {
        return '${difference.inDays}d ago';
      }
    } catch (e) {
      return createdAt;
    }
  }
}
