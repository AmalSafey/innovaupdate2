/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:innovahub_app/core/Api/acceptmodel.dart';
import 'package:innovahub_app/core/Api/notificationapi.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:innovahub_app/home/Deals/acceptpage.dart';
import 'package:innovahub_app/home/Deals/admindetails.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// States for Payment Process
abstract class PaymentProcessState {}

class PaymentProcessInitialState extends PaymentProcessState {}

class PaymentProcessLoadingState extends PaymentProcessState {}

class PaymentProcessSuccessState extends PaymentProcessState {
  final String message;
  final String? contractUrl;
  PaymentProcessSuccessState({required this.message, this.contractUrl});
}

class PaymentProcessErrorState extends PaymentProcessState {
  final String message;
  PaymentProcessErrorState({required this.message});
}

// Cubit for Payment Process
class PaymentProcessCubit extends Cubit<PaymentProcessState> {
  PaymentProcessCubit() : super(PaymentProcessInitialState());

  static const String paymentApi =
      "https://innova-hub.premiumasp.net/api/Payment/process-mobile-payment";
  static const String confirmPaymentApi =
      "https://innova-hub.premiumasp.net/api/Payment/confirm-mobile-payment";

  Future<void> processPayment({
    required int dealId,
    required int durationInMonths,
  }) async {
    emit(PaymentProcessLoadingState());

    try {
      // Get token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      if (token == null) {
        emit(PaymentProcessErrorState(
            message: 'Authentication token not found'));
        return;
      }

      // Step 1: Create Payment Intent
      print('Step 1: Creating payment intent...');
      print('Request body: ${jsonEncode({
            "DealId": dealId,
            "DurationInMonths": durationInMonths,
          })}');

      final response = await http.post(
        Uri.parse(paymentApi),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "DealId": dealId,
          "DurationInMonths": durationInMonths,
        }),
      );

      print('Payment intent status code: ${response.statusCode}');
      print('Payment intent response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print('Payment intent response: $responseData');

        // Extract PaymentIntentId from response
        String? paymentIntentId = responseData['PaymentIntentId'];
        String? clientSecret = responseData['ClientSecret'];
        String? message = responseData['Message'];

        print('Payment Intent Created: $message');
        print('PaymentIntentId: $paymentIntentId');
        print('ClientSecret: $clientSecret');

        if (paymentIntentId == null) {
          emit(PaymentProcessErrorState(
              message: 'PaymentIntentId not found in response'));
          return;
        }

        // Step 2: Confirm Payment
        print('Step 2: Confirming payment...');
        await _confirmPayment(token, paymentIntentId);
      } else {
        String errorMessage = 'Failed to create payment intent';

        try {
          var responseBody = jsonDecode(response.body);
          print('Error creating payment intent: $responseBody');

          errorMessage = responseBody['message'] ??
              responseBody['Message'] ??
              responseBody['error'] ??
              responseBody['Error'] ??
              'Failed to create payment intent (Status: ${response.statusCode})';
        } catch (e) {
          print('Error parsing payment intent error response: $e');
          errorMessage =
              'Failed to create payment intent (Status: ${response.statusCode}) - ${response.body}';
        }

        emit(PaymentProcessErrorState(message: errorMessage));
      }
    } catch (e) {
      print('Exception in processPayment: $e');
      emit(PaymentProcessErrorState(message: 'Error: $e'));
    }
  }

  Future<void> _confirmPayment(String token, String paymentIntentId) async {
    try {
      print('Confirming payment with PaymentIntentId: $paymentIntentId');

      final confirmResponse = await http.post(
        Uri.parse(confirmPaymentApi),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "PaymentIntentId": paymentIntentId,
        }),
      );

      print('Confirm payment status code: ${confirmResponse.statusCode}');
      print('Confirm payment response body: ${confirmResponse.body}');

      if (confirmResponse.statusCode == 200 ||
          confirmResponse.statusCode == 201) {
        final confirmResponseData = jsonDecode(confirmResponse.body);
        print('Payment confirmation response: $confirmResponseData');

        String message =
            confirmResponseData['Message'] ?? 'Payment confirmed successfully';
        String? contractUrl = confirmResponseData['ContractUrl'];

        print('Final Message: $message');
        if (contractUrl != null) {
          print('Contract URL: $contractUrl');
        }

        emit(PaymentProcessSuccessState(
          message: message,
          contractUrl: contractUrl,
        ));
      } else {
        // Enhanced error handling
        String errorMessage = 'Failed to confirm payment';

        try {
          var confirmResponseBody = jsonDecode(confirmResponse.body);
          print('Error response body: $confirmResponseBody');

          // Try different possible error message keys
          errorMessage = confirmResponseBody['message'] ??
              confirmResponseBody['Message'] ??
              confirmResponseBody['error'] ??
              confirmResponseBody['Error'] ??
              'Failed to confirm payment (Status: ${confirmResponse.statusCode})';
        } catch (e) {
          print('Error parsing error response: $e');
          errorMessage =
              'Failed to confirm payment (Status: ${confirmResponse.statusCode}) - ${confirmResponse.body}';
        }

        emit(PaymentProcessErrorState(message: errorMessage));
      }
    } catch (e) {
      print('Exception in confirmPayment: $e');
      emit(PaymentProcessErrorState(message: 'Error confirming payment: $e'));
    }
  }
}

