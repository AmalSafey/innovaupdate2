
import 'dart:convert';
import 'package:http/http.dart' as http;

class DeliveryMethod {
  final int id;
  final String shortName;
  final String description;
  final double cost;
  final String deliveryTime;

  DeliveryMethod({
    required this.id,
    required this.shortName,
    required this.description,
    required this.cost,
    required this.deliveryTime,
  });

  factory DeliveryMethod.fromJson(Map<String, dynamic> json) {
    return DeliveryMethod(
      id: json['Id'],
      shortName: json['ShortName'],
      description: json['Description'],
      cost: (json['Cost'] as num).toDouble(),
      deliveryTime: json['DeliveryTime'],
    );
  }
}

class DeliveryService {
  static const String apiUrl =
      'https://innova-hub.premiumasp.net/api/order/GetAllDeliveryMethod';

  static Future<List<DeliveryMethod>> fetchDeliveryMethods() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => DeliveryMethod.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load delivery methods');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

