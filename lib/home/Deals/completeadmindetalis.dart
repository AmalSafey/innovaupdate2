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

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print('Payment intent response: $responseData');

        // Extract PaymentIntentId from response
        String? paymentIntentId = responseData['PaymentIntentId'];
        String? clientSecret = responseData['ClientSecret'];
        String? message = responseData['Message'];

        print('Payment Intent Created: $message');
        print('PaymentIntentId: $paymentIntentId');

        if (paymentIntentId == null) {
          emit(PaymentProcessErrorState(
              message: 'PaymentIntentId not found in response'));
          return;
        }

        // Step 2: Confirm Payment
        print('Step 2: Confirming payment...');
        await _confirmPayment(token, paymentIntentId);
      } else {
        var responseBody = jsonDecode(response.body);
        emit(PaymentProcessErrorState(
          message: responseBody['message'] ?? 'Failed to create payment intent',
        ));
      }
    } catch (e) {
      print('Error in processPayment: $e');
      emit(PaymentProcessErrorState(message: 'Error: $e'));
    }
  }

  Future<void> _confirmPayment(String token, String paymentIntentId) async {
    try {
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
        var confirmResponseBody = jsonDecode(confirmResponse.body);
        emit(PaymentProcessErrorState(
          message:
              confirmResponseBody['message'] ?? 'Failed to confirm payment',
        ));
      }
    } catch (e) {
      print('Error in confirmPayment: $e');
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
  PaymentProcessSuccessState({required this.message});
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        emit(PaymentProcessSuccessState(
          message: responseData['message'] ?? 'Payment processed successfully',
        ));
      } else {
        var responseBody = jsonDecode(response.body);
        emit(PaymentProcessErrorState(
          message: responseBody['message'] ?? 'Failed to process payment',
        ));
      }
    } catch (e) {
      emit(PaymentProcessErrorState(message: 'Error: $e'));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A1A),
      body: BlocListener<PaymentProcessCubit, PaymentProcessState>(
        listener: (context, state) {
          if (state is PaymentProcessSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            // Navigate back or to success page
            Navigator.of(context).pop();
          } else if (state is PaymentProcessErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
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
}*/

/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// States for Payment Process
abstract class PaymentProcessState {}

class PaymentProcessInitialState extends PaymentProcessState {}

class PaymentProcessLoadingState extends PaymentProcessState {}

class PaymentProcessSuccessState extends PaymentProcessState {
  final String message;
  final Map<String, dynamic>? responseData;
  PaymentProcessSuccessState({required this.message, this.responseData});
}

class PaymentProcessErrorState extends PaymentProcessState {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? errorDetails;
  PaymentProcessErrorState({
    required this.message,
    this.statusCode,
    this.errorDetails,
  });
}

// Enhanced Cubit with better error handling and debugging
class PaymentProcessCubit extends Cubit<PaymentProcessState> {
  PaymentProcessCubit() : super(PaymentProcessInitialState());

  static const String paymentApi =
      "https://innova-hub.premiumasp.net/api/Payment/process-mobile-payment";

  Future<void> processPayment({
    required int dealId,
    required int durationInMonths,
  }) async {
    emit(PaymentProcessLoadingState());

    try {
      print('🚀 Starting payment process...');
      print('📦 Deal ID: $dealId');
      print('⏰ Duration: $durationInMonths months');

      // Get token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      if (token == null || token.isEmpty) {
        print('❌ Authentication token not found');
        emit(PaymentProcessErrorState(
          message: 'Authentication token not found. Please login again.',
          statusCode: 401,
        ));
        return;
      }

      print('🔑 Token found: ${token.substring(0, 20)}...');

      // Prepare request body
      final requestBody = {
        "DealId": dealId,
        "DurationInMonths": durationInMonths,
      };

      print('📝 Request body: ${jsonEncode(requestBody)}');
      print('🌐 API URL: $paymentApi');

      final response = await http.post(
        Uri.parse(paymentApi),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print('📊 Response Status Code: ${response.statusCode}');
      print('📋 Response Headers: ${response.headers}');
      print('📄 Response Body: ${response.body}');

      // Handle different status codes
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final responseData = jsonDecode(response.body);
          print('✅ Payment successful!');
          emit(PaymentProcessSuccessState(
            message:
                responseData['message'] ?? 'Payment processed successfully',
            responseData: responseData,
          ));
        } catch (e) {
          print('⚠️ Success but failed to parse response: $e');
          emit(PaymentProcessSuccessState(
            message: 'Payment processed successfully',
          ));
        }
      } else if (response.statusCode == 400) {
        // Bad Request - usually validation errors
        try {
          final errorData = jsonDecode(response.body);
          print('❌ Bad Request Error: $errorData');
          emit(PaymentProcessErrorState(
            message: errorData['message'] ?? 'Invalid request data',
            statusCode: response.statusCode,
            errorDetails: errorData,
          ));
        } catch (e) {
          emit(PaymentProcessErrorState(
            message: 'Bad request: ${response.body}',
            statusCode: response.statusCode,
          ));
        }
      } else if (response.statusCode == 401) {
        // Unauthorized
        print('❌ Unauthorized: Token may be expired');
        emit(PaymentProcessErrorState(
          message: 'Authentication failed. Please login again.',
          statusCode: response.statusCode,
        ));
      } else if (response.statusCode == 403) {
        // Forbidden
        print('❌ Forbidden: Insufficient permissions');
        emit(PaymentProcessErrorState(
          message: 'You do not have permission to perform this action.',
          statusCode: response.statusCode,
        ));
      } else if (response.statusCode == 404) {
        // Not Found
        print('❌ Not Found: Deal or endpoint not found');
        emit(PaymentProcessErrorState(
          message: 'Deal not found or invalid endpoint.',
          statusCode: response.statusCode,
        ));
      } else if (response.statusCode >= 500) {
        // Server Error
        print('❌ Server Error: ${response.statusCode}');
        emit(PaymentProcessErrorState(
          message: 'Server error. Please try again later.',
          statusCode: response.statusCode,
        ));
      } else {
        // Other errors
        try {
          final errorData = jsonDecode(response.body);
          print('❌ Other Error: $errorData');
          emit(PaymentProcessErrorState(
            message: errorData['message'] ?? 'Failed to process payment',
            statusCode: response.statusCode,
            errorDetails: errorData,
          ));
        } catch (e) {
          emit(PaymentProcessErrorState(
            message: 'HTTP ${response.statusCode}: ${response.body}',
            statusCode: response.statusCode,
          ));
        }
      }
    } catch (e) {
      print('💥 Exception occurred: $e');
      if (e.toString().contains('SocketException') ||
          e.toString().contains('TimeoutException')) {
        emit(PaymentProcessErrorState(
          message: 'Network error. Please check your internet connection.',
        ));
      } else {
        emit(PaymentProcessErrorState(
          message: 'Unexpected error: ${e.toString()}',
        ));
      }
    }
  }

  // Method to validate deal data before payment
  Future<bool> validateDealData(int dealId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      if (token == null) return false;

      // You might want to add a validation endpoint call here
      print('🔍 Validating deal ID: $dealId');

      return true; // For now, return true if token exists
    } catch (e) {
      print('❌ Validation error: $e');
      return false;
    }
  }
}

