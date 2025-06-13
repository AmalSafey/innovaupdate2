// notification_model.dart
class NotificationResponse {
  final String message;
  final List<NotificationData> data;
  final Pagination pagination;
  final Filters filters;

  NotificationResponse({
    required this.message,
    required this.data,
    required this.pagination,
    required this.filters,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      message: json['Message'] ?? '',
      data: (json['Data'] as List<dynamic>?)
              ?.map((item) => NotificationData.fromJson(item))
              .toList() ??
          [],
      pagination: Pagination.fromJson(json['Pagination'] ?? {}),
      filters: Filters.fromJson(json['Filters'] ?? {}),
    );
  }
}

class NotificationData {
  final int id;
  final int dealId;
  final String senderName;
  final String messageText;
  final bool isRead;
  final String createdAt;
  final String messageType;
  final String senderid;

  NotificationData({
    required this.senderid,
    required this.id,
    required this.dealId,
    required this.senderName,
    required this.messageText,
    required this.isRead,
    required this.createdAt,
    required this.messageType,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      senderid: json['SenderId'] ?? '',
      id: json['Id'] ?? 0,
      dealId: json['DealId'] ?? 0,
      senderName: json['SenderName'] ?? '',
      messageText: json['MessageText'] ?? '',
      isRead: json['IsRead'] ?? false,
      createdAt: json['CreatedAt'] ?? '',
      messageType: json['MessageType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SenderId': senderid,
      'Id': id,
      'DealId': dealId,
      'SenderName': senderName,
      'MessageText': messageText,
      'IsRead': isRead,
      'CreatedAt': createdAt,
      'MessageType': messageType,
    };
  }
}

class Pagination {
  final int currentPage;
  final int pageSize;
  final int totalCount;
  final int totalPages;

  Pagination({
    required this.currentPage,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['CurrentPage'] ?? 1,
      pageSize: json['PageSize'] ?? 50,
      totalCount: json['TotalCount'] ?? 0,
      totalPages: json['TotalPages'] ?? 1,
    );
  }
}

class Filters {
  final String? fromDate;
  final String? toDate;
  final String? messageType;
  final bool? isRead;

  Filters({
    this.fromDate,
    this.toDate,
    this.messageType,
    this.isRead,
  });

  factory Filters.fromJson(Map<String, dynamic> json) {
    return Filters(
      fromDate: json['FromDate'],
      toDate: json['ToDate'],
      messageType: json['MessageType'],
      isRead: json['IsRead'],
    );
  }
}

// Enum for message types
enum NotificationMessageType {
  offerAccepted('OfferAccepted'),
  discussOffer('OfferDiscussion'),
  admin('General');

  const NotificationMessageType(this.value);
  final String value;

  static NotificationMessageType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'OfferAccepted':
        return NotificationMessageType.offerAccepted;
      case 'OfferDiscussion':
        return NotificationMessageType.discussOffer;
      case 'General':
        return NotificationMessageType.admin;
      default:
        return NotificationMessageType.offerAccepted;
    }
  }
}
