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

  Future<List<Product>> fetchProducts(ProductSearchModel searchParams) async {
    final queryString = searchParams.toQueryString();
    final url = Uri.parse(
      'https://innova-hub.premiumasp.net/api/Product/productsSearchFilter$queryString',
    );

    print('📤 Requesting: $url');

    try {
      final response = await http.get(url);

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        final products = data.map((json) => Product.fromJson(json)).toList();
        print('✅ Fetched ${products.length} products');
        return products;
      } else {
        throw Exception(
            'Failed to load products. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('❌ Error fetching products: $error');
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
      print('❌ Error in _searchProducts: $error');
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
                          title:
                              Text(_products[index].productName ?? "No name"),
                          subtitle: Text(
                              _products[index].productAuthor ?? "No author"),
                          trailing: Text(
                            _products[index].productPriceAfterDiscount != null
                                ? '\$${_products[index].productPriceAfterDiscount!.toStringAsFixed(2)}'
                                : 'No price',
                          ),
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




/*
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// نموذج البحث
class ProductSearchModel {
  final int from;
  final int to;
  final String location;

  ProductSearchModel({
    required this.from,
    required this.to,
    required this.location,
  });

  String toQueryString() {
    return "?from=$from&to=$to&location=$location";
  }
}

// نموذج المنتج
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
      productName: json['ProductName'],
      productAuthor: json['ProductAuthor'],
      productPriceBeforeDiscount:
          (json['ProductPriceBeforeDiscount'] as num?)?.toDouble(),
      productPriceAfterDiscount:
          (json['ProductPriceAfterDiscount'] as num?)?.toDouble(),
      productStatus: json['ProductStatus'],
    );
  }
}

// هذا يمثل نموذج الفئة التي تحتوي على المنتجات
class CategoryModel {
  String categoryName;
  List<Product> allProducts;

  CategoryModel({required this.categoryName, required this.allProducts});
}

// الـ Stateful Widget
class SearchProductHorizontalList extends StatefulWidget {
  final CategoryModel categoryModel;

  const SearchProductHorizontalList({super.key, required this.categoryModel});

  @override
  State<SearchProductHorizontalList> createState() =>
      _SearchProductHorizontalListState();
}

class _SearchProductHorizontalListState
    extends State<SearchProductHorizontalList> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  bool _isLoading = false;

  Future<List<Product>> fetchProducts(ProductSearchModel searchParams) async {
    final queryString = searchParams.toQueryString();
    final url = Uri.parse(
        'https://innova-hub.premiumasp.net/api/Product/productsSearchFilter$queryString');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  void _searchProductsAndUpdateCategory() async {
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
          const SnackBar(content: Text('From must be less than To')),
        );
        return;
      }

      final searchParams = ProductSearchModel(
        from: from,
        to: to,
        location: _locationController.text,
      );

      setState(() {
        _isLoading = true;
      });

      final results = await fetchProducts(searchParams);

      setState(() {
        widget.categoryModel.allProducts = results;
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

  // widgets stacklist (مثال بسيط للتوضيح)
  Widget SearchContainer({required Product product}) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(product.productName ?? 'No name'),
          Text('Price: ${product.productPriceAfterDiscount?.toStringAsFixed(2) ?? "-"}'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryModel = widget.categoryModel;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: Row(
            children: [
              _buildSearchField(_fromController, 'From'),
              const SizedBox(width: 10),
              _buildSearchField(_toController, 'To'),
              const SizedBox(width: 10),
              Expanded(
                child: _buildSearchField(_locationController, 'Location'),
              ),
              IconButton(
                onPressed: _searchProductsAndUpdateCategory,
                icon: const Icon(Icons.search),
              ),
            ],
          ),
        ),
        _isLoading
            ? const CircularProgressIndicator()
            : Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                height: 200,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categoryModel.allProducts.length,
                  itemBuilder: (context, index) {
                    return SearchContainer(
                      product: categoryModel.allProducts[index],
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(width: 15),
                ),
              ),
      ],
    );
  }

  Widget _buildSearchField(
      TextEditingController controller, String hintText) {
    return SizedBox(
      width: 80,
      height: 40,
      child: TextField(
        controller: controller,
        onSubmitted: (_) => _searchProductsAndUpdateCategory(),
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
*/