// Updated UI Widget to match your naming convention
class completeadminprocess extends StatefulWidget {
  static const String routname = "completeadminprocess";
  final int? dealId; // Deal ID passed from navigation

  const completeadminprocess({Key? key, this.dealId}) : super(key: key);

  @override
  _completeadminprocessState createState() => _completeadminprocessState();
}

class _completeadminprocessState extends State<completeadminprocess> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentProcessCubit(),
      child: PaymentProcessPage(dealId: widget.dealId),
    );
  }
}

// Separate widget for the actual UI content
class PaymentProcessPage extends StatefulWidget {
  final NotificationData? notificationData;
  final int? dealId;

  const PaymentProcessPage({Key? key, this.dealId, this.notificationData})
      : super(key: key);

  @override
  _PaymentProcessPageState createState() => _PaymentProcessPageState();
}

class _PaymentProcessPageState extends State<PaymentProcessPage> {
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final DealAcceptanceService _dealService = DealAcceptanceService();

  int? _dealId;
  bool _isLoading = false;
  DealAcceptanceData? _dealData;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _durationController.text = "12"; // Default value
    _loadDealId();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      final NotificationData? notification = widget.notificationData ??
          ModalRoute.of(context)?.settings.arguments as NotificationData?;

      if (notification != null) {
        setState(() {
          _dealData = DealAcceptanceData.fromNotification(notification);
          // Set deal ID from notification data if available
          if (_dealData?.dealId != null) {
            _dealId = _dealData!.dealId;
          }
        });
      }

