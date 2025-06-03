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
  final String name;
  final String description;
  final double price;

  Product({
    required this.name,
    required this.description,
    required this.price,
  });

  // Parse JSON response to Product object
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
    );
  }
}

class SearchContainer extends StatefulWidget {
  const SearchContainer({super.key});

  @override
  _SearchContainerState createState() => _SearchContainerState();
}

class _SearchContainerState extends State<SearchContainer> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  bool _isLoading = false;
  List<Product> _products = [];

  // Method to fetch products based on search parameters
  Future<List<Product>> fetchProducts(ProductSearchModel searchParams) async {
    final url = Uri.parse(
      'https://innova-hub.premiumasp.net/api/Product/productsSearchFilter${searchParams.toQueryString()}',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      throw Exception('Failed to fetch products: $error');
    }
  }

  // Method to handle the search logic
  void _searchProducts() async {
    if (_fromController.text.isEmpty ||
        _toController.text.isEmpty ||
        _locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final searchParams = ProductSearchModel(
      from: int.parse(_fromController.text),
      to: int.parse(_toController.text),
      location: _locationController.text,
    );

    setState(() {
      _isLoading = true;
    });

    try {
      final products = await fetchProducts(searchParams);
      setState(() {
        _products = products;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch products')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Constant.mainColor,
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(60)),
      ),
      width: double.infinity,
      height: 250,
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
                    onSubmitted: (_) =>
                        _searchProducts(), // Call search on Enter
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
                    onSubmitted: (_) =>
                        _searchProducts(), // Call search on Enter
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
                      onSubmitted: (_) =>
                          _searchProducts(), // Call search on Enter
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            // Display products if any
            _isLoading
                ? const CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: _products.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_products[index].name),
                          subtitle: Text(_products[index].description),
                          trailing: Text('\$${_products[index].price}'),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}


/*import 'package:flutter/material.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';

class SearchContainer extends StatelessWidget {
  const SearchContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Constant.mainColor,
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(60)),
      ),
      width: double.infinity,
      height: 150,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
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
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(
                          color: Colors.grey), // Hint text color
                      // Icon color
                      filled: true,
                      fillColor: Colors.white, // TextField background color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none, // Remove border
                      ),
                    ),
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
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(
                          color: Colors.grey), // Hint text color
                      // Icon color
                      filled: true,
                      fillColor: Colors.white, // TextField background color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none, // Remove border
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                const Text(
                  "Search by location..",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                const SizedBox(width: 10),
                Expanded(
                  // Added Expanded here
                  child: SizedBox(
                    height: 30,
                    child: TextField(
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(
                            color: Colors.grey), // Hint text color
                        prefixIcon: const Icon(Icons.search,
                            color: Colors.grey), // Icon color
                        filled: true,
                        fillColor: Colors.white, // TextField background color
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none, // Remove border
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
*/
















/*
Row(
              children: [
                const Text(
                  "Search by name..",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                const SizedBox(width: 10),
                Expanded(
                  // Added Expanded here
                  child: SizedBox(
                    height: 30,
                    child: TextField(
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(
                            color: Colors.grey), // Hint text color
                        prefixIcon: const Icon(Icons.search,
                            color: Colors.grey), // Icon color
                        filled: true,
                        fillColor: Colors.white, // TextField background color
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none, // Remove border
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
*/