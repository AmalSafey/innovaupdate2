import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';

// Define the product search model class to hold product search parameters
class ProductSearchModel {
  final int from;
  final int to;
  final String location;

  ProductSearchModel({
    required this.from,
    required this.to,
    required this.location,
  });

  // Convert search parameters into query string for API call
  String toQueryString() {
    return "?from=$from&to=$to&location=$location";
  }
}

// Define the product model for the API response
class Product {
  final String? productName;
  final String? productAuthor;
  final double? productPriceBeforeDiscount;
  final double? productPriceAfterDiscount;
  final String? productStatus;

  Product({
    this.productName,
    this.productAuthor,
    this.productPriceBeforeDiscount,
    this.productPriceAfterDiscount,
    this.productStatus,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productName: json['ProductName'] as String?,
      productAuthor: json['ProductAuthor'] as String?,
      productPriceBeforeDiscount:
          (json['ProductPriceBeforeDiscount'] as num?)?.toDouble(),
      productPriceAfterDiscount:
          (json['ProductPriceAfterDiscount'] as num?)?.toDouble(),
      productStatus: json['ProductStatus'] as String?,
    );
  }
}

class SearchTap extends StatefulWidget {
  static const String routeName = 'search';

  const SearchTap({super.key});

  @override
  _SearchContainerState createState() => _SearchContainerState();
}

class _SearchContainerState extends State<SearchTap> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  bool _isLoading = false;
  List<Product> _products = [];

  Future<List<Product>> fetchProducts(ProductSearchModel searchParams) async {
    final queryString = searchParams.toQueryString();
    final url = Uri.parse(
      'https://innova-hub.premiumasp.net/api/Product/productsSearchFilter$queryString',
    );

    print('📤 Requesting: $url');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        final products = data.map((json) => Product.fromJson(json)).toList();
        return products;
      } else {
        throw Exception(
            'Failed to load products. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to fetch products: $error');
    }
  }

  void _searchProducts() async {
    if (_fromController.text.isEmpty ||
        _toController.text.isEmpty ||
        _locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      final from = int.parse(_fromController.text);
      final to = int.parse(_toController.text);

      if (from > to) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('From value must be less than To')),
        );
        return;
      }

      final searchParams = ProductSearchModel(
        from: from,
        to: to,
        location: _locationController.text,
      );

      print(
          '🔍 Searching with: from=$from, to=$to, location=${searchParams.location}');

      setState(() {
        _isLoading = true;
      });

      final products = await fetchProducts(searchParams);
      setState(() {
        _products = products;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${error.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Constant.mainColor,
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(60)),
          ),
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text(
                      "Range From",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    const SizedBox(width: 45),
                    SizedBox(
                      height: 30,
                      width: 80,
                      child: TextField(
                        controller: _fromController,
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onSubmitted: (_) => _searchProducts(),
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Text(
                      "to",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      height: 30,
                      width: 80,
                      child: TextField(
                        controller: _toController,
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onSubmitted: (_) => _searchProducts(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Text(
                      "Search by location..",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 30,
                        child: TextField(
                          controller: _locationController,
                          decoration: InputDecoration(
                            hintStyle: const TextStyle(color: Colors.grey),
                            prefixIcon:
                                const Icon(Icons.search, color: Colors.grey),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onSubmitted: (_) => _searchProducts(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Expanded لعرض النتائج
        Expanded(
          child: ListView.builder(
            itemCount: _products.length,
            itemBuilder: (context, index) {
              final product = _products[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // اسم المنتج
                      Text(
                        product.productName ?? 'Unnamed Product',
                        style: const TextStyle(
                          color: Constant.mainColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // اسم المؤلف
                      Text(
                        'by ${product.productAuthor ?? "Unknown"}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // الأسعار
                      Row(
                        children: [
                          if (product.productPriceBeforeDiscount != null)
                            Text(
                              '\$${product.productPriceBeforeDiscount!.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          const SizedBox(width: 10),
                          if (product.productPriceAfterDiscount != null)
                            Text(
                              '\$${product.productPriceAfterDiscount!.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Constant.mainColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // الحالة
                      Align(
                        alignment: Alignment.centerRight,
                        child: Chip(
                          label: Text(
                            product.productStatus ?? 'Unknown',
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor:
                              _getStatusColor(product.productStatus),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'available':
        return Colors.green;
      case 'out of stock':
        return Colors.red;
      case 'limited':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