      _isInitialized = true;
    }
  }

  Future<void> _loadDealId() async {
    // Priority order: widget.dealId -> notification data -> SharedPreferences
    if (widget.dealId != null) {
      _dealId = widget.dealId;
    } else if (_dealData?.dealId != null) {
      _dealId = _dealData!.dealId;
    } else {
      // Try to get deal ID from SharedPreferences if not passed
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? dealIdString = prefs.getString("current_deal_id");
      if (dealIdString != null) {
        _dealId = int.tryParse(dealIdString);
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _durationController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _processPayment() {
    // Debug print to see what deal ID we have
    print('Current deal ID: $_dealId');
    print('Deal data: ${_dealData?.dealId}');

    if (_dealId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Deal ID not found'),
          backgroundColor: Constant.mainColor,
        ),
      );
      return;
    }

    final duration = int.tryParse(_durationController.text);
    if (duration == null || duration <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid duration in months'),
          backgroundColor: Constant.mainColor,
        ),
      );
      return;
    }

    context.read<PaymentProcessCubit>().processPayment(
          dealId: _dealId!,
          durationInMonths: duration,
        );
  }

  void _showSuccessDialog(String message, String? contractUrl) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 28,
              ),
              SizedBox(width: 12),
              Text(
                'Payment Successful',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF555555),
                  height: 1.4,
                ),
              ),
              if (contractUrl != null) ...[
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.blue.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.description, color: Colors.blue, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Contract: $contractUrl',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to previous screen
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'OK',
                style: TextStyle(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A1A),
      body: BlocListener<PaymentProcessCubit, PaymentProcessState>(
        listener: (context, state) {
          if (state is PaymentProcessSuccessState) {
            // Print the message to console
            print('SUCCESS MESSAGE: ${state.message}');
            if (state.contractUrl != null) {
              print('CONTRACT URL: ${state.contractUrl}');
            }

            // Show success dialog with message
            _showSuccessDialog(state.message, state.contractUrl);
          } else if (state is PaymentProcessErrorState) {
            // Print error message to console
            print('ERROR MESSAGE: ${state.message}');

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.error, color: Colors.white),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.message,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 5),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: EdgeInsets.all(16),
              ),
            );
          }
        },
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 500),
            margin: EdgeInsets.all(24),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with close button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Payment Process',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Icon(
                            Icons.close,
                            size: 24,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 24),

                    // Blue info box
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Color(0xFF2196F3).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'In this step, you will confirm the deal and pay the business owner the full offer amount.',
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: Color(0xFF555555),
                        ),
                      ),
                    ),

                    SizedBox(height: 24),

                    // Instruction text
                    Text(
                      'Please complete the required information below.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF777777),
                      ),
                    ),

                    SizedBox(height: 24),

                    // Deal ID display
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Deal ID: ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF777777),
                            ),
                          ),
                          Text(
                            _dealId?.toString() ?? 'Loading...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF333333),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16),

                    // Duration time field
                    TextField(
                      controller: _durationController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Duration time (months)',
                        hintText: 'Enter duration in months',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16,
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Color(0xFF2196F3),
                            width: 2,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),

                    SizedBox(height: 12),

                    // Note text
                    Text(
                      'Note: The duration should be in months, the default is 12',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),

                    SizedBox(height: 32),

                    // Complete button with loading state
                    Center(
                      child:
                          BlocBuilder<PaymentProcessCubit, PaymentProcessState>(
                        builder: (context, state) {
                          final isLoading = state is PaymentProcessLoadingState;

                          return ElevatedButton(
                            onPressed: isLoading ? null : _processPayment,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF1976D2),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 2,
                            ),
                            child: isLoading
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Complete process',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 32),

                    // Footer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Innova Hub App',
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
*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:innovahub_app/core/Api/acceptmodel.dart';
import 'package:innovahub_app/core/Api/notificationapi.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:innovahub_app/home/Deals/acceptpage.dart';
import 'package:innovahub_app/home/Deals/admindetails.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this import

// States for Payment Process
abstract class PaymentProcessState {}

class PaymentProcessInitialState extends PaymentProcessState {}

class PaymentProcessLoadingState extends PaymentProcessState {}

class PaymentProcessSuccessState extends PaymentProcessState {
  final String message;
  final String? contractUrl;
  PaymentProcessSuccessState({required this.message, this.contractUrl});
}

class PaymentProcessErrorState extends PaymentProcessState {
  final String message;
  PaymentProcessErrorState({required this.message});
}

// Cubit for Payment Process
class PaymentProcessCubit extends Cubit<PaymentProcessState> {
  PaymentProcessCubit() : super(PaymentProcessInitialState());

  static const String paymentApi =
      "https://innova-hub.premiumasp.net/api/Payment/process-mobile-payment";
  static const String confirmPaymentApi =
      "https://innova-hub.premiumasp.net/api/Payment/confirm-mobile-payment";

  Future<void> processPayment({
    required int dealId,
    required int durationInMonths,
  }) async {
    emit(PaymentProcessLoadingState());

    try {
      // Get token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      if (token == null) {
        emit(PaymentProcessErrorState(
            message: 'Authentication token not found'));
        return;
      }

      // Step 1: Create Payment Intent
      print('Step 1: Creating payment intent...');
      print('Request body: ${jsonEncode({
            "DealId": dealId,
            "DurationInMonths": durationInMonths,
          })}');

      final response = await http.post(
        Uri.parse(paymentApi),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "DealId": dealId,
          "DurationInMonths": durationInMonths,
        }),
      );

      print('Payment intent status code: ${response.statusCode}');
      print('Payment intent response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print('Payment intent response: $responseData');

        // Extract PaymentIntentId from response
        String? paymentIntentId = responseData['PaymentIntentId'];
        String? clientSecret = responseData['ClientSecret'];
        String? message = responseData['Message'];

        print('Payment Intent Created: $message');
        print('PaymentIntentId: $paymentIntentId');
        print('ClientSecret: $clientSecret');

        if (paymentIntentId == null) {
          emit(PaymentProcessErrorState(
              message: 'PaymentIntentId not found in response'));
          return;
        }

        // Step 2: Confirm Payment
        print('Step 2: Confirming payment...');
        await _confirmPayment(token, paymentIntentId);
      } else {
        String errorMessage = 'Failed to create payment intent';

        try {
          var responseBody = jsonDecode(response.body);
          print('Error creating payment intent: $responseBody');

          errorMessage = responseBody['message'] ??
              responseBody['Message'] ??
              responseBody['error'] ??
              responseBody['Error'] ??
              'Failed to create payment intent (Status: ${response.statusCode})';
        } catch (e) {
          print('Error parsing payment intent error response: $e');
          errorMessage =
              'Failed to create payment intent (Status: ${response.statusCode}) - ${response.body}';
        }

        emit(PaymentProcessErrorState(message: errorMessage));
      }
    } catch (e) {
      print('Exception in processPayment: $e');
      emit(PaymentProcessErrorState(message: 'Error: $e'));
    }
  }

  Future<void> _confirmPayment(String token, String paymentIntentId) async {
    try {
      print('Confirming payment with PaymentIntentId: $paymentIntentId');

      final confirmResponse = await http.post(
        Uri.parse(confirmPaymentApi),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "PaymentIntentId": paymentIntentId,
        }),
      );

      print('Confirm payment status code: ${confirmResponse.statusCode}');
      print('Confirm payment response body: ${confirmResponse.body}');

      if (confirmResponse.statusCode == 200 ||
          confirmResponse.statusCode == 201) {
        final confirmResponseData = jsonDecode(confirmResponse.body);
        print('Payment confirmation response: $confirmResponseData');

        String message =
            confirmResponseData['Message'] ?? 'Payment confirmed successfully';
        String? contractUrl = confirmResponseData['ContractUrl'];

        print('Final Message: $message');
        if (contractUrl != null) {
          print('Contract URL: $contractUrl');
        }

        emit(PaymentProcessSuccessState(
          message: message,
          contractUrl: contractUrl,
        ));
      } else {
        // Enhanced error handling
        String errorMessage = 'Failed to confirm payment';

        try {
          var confirmResponseBody = jsonDecode(confirmResponse.body);
          print('Error response body: $confirmResponseBody');

          // Try different possible error message keys
          errorMessage = confirmResponseBody['message'] ??
              confirmResponseBody['Message'] ??
              confirmResponseBody['error'] ??
              confirmResponseBody['Error'] ??
              'Failed to confirm payment (Status: ${confirmResponse.statusCode})';
        } catch (e) {
          print('Error parsing error response: $e');
          errorMessage =
              'Failed to confirm payment (Status: ${confirmResponse.statusCode}) - ${confirmResponse.body}';
        }

        emit(PaymentProcessErrorState(message: errorMessage));
      }
    } catch (e) {
      print('Exception in confirmPayment: $e');
      emit(PaymentProcessErrorState(message: 'Error confirming payment: $e'));
    }
  }
}

