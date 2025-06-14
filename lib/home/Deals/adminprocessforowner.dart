import 'package:flutter/material.dart';
import 'package:innovahub_app/core/Api/acceptmodel.dart';
import 'package:innovahub_app/core/Api/notificationapi.dart';
import 'package:innovahub_app/home/Deals/acceptpage.dart';
import 'package:innovahub_app/home/Deals/completeadmindetalis.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class adminprocessforowner extends StatefulWidget {
  static const String routname = "adminprocessforowner";
  final NotificationData? notificationData;
  const adminprocessforowner({Key? key, this.notificationData})
      : super(key: key);

  @override
  State<adminprocessforowner> createState() => _adminprocessState();
}

class _adminprocessState extends State<adminprocessforowner> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            margin: const EdgeInsets.all(24),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'From: Innova Admin Support',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF333333),
                          ),
                        ),
                        Icon(Icons.close, size: 20, color: Colors.grey[400]),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.access_time,
                            size: 16, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          _dealData?.getFormattedTime() ?? 'Unknown time',
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[500]),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Title
                    const Text(
                      'Welcome!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Message
                    Text(
                      _dealData?.messageText ?? "",
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Color(0xFF555555),
                      ),
                    ),

                    const SizedBox(height: 16),

                    const SizedBox(height: 32),

                    // Footer
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Innova Hub Team',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF333333),
                          ),
                        ),
                        Text(
                          '2025',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF555555),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
