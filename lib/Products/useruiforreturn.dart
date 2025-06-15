/*import 'dart:convert';
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
            constraints: const BoxConstraints(maxHeight: 600),
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
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 200,
                          height: 200,
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.broken_image,
                            size: 80,
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

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _editProduct(product);
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
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
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  void _editProduct(ProductModel product) {
    // TODO: Implement edit functionality
    // You can navigate to an edit screen or show an edit dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit functionality for ${product.productName}'),
        backgroundColor: Colors.blue,
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
                          childAspectRatio: 0.7,
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
                                  // Product Image with Edit Button
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

                                        // Edit Button
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child: IconButton(
                                              onPressed: () =>
                                                  _editProduct(product),
                                              icon: const Icon(
                                                Icons.edit,
                                                color: Colors.blue,
                                                size: 20,
                                              ),
                                              padding: const EdgeInsets.all(6),
                                              constraints:
                                                  const BoxConstraints(),
                                            ),
                                          ),
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
*/

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
            constraints: const BoxConstraints(maxHeight: 600),
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
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 200,
                          height: 200,
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.broken_image,
                            size: 80,
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

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _editProduct(product);
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
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
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  void _editProduct(ProductModel product) async {
    final TextEditingController nameController =
        TextEditingController(text: product.productName);
    final TextEditingController priceAfterController = TextEditingController(
        text: product.productPriceAfterDiscount.toString());
    final TextEditingController priceBeforeController = TextEditingController(
        text: product.productPriceBeforeDiscount.toString());
    final TextEditingController descriptionController =
        TextEditingController(text: product.productDescription);
    final TextEditingController stockController =
        TextEditingController(text: product.productStock.toString());
    final TextEditingController imageController =
        TextEditingController(text: product.productHomePicture);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            constraints: const BoxConstraints(maxHeight: 700, maxWidth: 400),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Edit Product',
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

                  // Product Name Field
                  _buildTextField(
                    controller: nameController,
                    label: 'Product Name',
                    icon: Icons.shopping_bag,
                  ),
                  const SizedBox(height: 16),

                  // Price Before Discount Field
                  _buildTextField(
                    controller: priceBeforeController,
                    label: 'Price Before Discount (EGP)',
                    icon: Icons.attach_money,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),

                  // Price After Discount Field
                  _buildTextField(
                    controller: priceAfterController,
                    label: 'Price After Discount (EGP)',
                    icon: Icons.local_offer,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),

                  // Stock Field
                  _buildTextField(
                    controller: stockController,
                    label: 'Stock Quantity',
                    icon: Icons.inventory,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),

                  // Image URL Field
                  _buildTextField(
                    controller: imageController,
                    label: 'Image URL',
                    icon: Icons.image,
                  ),
                  const SizedBox(height: 16),

                  // Description Field
                  _buildTextField(
                    controller: descriptionController,
                    label: 'Description',
                    icon: Icons.description,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await _updateProduct(
                              product,
                              nameController.text,
                              double.tryParse(priceAfterController.text) ??
                                  product.productPriceAfterDiscount,
                              double.tryParse(priceBeforeController.text) ??
                                  product.productPriceBeforeDiscount,
                              descriptionController.text,
                              int.tryParse(stockController.text) ??
                                  product.productStock,
                              imageController.text,
                            );
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.save),
                          label: const Text('Save Changes'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.cancel),
                          label: const Text('Cancel'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Future<void> _updateProduct(
    ProductModel originalProduct,
    String name,
    double priceAfter,
    double priceBefore,
    String description,
    int stock,
    String imageUrl,
  ) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null || token.isEmpty) {
        Navigator.of(context).pop(); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Authentication token not found. Please login again.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final updateData = {
        'ProductName': name,
        'ProductPriceAfterDiscount': priceAfter,
        'ProductPriceBeforeDiscount': priceBefore,
        'ProductDescription': description,
        'ProductStock': stock,
        'ProductHomePicture': imageUrl,
        'ProductAuthorId': originalProduct.productAuthorId,
      };

      final response = await http.patch(
        Uri.parse(
            'https://innova-hub.premiumasp.net/api/Product/UpdateProduct'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(updateData),
      );

      Navigator.of(context).pop(); // Close loading dialog

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product "$name" updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        // Refresh the products list
        await fetchUserProducts();
      } else {
        final responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to update product: ${responseData['message'] ?? 'Unknown error'}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close loading dialog if still open
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
                          childAspectRatio: 0.85,
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
                                  // Product Image with Edit Button
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

                                        // Edit Button
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child: IconButton(
                                              onPressed: () =>
                                                  _editProduct(product),
                                              icon: const Icon(
                                                Icons.edit,
                                                color: Colors.blue,
                                                size: 20,
                                              ),
                                              padding: const EdgeInsets.all(6),
                                              constraints:
                                                  const BoxConstraints(),
                                            ),
                                          ),
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
