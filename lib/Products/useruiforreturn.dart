import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductModel {
  final String productName;
  final String productAuthorId;
  final String productHomePicture;
  final double productPriceAfterDiscount;
  final double productPriceBeforeDiscount;
  final String productDescription;
  final int productStock;
  final double productRate;
  final int numberOfRatings;

  ProductModel({
    required this.productName,
    required this.productAuthorId,
    required this.productHomePicture,
    required this.productPriceAfterDiscount,
    required this.productPriceBeforeDiscount,
    required this.productDescription,
    required this.productStock,
    required this.productRate,
    required this.numberOfRatings,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productName: json['ProductName']?.toString() ?? '',
      productAuthorId: json['ProductAuthorId']?.toString() ?? '',
      productHomePicture: json['ProductHomePicture']?.toString() ?? '',
      productPriceAfterDiscount:
          _parseDouble(json['ProductPriceAfterDiscount']),
      productPriceBeforeDiscount:
          _parseDouble(json['ProductPriceBeforeDiscount']),
      productDescription: json['ProductDescription']?.toString() ?? '',
      productStock: _parseInt(json['ProductStock']),
      productRate: _parseDouble(json['ProductRate']),
      numberOfRatings: _parseInt(json['NumberOfRatings']),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value);
      return parsed ?? 0.0;
    }
    return 0.0;
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      final parsed = int.tryParse(value);
      return parsed ?? 0;
    }
    return 0;
  }
}

class UserProductsScreen extends StatefulWidget {
  static const String routname = "UserProductsScreen";
  const UserProductsScreen({Key? key}) : super(key: key);

  @override
  _UserProductsScreenState createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  List<ProductModel> userProducts = [];
  bool isLoading = true;
  String errorMessage = '';

  final String apiUrl =
      'https://innova-hub.premiumasp.net/api/Product/getAllProducts';

  @override
  void initState() {
    super.initState();
    fetchUserProducts();
  }

  Future<void> fetchUserProducts() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');

      if (userId == null || userId.isEmpty) {
        setState(() {
          errorMessage = 'User ID not found.';
          isLoading = false;
        });
        return;
      }

      final response =
          await http.get(Uri.parse('$apiUrl?page=1&pageSize=1000'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final allProducts = List<Map<String, dynamic>>.from(data['Products']);

        final filteredProducts = allProducts
            .map((json) => ProductModel.fromJson(json))
            .where((product) =>
                product.productAuthorId.trim().toLowerCase() ==
                userId.trim().toLowerCase())
            .toList();

        setState(() {
          userProducts = filteredProducts;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load products.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
        isLoading = false;
      });
    }
  }

  void _showProductDetails(ProductModel product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            constraints:
                const BoxConstraints(maxHeight: 800), // Increased height
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Product Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Product Image
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        product.productHomePicture,
                        width: 250, // Increased image size
                        height: 250, // Increased image size
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 250,
                          height: 250,
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.broken_image,
                            size: 100,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Product Details
                  _buildDetailRow('Product Name', product.productName),
                  _buildDetailRow('Author ID', product.productAuthorId),
                  _buildDetailRow('Price Before Discount',
                      '${product.productPriceBeforeDiscount.toStringAsFixed(2)} EGP'),
                  _buildDetailRow('Price After Discount',
                      '${product.productPriceAfterDiscount.toStringAsFixed(2)} EGP'),
                  _buildDetailRow('Stock', product.productStock.toString()),
                  _buildDetailRow(
                      'Rating', '${product.productRate.toStringAsFixed(1)} ⭐'),
                  _buildDetailRow(
                      'Number of Ratings', product.numberOfRatings.toString()),

                  const SizedBox(height: 12),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      product.productDescription.isEmpty
                          ? 'No description available'
                          : product.productDescription,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Only Close Button (Edit functionality removed)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                      label: const Text('Close'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8), // Increased padding
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140, // Increased width for better alignment
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.teal,
                fontSize: 15, // Slightly larger font
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 15), // Slightly larger font
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Products'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchUserProducts,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        errorMessage,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: fetchUserProducts,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : userProducts.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No products found.',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: fetchUserProducts,
                      child: GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75, // Increased height ratio
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: userProducts.length,
                        itemBuilder: (context, index) {
                          final product = userProducts[index];
                          final discountPercentage =
                              product.productPriceBeforeDiscount > 0
                                  ? ((product.productPriceBeforeDiscount -
                                          product.productPriceAfterDiscount) /
                                      product.productPriceBeforeDiscount *
                                      100)
                                  : 0.0;

                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 6,
                            shadowColor: Colors.black26,
                            child: InkWell(
                              onTap: () => _showProductDetails(product),
                              borderRadius: BorderRadius.circular(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Product Image (Edit button removed)
                                  Expanded(
                                    flex: 3,
                                    child: Stack(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(16),
                                              topRight: Radius.circular(16),
                                            ),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  product.productHomePicture),
                                              fit: BoxFit.cover,
                                              onError: (error, stackTrace) =>
                                                  null,
                                            ),
                                          ),
                                          child: product
                                                  .productHomePicture.isEmpty
                                              ? const Center(
                                                  child: Icon(
                                                    Icons.image_not_supported,
                                                    size: 40,
                                                    color: Colors.grey,
                                                  ),
                                                )
                                              : null,
                                        ),

                                        // Discount Badge
                                        if (discountPercentage > 0)
                                          Positioned(
                                            top: 8,
                                            left: 8,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                '-${discountPercentage.toInt()}%',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),

                                  // Product Details
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Product Name
                                          Text(
                                            product.productName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),

                                          // Rating
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                                size: 16,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                product.productRate
                                                    .toStringAsFixed(1),
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                              Text(
                                                ' (${product.numberOfRatings})',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),

                                          // Price
                                          Row(
                                            children: [
                                              Text(
                                                '${product.productPriceAfterDiscount.toStringAsFixed(0)} EGP',
                                                style: const TextStyle(
                                                  color: Colors.teal,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              if (product
                                                      .productPriceBeforeDiscount >
                                                  product
                                                      .productPriceAfterDiscount)
                                                Text(
                                                  '${product.productPriceBeforeDiscount.toStringAsFixed(0)}',
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 12,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                  ),
                                                ),
                                            ],
                                          ),

                                          const Spacer(),

                                          // Stock Status
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: product.productStock > 0
                                                  ? Colors.green[100]
                                                  : Colors.red[100],
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              product.productStock > 0
                                                  ? 'Stock: ${product.productStock}'
                                                  : 'Out of Stock',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: product.productStock > 0
                                                    ? Colors.green[800]
                                                    : Colors.red[800],
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