// Updated UI Widget to match your naming convention
class completeadminprocess extends StatefulWidget {
  static const String routname = "completeadminprocess";
  final int? dealId; // Deal ID passed from navigation

  const completeadminprocess({Key? key, this.dealId}) : super(key: key);

  @override
  _completeadminprocessState createState() => _completeadminprocessState();
}

class _completeadminprocessState extends State<completeadminprocess> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentProcessCubit(),
      child: PaymentProcessPage(dealId: widget.dealId),
    );
  }
}

// Separate widget for the actual UI content
class PaymentProcessPage extends StatefulWidget {
  final NotificationData? notificationData;
  final int? dealId;

  const PaymentProcessPage({Key? key, this.dealId, this.notificationData})
      : super(key: key);

  @override
  _PaymentProcessPageState createState() => _PaymentProcessPageState();
}

class _PaymentProcessPageState extends State<PaymentProcessPage> {
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final DealAcceptanceService _dealService = DealAcceptanceService();

  int? _dealId;
  bool _isLoading = false;
  DealAcceptanceData? _dealData;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _durationController.text = "12"; // Default value
    _loadDealId();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      final NotificationData? notification = widget.notificationData ??
          ModalRoute.of(context)?.settings.arguments as NotificationData?;

      if (notification != null) {
        setState(() {
          _dealData = DealAcceptanceData.fromNotification(notification);
          // Set deal ID from notification data if available
          if (_dealData?.dealId != null) {
            _dealId = _dealData!.dealId;
          }
        });
      }

