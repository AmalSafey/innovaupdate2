

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class InvestorInvestment {
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

  InvestorInvestment({
    required this.investmentId,
    required this.dealId,
    required this.projectName,
    required this.investorName,
    required this.ownerName,
    required this.investmentAmount,
    required this.equityPercentage,
    required this.status,
    required this.createdAt,
    required this.totalProfit,
    required this.lastDistribution,
    required this.durationType,
    required this.durationInMonths,
    required this.startDate,
    required this.endDate,
    required this.remainingDays,
    required this.isAutoRenew,
  });

  factory InvestorInvestment.fromJson(Map<String, dynamic> json) {
    return InvestorInvestment(
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

Future<List<InvestorInvestment>> fetchInvestorInvestments() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  final url = Uri.parse(
      'https://innova-hub.premiumasp.net/api/Investment/investor-investments');

  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((item) => InvestorInvestment.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load investments');
  }
}

/*Future<List<InvestorInvestment>> fetchInvestorInvestments() async {
  final token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIyYTY2ZDY3Yi01YTRkLTRlNjgtOGQ3Zi04YzgzMTlhZjkyOGUiLCJ1bmlxdWVfbmFtZSI6IlBhc2NhbGVfR2lic29uODUiLCJlbWFpbCI6IlBhc2NhbGVfR2lic29uODVAZ21haWwuY29tIiwibmFtZWlkIjoiMmE2NmQ2N2ItNWE0ZC00ZTY4LThkN2YtOGM4MzE5YWY5MjhlIiwicm9sZSI6IkludmVzdG9yIiwibmJmIjoxNzQ2MjE2OTEwLCJleHAiOjE3NDYzMDMzMTAsImlhdCI6MTc0NjIxNjkxMCwiaXNzIjoiaHR0cHM6Ly9sb2NhbGhvc3Q6NzA3MCIsImF1ZCI6Ik15U2VjdXJpdHlBUElVc2VycyJ9.ZVuEdKPR0oKSRVkNP6mGcNQGd3I4KcwisXCZyPLhyVU';

  final url = Uri.parse(
    'https://innova-hub.premiumasp.net/api/Investment/investor-investments',
  );

  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // التوكن الثابت هنا
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((item) => InvestorInvestment.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load investments');
  }
}*/