// Enhanced UI with better error display and debugging info
class completeadminprocess extends StatefulWidget {
  static const String routname = "completeadminprocess";
  final int? dealId;

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

class PaymentProcessPage extends StatefulWidget {
  final int? dealId;

  const PaymentProcessPage({Key? key, this.dealId}) : super(key: key);

  @override
  _PaymentProcessPageState createState() => _PaymentProcessPageState();
}

class _PaymentProcessPageState extends State<PaymentProcessPage> {
  final TextEditingController _durationController = TextEditingController();
  int? _dealId;
  bool _showDebugInfo = false;

  @override
  void initState() {
    super.initState();
    _durationController.text = "12";
    _loadDealId();
  }

  Future<void> _loadDealId() async {
    print('🔄 Loading Deal ID...');

    if (widget.dealId != null) {
      _dealId = widget.dealId;
      print('✅ Deal ID from widget: $_dealId');
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? dealIdString = prefs.getString("current_deal_id");
      print('🔍 Deal ID from SharedPreferences: $dealIdString');

      if (dealIdString != null) {
        _dealId = int.tryParse(dealIdString);
        print('✅ Parsed Deal ID: $_dealId');
      } else {
        print('❌ No Deal ID found in SharedPreferences');
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _durationController.dispose();
    super.dispose();
  }

  void _processPayment() {
    if (_dealId == null) {
      print('❌ Deal ID is null, cannot process payment');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Deal ID not found. Please go back and try again.'),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'Debug',
            textColor: Colors.white,
            onPressed: () {
              setState(() {
                _showDebugInfo = !_showDebugInfo;
              });
            },
          ),
        ),
      );
      return;
    }

