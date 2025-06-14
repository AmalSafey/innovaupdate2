/*import 'package:flutter/material.dart';
import 'package:innovahub_app/core/Api/acceptmodel.dart';
import 'package:innovahub_app/core/Api/notificationapi.dart';
import 'package:innovahub_app/home/Deals/dealacceptservice.dart';

class DiscussPage extends StatefulWidget {
  static const String routeName = 'discuss';
  final NotificationData? notificationData;

  const DiscussPage({Key? key, this.notificationData}) : super(key: key);

  @override
  _DiscussNotificationPageState createState() =>
      _DiscussNotificationPageState();
}

class _DiscussNotificationPageState extends State<DiscussPage> {
  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  final TextEditingController _replyController = TextEditingController();
  final DealAcceptanceService _dealService = DealAcceptanceService();
  DealAcceptanceData? _dealData;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      final NotificationData? notification = widget.notificationData ??
          ModalRoute.of(context)?.settings.arguments as NotificationData?;

      if (notification != null) {
        setState(() {
          _dealData = DealAcceptanceData.fromNotification(notification);
        });
      }

      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  void _handleReply() {
    // TODO: Handle reply logic with _replyController.text and _dealData
    final message = _replyController.text;
    if (message.isNotEmpty && _dealData != null) {
      print('Replying with message: $message');
      // Send to API here
    }
  }

  @override
  Widget build(BuildContext context) {
    final senderName = _dealData?.senderName ?? 'Unknown Sender';
    final messageComment = _dealData?.messageText ?? 'No message provided.';
    final investorName = _dealData?.investorName ?? 'Investor';
    final timestamp = _dealData?.getFormattedTime() ?? 'Unknown time';

    final id = _dealData?.id ?? 'N/A';

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 600),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Discuss Notify',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.close,
                        color: Colors.grey[400],
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text(
                      'From: ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      senderName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1976D2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.verified, color: Colors.white, size: 12),
                          SizedBox(width: 4),
                          Text(
                            'Verified',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.access_time,
                                size: 12, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              timestamp,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'id: $id',
                          style:
                              TextStyle(fontSize: 13, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  '$investorName has requested a discussion regarding the following.',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Message Comment:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Text(
                        messageComment,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const Text(
                  'Reply',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Message Reply:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: TextField(
                        controller: _replyController,
                        maxLines: 6,
                        decoration: InputDecoration(
                          hintText: 'Write your response...',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: _handleReply,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1976D2),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Reply',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Innova Hub Team',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '2025',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: const [
              Icon(
                Icons.warning,
                color: Colors.orange,
                size: 28,
              ),
              SizedBox(width: 12),
              Text(
                'Warning',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFF1976D2),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: const [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 28,
              ),
              SizedBox(width: 12),
              Text(
                'Success',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: const Text(
            'Your reply has been sent successfully. The investor will receive your response.',
            style: TextStyle(
              fontSize: 16,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Close discuss page
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFF1976D2),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:innovahub_app/core/Api/acceptmodel.dart';
import 'package:innovahub_app/core/Api/notificationapi.dart';
import 'package:innovahub_app/home/Deals/dealacceptservice.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DealAcceptanceServicefordisscuss {
  static const String acceptDealEndpoint =
      'https://innova-hub.premiumasp.net/api/Deals/respond-to-offer';

  Future<String?> acceptDeal({
    required int dealId,
    required String investorId,
    required String message,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) throw Exception('No authentication token found');

      final response = await http.post(
        Uri.parse(acceptDealEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "DealId": dealId,
          "InvestorId": investorId,
          "IsAccepted": false,
          "Message": message,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = jsonDecode(response.body);
        return body['Message'] ?? 'Action completed successfully';
      } else {
        final body = jsonDecode(response.body);
        return body['Message'] ?? 'Request failed';
      }
    } catch (e) {
      print('Exception in acceptDeal: $e');
      return 'Error occurred';
    }
  }
}

class DiscussPage extends StatefulWidget {
  static const String routeName = 'discuss';
  final NotificationData? notificationData;

  const DiscussPage({Key? key, this.notificationData}) : super(key: key);

  @override
  _DiscussNotificationPageState createState() =>
      _DiscussNotificationPageState();
}

class _DiscussNotificationPageState extends State<DiscussPage> {
  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  final TextEditingController _replyController = TextEditingController();
  final DealAcceptanceService _dealService = DealAcceptanceService();
  final DealAcceptanceServicefordisscuss _discussService =
      DealAcceptanceServicefordisscuss();
  DealAcceptanceData? _dealData;
  bool _isInitialized = false;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      final NotificationData? notification = widget.notificationData ??
          ModalRoute.of(context)?.settings.arguments as NotificationData?;

      if (notification != null) {
        setState(() {
          _dealData = DealAcceptanceData.fromNotification(notification);
        });
      }

      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  void _handleReply() async {
    final message = _replyController.text.trim();

    if (message.isEmpty) {
      _showErrorDialog('Please enter a message before sending your reply.');
      return;
    }

    if (_dealData == null) {
      _showErrorDialog('Deal data is not available. Please try again.');
      return;
    }

    // Validate required fields
    final dealId = _dealData!.id;
    final investorId = _dealData!.senderid;

    if (dealId == null || investorId == null || investorId.isEmpty) {
      _showErrorDialog(
          'Missing required deal information. Please contact support.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Convert dealId to int if it's a string
      int dealIdInt;
      if (dealId is String) {
        dealIdInt = int.tryParse(dealId.toString()) ?? 0;
      } else if (dealId is int) {
        dealIdInt = dealId;
      } else {
        throw Exception('Invalid deal ID format');
      }

      if (dealIdInt == 0) {
        throw Exception('Invalid deal ID');
      }

      final success = await _discussService.acceptDeal(
        dealId: dealIdInt,
        investorId: investorId,
        message: message,
      );

      final resultMessage = await _discussService.acceptDeal(
        dealId: dealIdInt,
        investorId: investorId,
        message: message,
      );

      if (resultMessage != null &&
          resultMessage.toLowerCase().contains("success")) {
        _replyController.clear();
        _showSuccessDialog();
      } else {
        _showErrorDialog(resultMessage ?? 'Failed to send reply');
      }
    } catch (e) {
      print('Error in _handleReply: $e');
      _showErrorDialog(
          'An error occurred while sending your reply. Please try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final senderName = _dealData?.senderName ?? 'Unknown Sender';
    final messageComment = _dealData?.messageText ?? 'No message provided.';
    final investorName = _dealData?.investorName ?? 'Investor';
    final timestamp = _dealData?.getFormattedTime() ?? 'Unknown time';

    final id = _dealData?.id ?? 'N/A';

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 600),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Discuss Notify',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.close,
                        color: Colors.grey[400],
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text(
                      'From: ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      senderName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1976D2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.verified, color: Colors.white, size: 12),
                          SizedBox(width: 4),
                          Text(
                            'Verified',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.access_time,
                                size: 12, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              timestamp,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'id: $id',
                          style:
                              TextStyle(fontSize: 13, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  '$investorName has requested a discussion regarding the following.',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Message Comment:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Text(
                        messageComment,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const Text(
                  'Reply',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Message Reply:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: TextField(
                        controller: _replyController,
                        maxLines: 6,
                        enabled: !_isLoading,
                        decoration: InputDecoration(
                          hintText: 'Write your response...',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleReply,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1976D2),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 2,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Reply',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 32),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Innova Hub Team',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '2025',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: const [
              Icon(
                Icons.warning,
                color: Colors.orange,
                size: 28,
              ),
              SizedBox(width: 12),
              Text(
                'Warning',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFF1976D2),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: const [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 28,
              ),
              SizedBox(width: 12),
              Text(
                'Success',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: const Text(
            'Your reply has been sent successfully. The investor will receive your response.',
            style: TextStyle(
              fontSize: 16,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Close discuss page
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFF1976D2),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
