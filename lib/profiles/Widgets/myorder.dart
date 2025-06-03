/*import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:innovahub_app/home/cart_Tap.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewScreen extends StatefulWidget {
  static const String routeName = 'ReviewScreen';

  const ReviewScreen({super.key});

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  List<Map<String, dynamic>> reviews = [];
  Map<int, int> ratings = {};
  Map<int, TextEditingController> commentControllers = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPreviousReviews();
  }

  Future<void> _loadPreviousReviews() async {
    final prefs = await SharedPreferences.getInstance();
    final savedReviews = prefs.getString('savedReviews');
    if (savedReviews != null) {
      setState(() {
        reviews = List<Map<String, dynamic>>.from(jsonDecode(savedReviews));
      });
    }
  }

  @override
  void dispose() {
    for (var controller in commentControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _submitReview(int productId) async {
    final ratingValue = ratings[productId] ?? 0;
    final commentText = commentControllers[productId]?.text.trim() ?? '';

    if (ratingValue == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a rating')),
      );
      return;
    }

    if (commentText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a comment')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await rateProduct(
        productId: productId,
        ratingValue: ratingValue,
        comment: commentText,
      );

      // Add the new review to the list
      final newReview = {
        'productId': productId,
        'userName': 'You',
        'rating': ratingValue,
        'comment': commentText,
        'date': DateTime.now().toIso8601String(),
      };

      setState(() {
        reviews.insert(0, newReview);
        ratings[productId] = 0;
        commentControllers[productId]?.clear();
      });

      // Save to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('savedReviews', jsonEncode(reviews));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Review submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Product Reviews"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Existing reviews section

            // Review input section for each product in cart
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: CartController.cartItems.length,
              itemBuilder: (context, index) {
                final item = CartController.cartItems[index];
                final productId = item["ProductId"];
                final currentRating = ratings[productId] ?? 0;

                commentControllers.putIfAbsent(
                    productId, () => TextEditingController());

                return _buildProductReviewCard(item, productId, currentRating);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductReviewCard(
      Map<String, dynamic> item, int productId, int currentRating) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item["HomePictureUrl"],
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Row(
                        children: List.generate(5, (starIndex) {
                          return IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: Icon(
                              starIndex < currentRating
                                  ? Icons.star
                                  : Icons.star_border_outlined,
                              color: starIndex < currentRating
                                  ? Colors.amber
                                  : Colors.grey,
                              size: 30,
                            ),
                            onPressed: () {
                              setState(() {
                                ratings[productId] = starIndex + 1;
                              });
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: commentControllers[productId],
              decoration: InputDecoration(
                hintText: "Share your experience with this product...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : () => _submitReview(productId),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constant.mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Submit Review',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> rateProduct({
  required int productId,
  required int ratingValue,
  required String comment,
}) async {
  // Validate rating value
  if (ratingValue < 1 || ratingValue > 5) {
    throw Exception('Rating value must be between 1 and 5');
  }

  // Get token from shared preferences
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  if (token == null) {
    throw Exception('User not authenticated');
  }

  final response = await http.post(
    Uri.parse('https://innova-hub.premiumasp.net/api/Product/rateAndComment'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'ProductId': productId,
      'RatingValue': ratingValue,
      'Comment': comment,
    }),
  );

  if (response.statusCode != 200 && response.statusCode != 201) {
    final errorData = jsonDecode(response.body);
    throw Exception(errorData['message'] ?? 'Failed to submit rating');
  }
}
*/

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:innovahub_app/home/cart_Tap.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewScreen extends StatefulWidget {
  static const String routeName = 'ReviewScreen';

  const ReviewScreen({super.key});

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  List<Map<String, dynamic>> reviews = [];
  Map<int, int> ratings = {};
  Map<int, TextEditingController> commentControllers = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPreviousReviews();
  }

  Future<void> _loadPreviousReviews() async {
    final prefs = await SharedPreferences.getInstance();
    final savedReviews = prefs.getString('savedReviews');
    if (savedReviews != null) {
      setState(() {
        reviews = List<Map<String, dynamic>>.from(jsonDecode(savedReviews));
      });
    }
  }

  @override
  void dispose() {
    for (var controller in commentControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _submitReview(int productId) async {
    final ratingValue = ratings[productId] ?? 0;
    final commentText = commentControllers[productId]?.text.trim() ?? '';

    if (ratingValue == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a rating')),
      );
      return;
    }

    if (commentText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a comment')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // Submit both rating and comment to the API
      await rateProduct(
        productId: productId,
        ratingValue: ratingValue,
        comment: commentText,
      );

      // Add the new review to the local list for immediate display
      final newReview = {
        'productId': productId,
        'userName': 'You',
        'rating': ratingValue,
        'comment': commentText,
        'date': DateTime.now().toIso8601String(),
      };

      setState(() {
        reviews.insert(0, newReview);
        ratings[productId] = 0;
        commentControllers[productId]?.clear();
      });

      // Save to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('savedReviews', jsonEncode(reviews));

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Review and rating submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back or refresh the product page
      Navigator.of(context).pop(true); // Return true to indicate refresh needed
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Product Reviews"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Display existing reviews
            if (reviews.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Your Previous Reviews',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                review['userName'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              Row(
                                children: List.generate(5, (starIndex) {
                                  return Icon(
                                    starIndex < review['rating']
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: 16,
                                  );
                                }),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(review['comment']),
                          const SizedBox(height: 8),
                          Text(
                            DateTime.parse(review['date'])
                                .toString()
                                .split('.')[0],
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const Divider(thickness: 2),
            ],

            // Review input section for each product in cart
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Rate & Review Products',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: CartController.cartItems.length,
              itemBuilder: (context, index) {
                final item = CartController.cartItems[index];
                final productId = item["ProductId"];
                final currentRating = ratings[productId] ?? 0;

                commentControllers.putIfAbsent(
                    productId, () => TextEditingController());

                return _buildProductReviewCard(item, productId, currentRating);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductReviewCard(
      Map<String, dynamic> item, int productId, int currentRating) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item["HomePictureUrl"],
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image_not_supported, size: 80),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item["ProductName"] ?? "Product",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Rate this product:',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: List.generate(5, (starIndex) {
                          return IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: Icon(
                              starIndex < currentRating
                                  ? Icons.star
                                  : Icons.star_border_outlined,
                              color: starIndex < currentRating
                                  ? Colors.amber
                                  : Colors.grey,
                              size: 28,
                            ),
                            onPressed: () {
                              setState(() {
                                ratings[productId] = starIndex + 1;
                              });
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: commentControllers[productId],
              decoration: InputDecoration(
                hintText: "Share your experience with this product...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : () => _submitReview(productId),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constant.mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Submit Review & Rating',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Updated rateProduct function to handle both rating and comment
Future<void> rateProduct({
  required int productId,
  required int ratingValue,
  required String comment,
}) async {
  // Validate rating value
  if (ratingValue < 1 || ratingValue > 5) {
    throw Exception('Rating value must be between 1 and 5');
  }

  // Get token from shared preferences
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  if (token == null) {
    throw Exception('User not authenticated');
  }

  // Submit rating and comment
  final response = await http.post(
    Uri.parse('https://innova-hub.premiumasp.net/api/Product/rateAndComment'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'ProductId': productId,
      'RatingValue': ratingValue,
      'Comment': comment,
    }),
  );

  if (response.statusCode != 200 && response.statusCode != 201) {
    final errorData = jsonDecode(response.body);
    throw Exception(
        errorData['message'] ?? 'Failed to submit rating and comment');
  }
}

/*import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:innovahub_app/home/cart_Tap.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewScreen extends StatefulWidget {
  static const String routeName = 'ReviewScreen';

  const ReviewScreen({super.key});

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  List<Map<String, dynamic>> reviews = [];
  Map<int, int> ratings = {};
  Map<int, TextEditingController> commentControllers = {};
  Set<int> loadingProducts = {}; // Track loading state per product
  bool isInitializing = true;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    await _loadPreviousReviews();
    setState(() => isInitializing = false);
  }

  Future<void> _loadPreviousReviews() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedReviews = prefs.getString('savedReviews');
      if (savedReviews != null) {
        final decodedReviews = jsonDecode(savedReviews) as List;
        setState(() {
          reviews = decodedReviews.cast<Map<String, dynamic>>();
        });
      }
    } catch (e) {
      debugPrint('Error loading previous reviews: $e');
    }
  }

  @override
  void dispose() {
    for (var controller in commentControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _submitReview(int productId) async {
    final ratingValue = ratings[productId] ?? 0;
    final commentText = commentControllers[productId]?.text.trim() ?? '';

    // Validation
    if (ratingValue == 0) {
      _showSnackBar('Please select a rating', Colors.orange);
      return;
    }

    if (commentText.isEmpty) {
      _showSnackBar('Please add a comment', Colors.orange);
      return;
    }

    if (commentText.length < 10) {
      _showSnackBar(
          'Comment must be at least 10 characters long', Colors.orange);
      return;
    }

    setState(() => loadingProducts.add(productId));

    try {
      await rateProduct(
        productId: productId,
        ratingValue: ratingValue,
        comment: commentText,
      );

      // Add the new review to the list
      final newReview = {
        'productId': productId,
        'userName': 'You',
        'rating': ratingValue,
        'comment': commentText,
        'date': DateTime.now().toIso8601String(),
      };

      setState(() {
        reviews.insert(0, newReview);
        ratings.remove(productId);
        commentControllers[productId]?.clear();
      });

      // Save to shared preferences
      await _saveReviews();

      _showSnackBar('Review submitted successfully!', Colors.green);
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}', Colors.red);
    } finally {
      setState(() => loadingProducts.remove(productId));
    }
  }

  Future<void> _saveReviews() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('savedReviews', jsonEncode(reviews));
    } catch (e) {
      debugPrint('Error saving reviews: $e');
    }
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Product Reviews"),
        elevation: 0,
      ),
      body: isInitializing
          ? const Center(child: CircularProgressIndicator())
          : CartController.cartItems.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart_outlined,
                          size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No items in cart to review',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Previous reviews section (if any)
                      if (reviews.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'Your Previous Reviews',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: reviews.length,
                          itemBuilder: (context, index) =>
                              _buildPreviousReviewCard(reviews[index]),
                        ),
                        const Divider(height: 32, thickness: 1),
                      ],

                      // Review input section for each product in cart
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Rate Your Cart Items',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: CartController.cartItems.length,
                        itemBuilder: (context, index) {
                          final item = CartController.cartItems[index];
                          final productId = item["ProductId"] as int;
                          final currentRating = ratings[productId] ?? 0;

                          commentControllers.putIfAbsent(
                              productId, () => TextEditingController());

                          return _buildProductReviewCard(
                              item, productId, currentRating);
                        },
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildPreviousReviewCard(Map<String, dynamic> review) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Product ID: ${review['productId']}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < (review['rating'] ?? 0)
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amber,
                      size: 16,
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(review['comment'] ?? ''),
            const SizedBox(height: 4),
            Text(
              _formatDate(review['date']),
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductReviewCard(
      Map<String, dynamic> item, int productId, int currentRating) {
    final isSubmitting = loadingProducts.contains(productId);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item["HomePictureUrl"] ?? '',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.image_not_supported,
                          color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item["Name"] ?? 'Product',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      const Text('Rate this product:',
                          style: TextStyle(fontSize: 14)),
                      const SizedBox(height: 4),
                      Row(
                        children: List.generate(5, (starIndex) {
                          return GestureDetector(
                            onTap: isSubmitting
                                ? null
                                : () {
                                    setState(() {
                                      ratings[productId] = starIndex + 1;
                                    });
                                  },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Icon(
                                starIndex < currentRating
                                    ? Icons.star
                                    : Icons.star_border_outlined,
                                color: starIndex < currentRating
                                    ? Colors.amber
                                    : Colors.grey,
                                size: 28,
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: commentControllers[productId],
              enabled: !isSubmitting,
              decoration: InputDecoration(
                hintText:
                    "Share your experience with this product... (minimum 10 characters)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.all(12),
                counterText: '',
              ),
              maxLines: 3,
              maxLength: 500,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSubmitting ? null : () => _submitReview(productId),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constant.mainColor,
                  disabledBackgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Submit Review',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}

Future<void> rateProduct({
  required int productId,
  required int ratingValue,
  required String comment,
}) async {
  // Validate inputs
  if (ratingValue < 1 || ratingValue > 5) {
    throw Exception('Rating value must be between 1 and 5');
  }

  if (comment.trim().isEmpty) {
    throw Exception('Comment cannot be empty');
  }

  if (comment.trim().length < 10) {
    throw Exception('Comment must be at least 10 characters long');
  }

  // Get token from shared preferences
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  if (token == null || token.isEmpty) {
    throw Exception('User not authenticated. Please log in again.');
  }

  try {
    final response = await http
        .post(
          Uri.parse(
              'https://innova-hub.premiumasp.net/api/Product/rateAndComment'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'ProductId': productId,
            'RatingValue': ratingValue,
            'Comment': comment.trim(),
          }),
        )
        .timeout(
          const Duration(seconds: 30),
          onTimeout: () => throw Exception(
              'Request timeout. Please check your internet connection.'),
        );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return; // Success
    }

    // Handle different error cases
    String errorMessage;
    try {
      final errorData = jsonDecode(response.body);
      errorMessage = errorData['message'] ?? 'Failed to submit rating';
    } catch (e) {
      errorMessage = 'Server error (${response.statusCode})';
    }

    if (response.statusCode == 401) {
      throw Exception('Authentication failed. Please log in again.');
    } else if (response.statusCode == 403) {
      throw Exception('You are not authorized to rate this product.');
    } else if (response.statusCode >= 500) {
      throw Exception('Server error. Please try again later.');
    } else {
      throw Exception(errorMessage);
    }
  } catch (e) {
    if (e.toString().contains('SocketException') ||
        e.toString().contains('HandshakeException')) {
      throw Exception('Network error. Please check your internet connection.');
    }
    rethrow;
  }
}
*/
