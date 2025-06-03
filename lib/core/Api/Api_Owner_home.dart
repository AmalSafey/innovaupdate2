

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Investment {
  final int investmentId;
  final int dealId;
  final String projectName;
  final String? investorName;
  final String ownerName;
  final double investmentAmount;
  final double equityPercentage;
  final String status;
  final String createdAt;
  final double totalProfit;
  final String? lastDistribution;
  final String durationType;
  final int durationInMonths;
  final String startDate;
  final String endDate;
  final int? remainingDays;
  final bool isAutoRenew;

  Investment({
    required this.investmentId,
    required this.dealId,
    required this.projectName,
    this.investorName,
    required this.ownerName,
    required this.investmentAmount,
    required this.equityPercentage,
    required this.status,
    required this.createdAt,
    required this.totalProfit,
    this.lastDistribution,
    required this.durationType,
    required this.durationInMonths,
    required this.startDate,
    required this.endDate,
    this.remainingDays,
    required this.isAutoRenew,
  });

  factory Investment.fromJson(Map<String, dynamic> json) {
    return Investment(
      investmentId: json['InvestmentId'],
      dealId: json['DealId'],
      projectName: json['ProjectName'],
      investorName: json['InvestorName'],
      ownerName: json['OwnerName'],
      investmentAmount: (json['InvestmentAmount'] as num).toDouble(),
      equityPercentage: (json['EquityPercentage'] as num).toDouble(),
      status: json['Status'],
      createdAt: json['CreatedAt'],
      totalProfit: (json['TotalProfit'] as num).toDouble(),
      lastDistribution: json['LastDistribution'],
      durationType: json['DurationType'],
      durationInMonths: json['DurationInMonths'],
      startDate: json['StartDate'],
      endDate: json['EndDate'],
      remainingDays: json['RemainingDays'],
      isAutoRenew: json['IsAutoRenew'],
    );
  }
}

class ApiService {
  static const String baseUrl = 'https://innova-hub.premiumasp.net/api';

  Future<List<Investment>> getOwnerInvestments() async {
    try {
      // Get token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/Investment/owner-investments'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((json) => Investment.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load investments: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching investments: $e');
    }
  }
}