      _isInitialized = true;
    }
  }

  Future<void> _loadDealId() async {
    // Priority order: widget.dealId -> notification data -> SharedPreferences
    if (widget.dealId != null) {
      _dealId = widget.dealId;
    } else if (_dealData?.dealId != null) {
      _dealId = _dealData!.dealId;
    } else {
      // Try to get deal ID from SharedPreferences if not passed
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? dealIdString = prefs.getString("current_deal_id");
      if (dealIdString != null) {
        _dealId = int.tryParse(dealIdString);
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _durationController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _processPayment() {
    // Debug print to see what deal ID we have
    print('Current deal ID: $_dealId');
    print('Deal data: ${_dealData?.dealId}');

    if (_dealId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Deal ID not found'),
          backgroundColor: Constant.mainColor,
        ),
      );
      return;
    }

    final duration = int.tryParse(_durationController.text);
    if (duration == null || duration <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid duration in months'),
          backgroundColor: Constant.mainColor,
        ),
      );
      return;
    }

    context.read<PaymentProcessCubit>().processPayment(
          dealId: _dealId!,
          durationInMonths: duration,
        );
  }

  // Function to open URL in browser
  Future<void> _openContractUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication, // Opens in external browser
        );
      } else {
        // Fallback: show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Could not open contract URL'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('Error opening URL: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening contract URL'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showSuccessDialog(String message, String? contractUrl) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 28,
              ),
              SizedBox(width: 12),
              Text(
                'Payment Successful',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF555555),
                  height: 1.4,
                ),
              ),
              if (contractUrl != null) ...[
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () => _openContractUrl(contractUrl),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.blue.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.description, color: Colors.blue, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Contract Document',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Tap to open contract',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.open_in_new,
                          color: Colors.blue,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
          actions: [
            if (contractUrl != null)
              TextButton(
                onPressed: () => _openContractUrl(contractUrl),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Open Contract',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to previous screen
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'OK',
                style: TextStyle(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A1A),
      body: BlocListener<PaymentProcessCubit, PaymentProcessState>(
        listener: (context, state) {
          if (state is PaymentProcessSuccessState) {
            // Print the message to console
            print('SUCCESS MESSAGE: ${state.message}');
            if (state.contractUrl != null) {
              print('CONTRACT URL: ${state.contractUrl}');
            }

            // Show success dialog with message
            _showSuccessDialog(state.message, state.contractUrl);
          } else if (state is PaymentProcessErrorState) {
            // Print error message to console
            print('ERROR MESSAGE: ${state.message}');

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.error, color: Colors.white),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.message,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 5),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: EdgeInsets.all(16),
              ),
            );
          }
        },
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 500),
            margin: EdgeInsets.all(24),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with close button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Payment Process',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Icon(
                            Icons.close,
                            size: 24,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 24),

                    // Blue info box
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Color(0xFF2196F3).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'In this step, you will confirm the deal and pay the business owner the full offer amount.',
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: Color(0xFF555555),
                        ),
                      ),
                    ),

                    SizedBox(height: 24),

                    // Instruction text
                    Text(
                      'Please complete the required information below.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF777777),
                      ),
                    ),

                    SizedBox(height: 24),

                    // Deal ID display
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Deal ID: ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF777777),
                            ),
                          ),
                          Text(
                            _dealId?.toString() ?? 'Loading...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF333333),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16),

                    // Duration time field
                    TextField(
                      controller: _durationController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Duration time (months)',
                        hintText: 'Enter duration in months',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16,
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Color(0xFF2196F3),
                            width: 2,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),

                    SizedBox(height: 12),

                    // Note text
                    Text(
                      'Note: The duration should be in months, the default is 12',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),

                    SizedBox(height: 32),

                    // Complete button with loading state
                    Center(
                      child:
                          BlocBuilder<PaymentProcessCubit, PaymentProcessState>(
                        builder: (context, state) {
                          final isLoading = state is PaymentProcessLoadingState;

                          return ElevatedButton(
                            onPressed: isLoading ? null : _processPayment,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF1976D2),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 2,
                            ),
                            child: isLoading
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Complete process',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 32),

                    // Footer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Innova Hub App',
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
