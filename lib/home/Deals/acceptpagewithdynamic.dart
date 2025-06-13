import 'package:flutter/material.dart';
import 'package:innovahub_app/core/Api/acceptmodel.dart';
import 'package:innovahub_app/core/Api/notificationapi.dart';

class AcceptPage extends StatelessWidget {
  static const String routeName = 'acceptpage';

  final NotificationData? notificationData;

  const AcceptPage({Key? key, this.notificationData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the notification data from arguments if not passed directly
    final NotificationData? notification = notificationData ??
        ModalRoute.of(context)?.settings.arguments as NotificationData?;

    // Create deal acceptance data from notification
    final DealAcceptanceData? dealData = notification != null
        ? DealAcceptanceData.fromNotification(notification)
        : null;

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
                // Header with sender info and close button
                Row(
                  children: [
                    const Text(
                      'Accept notify',
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

                // Sender Information
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
                      dealData?.senderName ?? 'Unknown Sender',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Verified badge
                    if (dealData?.isVerified == true)
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
                    const Spacer(),
                    // Time and ID info
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 12,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              dealData?.getFormattedTime() ?? 'Unknown time',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'id:${dealData?.id ?? 'N/A'}',
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

                // Dynamic message based on actual notification data
                if (dealData != null) ...[
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                      children: [
                        TextSpan(
                          text:
                              '${dealData.investorName} has accepted your offer for the project ',
                        ),
                        if (dealData.projectName.isNotEmpty)
                          TextSpan(
                            text: '"${dealData.projectName}"',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        if (dealData.offerAmount.isNotEmpty) ...[
                          const TextSpan(
                              text: ' with an investment amount of '),
                          TextSpan(
                            text: dealData.offerAmount,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                        if (dealData.offerPercentage.isNotEmpty) ...[
                          const TextSpan(text: ' and a '),
                          TextSpan(
                            text: '${dealData.offerPercentage}%',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const TextSpan(text: ' equity share'),
                        ],
                        const TextSpan(text: '.'),
                      ],
                    ),
                  ),
                ] else ...[
                  // Fallback text if no deal data available
                  Text(
                    notification?.messageText ??
                        'No message content available.',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                const Text(
                  'The request will now be forwarded to the platform for further review and Admin response.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),

                // Deal ID
                Row(
                  children: [
                    const Text(
                      'Deal ID : ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${dealData?.dealId ?? 'N/A'}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Accept & Send Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle accept and send action
                      _showSuccessDialog(context, dealData);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1976D2),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Accept & send',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Notes Section
                const Text(
                  '*Note',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),

                _buildNoteItem(
                    'A 1% platform fee applies for every 10% profit generated from the product revenue.'),
                const SizedBox(height: 8),
                _buildNoteItem(
                    'If the platform approves the request, a contract will be sent to both parties.'),
                const SizedBox(height: 8),
                _buildNoteItem(
                    'The contract will include a defined time frame and will be void if any discrepancies are found.'),
                const SizedBox(height: 32),

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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoteItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '- ',
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

  void _showSuccessDialog(BuildContext context, DealAcceptanceData? dealData) {
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
          content: Text(
            dealData != null
                ? 'Your acceptance for Deal ID ${dealData.dealId} has been sent successfully. The platform will review and process your request.'
                : 'Your acceptance has been sent successfully. The platform will review and process your request.',
            style: const TextStyle(
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
        );
      },
    );
  }
}
