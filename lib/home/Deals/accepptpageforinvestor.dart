import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:innovahub_app/core/Api/acceptmodel.dart';
import 'package:innovahub_app/core/Api/notificationapi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DealAcceptanceService {
  static const String acceptDealEndpoint =
      'https://innova-hub.premiumasp.net/api/Deals/respond-to-offer'; // Replace with your actual endpoint

  Future<bool> acceptDeal({
    required int dealId,
    required String investorId,
    required String message,
  }) async {
    try {
      // Get token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await http.post(
        Uri.parse(acceptDealEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Add token to headers
        },
        body: jsonEncode({
          "DealId": dealId,
          "InvestorId": investorId,
          "IsAccepted": true,
          "Message": message,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print('Error accepting deal: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception in acceptDeal: $e');
      return false;
    }
  }
}

class AcceptPageforinvestor extends StatefulWidget {
  static const String routeName = 'AcceptPageforinvestor';

  final NotificationData? notificationData;

  const AcceptPageforinvestor({Key? key, this.notificationData})
      : super(key: key);

  @override
  _AcceptPageState createState() => _AcceptPageState();
}

class _AcceptPageState extends State<AcceptPageforinvestor> {
  final DealAcceptanceService _dealService = DealAcceptanceService();
  final TextEditingController _messageController = TextEditingController();
  bool _isLoading = false;
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
    _messageController.dispose();
    super.dispose();
  }

  Widget _buildNoteItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '• ',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _acceptDeal() async {
    if (_dealData == null) {
      _showErrorDialog('Deal data not available');
      return;
    }

    String message = _messageController.text.trim();
    if (message.isEmpty) {
      _showErrorDialog('Please enter a message');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      bool success = await _dealService.acceptDeal(
        dealId: _dealData!.dealId,
        investorId: _dealData!.senderid, // Using senderid as investorId
        message: message,
      );

      if (success) {
        _showSuccessDialog(context);
      } else {
        _showErrorDialog('Failed to accept deal. Please try again.');
      }
    } catch (e) {
      _showErrorDialog('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
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
          'Your acceptance has been sent successfully. The platform will review and process your request.',
          style: TextStyle(
            fontSize: 16,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Close accept page
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
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: const [
            Icon(
              Icons.error,
              color: Colors.red,
              size: 28,
            ),
            SizedBox(width: 12),
            Text(
              'Error',
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
            onPressed: () => Navigator.of(context).pop(),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(24),
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
                // Header with close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Accept Notification',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
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
                const SizedBox(height: 16),

                // Sender info section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                          _dealData?.senderName ?? 'Unknown Sender',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Verified badge
                        if (_dealData?.isVerified == true)
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
                                Icon(
                                  Icons.verified,
                                  color: Colors.white,
                                  size: 12,
                                ),
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
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Time and ID info
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 12,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _dealData?.getFormattedTime() ?? 'Unknown time',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'id:${_dealData?.id ?? 'N/A'}',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Message Content
                const Text(
                  'Hello There,',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),

                // Dynamic message content
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Text(
                    _dealData?.messageText ?? 'No message content available.',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                // Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Innova Hub Team',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Text(
                      '2025',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