    final duration = int.tryParse(_durationController.text);
    if (duration == null || duration <= 0) {
      print('❌ Invalid duration: ${_durationController.text}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Please enter a valid duration in months (must be greater than 0)'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    print('🚀 Initiating payment process...');
    context.read<PaymentProcessCubit>().processPayment(
          dealId: _dealId!,
          durationInMonths: duration,
        );
  }

  Widget _buildDebugInfo() {
    if (!_showDebugInfo) return SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Debug Information',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red[700],
            ),
          ),
          SizedBox(height: 8),
          Text('Widget Deal ID: ${widget.dealId}'),
          Text('Current Deal ID: $_dealId'),
          Text('Duration: ${_durationController.text}'),
          FutureBuilder<SharedPreferences>(
            future: SharedPreferences.getInstance(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final prefs = snapshot.data!;
                final token = prefs.getString("token");
                final dealIdString = prefs.getString("current_deal_id");

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Stored Deal ID: $dealIdString'),
                    Text('Token exists: ${token != null}'),
                    if (token != null) Text('Token preview: '),
                  ],
                );
              }
              return Text('Loading debug info...');
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A1A),
      body: BlocListener<PaymentProcessCubit, PaymentProcessState>(
        listener: (context, state) {
          if (state is PaymentProcessSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 3),
              ),
            );
            Navigator.of(context).pop();
          } else if (state is PaymentProcessErrorState) {
            String errorMessage = state.message;
            if (state.statusCode != null) {
              errorMessage += ' (Status: ${state.statusCode})';
            }

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 5),
                action: SnackBarAction(
                  label: 'Details',
                  textColor: Colors.white,
                  onPressed: () {
                    _showErrorDialog(context, state);
                  },
                ),
              ),
            );
          }
        },
        child: Center(
          child: SingleChildScrollView(
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
                            Row(
                              children: [
                                // Debug toggle button
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _showDebugInfo = !_showDebugInfo;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    child: Icon(
                                      Icons.bug_report,
                                      size: 20,
                                      color: _showDebugInfo
                                          ? Colors.red
                                          : Colors.grey[400],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
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
                          ],
                        ),

                        _buildDebugInfo(),

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

                        Text(
                          'Please complete the required information below.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF777777),
                          ),
                        ),

                        SizedBox(height: 24),

                        // Deal ID display with status indicator
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _dealId != null
                                ? Colors.green[50]
                                : Colors.red[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _dealId != null
                                  ? Colors.green[300]!
                                  : Colors.red[300]!,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _dealId != null
                                    ? Icons.check_circle
                                    : Icons.error,
                                color:
                                    _dealId != null ? Colors.green : Colors.red,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Deal ID: ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF333333),
                                ),
                              ),
                              Text(
                                _dealId?.toString() ?? 'Not Found',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: _dealId != null
                                      ? Color(0xFF555555)
                                      : Colors.red,
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
                          child: BlocBuilder<PaymentProcessCubit,
                              PaymentProcessState>(
                            builder: (context, state) {
                              final isLoading =
                                  state is PaymentProcessLoadingState;

                              return ElevatedButton(
                                onPressed: (isLoading || _dealId == null)
                                    ? null
                                    : _processPayment,
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
                                        _dealId == null
                                            ? 'Deal ID Required'
                                            : 'Complete Payment',
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
                            ]),
                      ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, PaymentProcessErrorState state) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Payment Error Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Error Message:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(state.message),
              SizedBox(height: 16),
              if (state.statusCode != null) ...[
                Text('Status Code:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(state.statusCode.toString()),
                SizedBox(height: 16),
              ],
              if (state.errorDetails != null) ...[
                Text('Error Details:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(jsonEncode(state.errorDetails)),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}

// Helper function
*/
