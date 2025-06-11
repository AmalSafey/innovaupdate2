import 'package:flutter/material.dart';
import 'package:innovahub_app/home/Deals/completeadmindetalis.dart';

class adminprocess extends StatelessWidget {
  static const String routname = "adminprocess";

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
                        Icon(
                          Icons.close,
                          size: 20,
                          color: Colors.grey[400],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '1h ago',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Welcome title
                    const Text(
                      'Welcome!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Main content
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: Color(0xFF555555),
                        ),
                        children: [
                          const TextSpan(
                            text:
                                'An Deal has been successfully approved for the project ',
                          ),
                          const TextSpan(
                            text: '[Project Name]',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const TextSpan(text: ' between\n'),
                          const TextSpan(
                            text: '[Owner Name]',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const TextSpan(text: ' and '),
                          const TextSpan(
                            text: '[Investor Name]',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const TextSpan(text: ' with Deal ID: '),
                          const TextSpan(
                            text: '129',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(text: '.'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: Color(0xFF555555),
                        ),
                        children: [
                          TextSpan(
                            text: 'An investment amount of ',
                          ),
                          TextSpan(
                            text: '[Offer Money]',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          TextSpan(
                            text:
                                ' will be transferred via the platform to the\nOwner, with an agreed share of ',
                          ),
                          TextSpan(
                            text: '[Offer Percentage]',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          TextSpan(text: '%.'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Process description
                    const Text(
                      'The contract will be drafted and sent shortly after completing some require data.',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Color(0xFF555555),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Complete process button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, completeadminprocess.routname);
                        },
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
                          'complete process',
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
