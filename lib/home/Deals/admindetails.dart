import 'package:flutter/material.dart';
import 'package:innovahub_app/core/Api/acceptmodel.dart';
import 'package:innovahub_app/core/Api/notificationapi.dart';
import 'package:innovahub_app/home/Deals/acceptpage.dart';
import 'package:innovahub_app/home/Deals/completeadmindetalis.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class adminprocess extends StatefulWidget {
  static const String routname = "adminprocess";
  final NotificationData? notificationData;
  const adminprocess({Key? key, this.notificationData}) : super(key: key);

  @override
  State<adminprocess> createState() => _adminprocessState();
}

class _adminprocessState extends State<adminprocess> {
  Future<void> _saveDealIdAndNavigate() async {
    try {
      if (_dealData?.dealId != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('current_deal_id', _dealData!.dealId.toString());
        print('Deal ID saved: ${_dealData!.dealId}'); // For debugging
      }

      Navigator.pushNamed(context, completeadminprocess.routname);
    } catch (e) {
      print('Error saving deal ID: $e');
      // Still navigate even if saving fails
      Navigator.pushNamed(context, completeadminprocess.routname);
    }
  }

  void _launchContractURL() async {
    final url = Uri.parse(
        'https://innova-hub.premiumasp.net/Contracts/contract_deal_1_638853291527254093.pdf');
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Couldn't open the contract URL.")),
      );
    }
  }

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
                      _dealData?.messageText != null
                          ? 'A contract has been generated for your deal "${_dealData!.messageText.split(' ').take(10).join(' ')}${_dealData!.messageText.split(' ').length > 10 ? '...' : ''}". Please review and sign the contract to proceed with the deal.'
                          : 'A contract has been generated for your deal. Please review and sign the contract to proceed with the deal.',
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Color(0xFF555555),
                      ),
                    ),

                    const SizedBox(height: 16),

                    GestureDetector(
                      onTap: _launchContractURL,
                      child: const Text(
                        'Open Contract URL',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Additional info
                    const Text(
                      'The contract will be drafted and sent shortly after completing some required data.',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Color(0xFF555555),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Button
                    Center(
                      child: ElevatedButton(
                        onPressed: _saveDealIdAndNavigate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1976D2),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          'Complete Process',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Contract terms
                    const Text(
                      'Contract terms:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'All further details will be included in the contract.',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Color(0xFF555555),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Thank you for placing your trust in us.',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Color(0xFF555555),
                      ),
                    ),

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
