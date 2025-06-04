import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:innovahub_app/Models/product_response.dart';
import 'package:innovahub_app/core/Api/Api_return_comment.dart';
import 'package:innovahub_app/core/Api/cart_services.dart';
import 'package:innovahub_app/core/Api/comment_service.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

// Import your new service (adjust the path as needed)
// import 'package:innovahub_app/services/product_comments_service.dart';

// Add the new models here (or import them from a separate file)
class Comment {
  final int commentId;
  final String userId;
  final String userName;
  final String commentText;
  final DateTime createdAt;

  Comment({
    required this.commentId,
    required this.userId,
    required this.userName,
    required this.commentText,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentId: json['CommentId'],
      userId: json['UserId'],
      userName: json['UserName'],
      commentText: json['CommentText'],
      createdAt: DateTime.parse(json['CreatedAt']),
    );
  }
}

class RatingBreakdown {
  final double oneStar;
  final double twoStar;
  final double threeStar;
  final double fourStar;
  final double fiveStar;

  RatingBreakdown({
    required this.oneStar,
    required this.twoStar,
    required this.threeStar,
    required this.fourStar,
    required this.fiveStar,
  });

  factory RatingBreakdown.fromJson(Map<String, dynamic> json) {
    return RatingBreakdown(
      oneStar: (json['1 star'] ?? 0).toDouble(),
      twoStar: (json['2 star'] ?? 0).toDouble(),
      threeStar: (json['3 star'] ?? 0).toDouble(),
      fourStar: (json['4 star'] ?? 0).toDouble(),
      fiveStar: (json['5 star'] ?? 0).toDouble(),
    );
  }
}

class NewProductCommentsResponse {
  final String message;
  final int numOfComments;
  final List<Comment> comments;
  final double averageRating;
  final RatingBreakdown ratingBreakdown;

  NewProductCommentsResponse({
    required this.message,
    required this.numOfComments,
    required this.comments,
    required this.averageRating,
    required this.ratingBreakdown,
  });

  factory NewProductCommentsResponse.fromJson(Map<String, dynamic> json) {
    return NewProductCommentsResponse(
      message: json['Message'],
      numOfComments: json['NumOfComments'],
      comments: (json['Comments'] as List)
          .map((commentJson) => Comment.fromJson(commentJson))
          .toList(),
      averageRating: (json['AverageRating'] ?? 0).toDouble(),
      ratingBreakdown: RatingBreakdown.fromJson(json['RatingBreakdown']),
    );
  }
}

// Service class
class ProductCommentsService {
  static const String baseUrl = 'https://innova-hub.premiumasp.net/api/Product';

  static Future<NewProductCommentsResponse?> getAllProductComments(
      int productId) async {
    try {
      final url = Uri.parse('$baseUrl/GetAllProductComments/$productId');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return NewProductCommentsResponse.fromJson(jsonData);
      } else {
        print('Failed to load comments. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching product comments: $e');
      return null;
    }
  }
}

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  static const String routeName = 'product_page';

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late ProductResponse product;

  TextEditingController commentController = TextEditingController();
  int quantity = 1;
  List<Comment> newComments = []; // Updated to use new Comment model
  bool isLoadingComments = false;
  late NewProductCommentsResponse
      newProductCommentsResponse; // Updated response type

  @override
  void initState() {
    super.initState();
    newProductCommentsResponse = NewProductCommentsResponse(
      message: '',
      numOfComments: 0,
      comments: [],
      averageRating: 0,
      ratingBreakdown: RatingBreakdown(
        oneStar: 0,
        twoStar: 0,
        threeStar: 0,
        fourStar: 0,
        fiveStar: 0,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    product = ModalRoute.of(context)!.settings.arguments as ProductResponse;
    _loadComments();
  }

  Future<void> _loadComments() async {
    setState(() {
      isLoadingComments = true;
    });
    try {
      // Use the new service
      final response =
          await ProductCommentsService.getAllProductComments(product.productId);
      if (response != null) {
        setState(() {
          newComments = response.comments;
          newProductCommentsResponse = response;
        });
      }
    } catch (e) {
      print('Error loading comments: $e');
      // Show error message to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to load comments")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoadingComments = false;
        });
      }
    }
  }

  Future<void> addComment() async {
    if (commentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Comment cannot be empty!")),
      );
      return;
    }

    final message = await CommentService.postComment(
        product.productId, commentController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );

    if (message == "Comment added successfully!") {
      commentController.clear();
      await _loadComments(); // Refresh comments after adding new one
    }
  }

  Future<void> addToCart() async {
    final cartService = CartService();

    try {
      final success = await cartService.addToCart(product.productId, quantity);

      if (success) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Success',
          text: 'Product added to cart',
        );
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error',
          text: 'Failed to add product to cart',
        );
      }
    } catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Network Error',
        text: 'Please check your internet connection',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentRating = newProductCommentsResponse.averageRating.toInt();

    return Scaffold(
      backgroundColor: Constant.white3Color,
      appBar: AppBar(
        backgroundColor: Constant.whiteColor,
        elevation: 0,
        title: const Text(
          'Innova',
          style: TextStyle(
            color: Constant.blackColorDark,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage('assets/images/image-13.png'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Constant.mainColor,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(80),
                ),
              ),
              width: double.infinity,
              height: 70,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Constant.whiteColor,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  product.productImage,
                  fit: BoxFit.cover,
                  width: 350,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error_outline, size: 100),
                ),
              ),
            ),
            SizedBox(
              height: 75,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: List.generate(
                  4,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        product.productImage,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error_outline, size: 50),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/owner.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        product.authorName,
                        style: const TextStyle(
                          color: Constant.blackColorDark,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.message,
                          color: Constant.mainColor,
                          size: 25,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.name,
                    style: const TextStyle(
                      color: Constant.blackColorDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Constant.blackColorDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: const TextStyle(
                      color: Constant.blackColorDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.favorite_border,
                      color: Constant.blackColorDark,
                      size: 30,
                    ),
                    onPressed: () {},
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      Row(
                        children: [
                          Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                index < currentRating
                                    ? Icons.star
                                    : Icons.star_border,
                                color: index < currentRating
                                    ? Colors.amber
                                    : Constant.greyColor,
                              );
                            }),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "${newProductCommentsResponse.averageRating.toString()} Review(s)",
                            style: TextStyle(color: Constant.greyColor4),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Constant.whiteColor,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Available quantity: ${product.stock}',
                    style: const TextStyle(
                      color: Constant.greyColor4,
                      fontSize: 15,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: Constant.whiteColor,
                      border: Border.all(color: Constant.greyColor4),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          if (quantity > 1) quantity--;
                        });
                      },
                      icon: const Icon(
                        Icons.remove,
                        size: 30,
                        color: Constant.mainColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    "$quantity",
                    style: const TextStyle(
                      color: Constant.mainColor,
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: Constant.whiteColor,
                      border: Border.all(color: Constant.greyColor4),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          if (quantity < product.stock) quantity++;
                        });
                      },
                      icon: const Icon(
                        Icons.add,
                        size: 30,
                        color: Constant.mainColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            const Divider(
              color: Constant.greyColor2,
              indent: 18,
              endIndent: 18,
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Product Ratings & Reviews',
                    style: TextStyle(
                      color: Constant.mainColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildRatingSummary(),
                  const SizedBox(height: 16),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'There are ${newComments.length} reviews for this product',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Constant.greyColor4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Divider(),
                  if (isLoadingComments)
                    const Center(child: CircularProgressIndicator())
                  else if (newComments.isEmpty)
                    const Center(child: Text("No comments yet"))
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: newComments.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) =>
                          _buildReviewItem(newComments[index]),
                    ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: addToCart,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        backgroundColor: Constant.mainColor,
                        minimumSize: const Size(1, 60),
                      ),
                      child: const Text(
                        "Add to cart",
                        style: TextStyle(
                          color: Constant.whiteColor,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSummary() {
    final ratingBreakdown = newProductCommentsResponse.ratingBreakdown;
    final totalRatings = ratingBreakdown.fiveStar +
        ratingBreakdown.fourStar +
        ratingBreakdown.threeStar +
        ratingBreakdown.twoStar +
        ratingBreakdown.oneStar;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Text(
              newProductCommentsResponse.averageRating.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Constant.black2Color,
              ),
            ),
            Text(
              'Based on ${newProductCommentsResponse.numOfComments} Ratings',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            children: [
              _buildRatingBar(
                5,
                totalRatings > 0 ? ratingBreakdown.fiveStar / totalRatings : 0,
                Colors.green,
              ),
              _buildRatingBar(
                4,
                totalRatings > 0 ? ratingBreakdown.fourStar / totalRatings : 0,
                Colors.lightGreen,
              ),
              _buildRatingBar(
                3,
                totalRatings > 0 ? ratingBreakdown.threeStar / totalRatings : 0,
                Colors.amber,
              ),
              _buildRatingBar(
                2,
                totalRatings > 0 ? ratingBreakdown.twoStar / totalRatings : 0,
                Colors.orange,
              ),
              _buildRatingBar(
                1,
                totalRatings > 0 ? ratingBreakdown.oneStar / totalRatings : 0,
                Colors.deepOrange,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRatingBar(int stars, double percentage, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text('$stars star'),
          const SizedBox(width: 8),
          Expanded(
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey[200],
              color: color,
              minHeight: 8,
            ),
          ),
          const SizedBox(width: 8),
          Text('${(percentage * 100).toStringAsFixed(1)}%'),
        ],
      ),
    );
  }

  Widget _buildReviewItem(Comment comment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Text(
                  comment.userName.isNotEmpty
                      ? comment.userName[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                comment.userName.isNotEmpty ? comment.userName : 'Anonymous',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '${formatTime(comment.createdAt)}',
                style: const TextStyle(
                  color: Color.fromARGB(255, 67, 66, 66),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < newProductCommentsResponse.averageRating.toInt()
                    ? Icons.star
                    : Icons.star_border,
                color: Colors.amber,
                size: 18,
              );
            }),
          ),
          const SizedBox(height: 8),
          Text(
            comment.commentText,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Helpful',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String formatTime(DateTime dateTime) {
    return DateFormat('h:mm a').format(dateTime);
  }
}

/*
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductPage extends StatefulWidget {
  static const String routeName = 'product_page';

  final int productId;

  const ProductPage({super.key, required this.productId});

  @override
  State<ProductPage> createState() => _ProductCommentsPageState();
}

class _ProductCommentsPageState extends State<ProductPage> {
  late Future<ProductCommentResponse> _commentsFuture;

  @override
  void initState() {
    super.initState();
    _commentsFuture = fetchProductComments(widget.productId);
  }

  Future<ProductCommentResponse> fetchProductComments(int productId) async {
    final url = Uri.parse(
        'https://innova-hub.premiumasp.net/api/Product/GetAllProductComments/$productId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return ProductCommentResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load product comments');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Comments')),
      body: FutureBuilder<ProductCommentResponse>(
        future: _commentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.comments.isEmpty) {
            return const Center(child: Text('No comments available'));
          }

          final data = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Comments: ${data.numOfComments}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                    'Average Rating: ${data.averageRating.toStringAsFixed(2)}'),
                const SizedBox(height: 10),
                const Text('Rating Breakdown:'),
                ...data.ratingBreakdown.entries
                    .map((entry) => Text('${entry.key}: ${entry.value}')),
                const Divider(height: 30),
                const Text('Comments:',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: data.comments.length,
                    itemBuilder: (context, index) {
                      final comment = data.comments[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(comment.userName),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(comment.commentText),
                              Text(
                                'Posted on: ${comment.createdAt.toLocal().toString().split(".")[0]}',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ProductCommentResponse {
  final String message;
  final int numOfComments;
  final List<Comment> comments;
  final double averageRating;
  final Map<String, double> ratingBreakdown;

  ProductCommentResponse({
    required this.message,
    required this.numOfComments,
    required this.comments,
    required this.averageRating,
    required this.ratingBreakdown,
  });

  factory ProductCommentResponse.fromJson(Map<String, dynamic> json) {
    return ProductCommentResponse(
      message: json['Message'],
      numOfComments: json['NumOfComments'],
      comments: List<Comment>.from(
        json['Comments'].map((c) => Comment.fromJson(c)),
      ),
      averageRating: (json['AverageRating'] as num).toDouble(),
      ratingBreakdown: Map<String, double>.from(
        json['RatingBreakdown'].map(
          (key, value) => MapEntry(key, (value as num).toDouble()),
        ),
      ),
    );
  }
}

class Comment {
  final int commentId;
  final String userId;
  final String userName;
  final String commentText;
  final DateTime createdAt;

  Comment({
    required this.commentId,
    required this.userId,
    required this.userName,
    required this.commentText,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentId: json['CommentId'],
      userId: json['UserId'],
      userName: json['UserName'],
      commentText: json['CommentText'],
      createdAt: DateTime.parse(json['CreatedAt']),
    );
  }
}

*/

/*import 'package:flutter/material.dart';
import 'package:innovahub_app/Models/product_response.dart';
import 'package:innovahub_app/core/Api/Api_return_comment.dart';
import 'package:innovahub_app/core/Api/cart_services.dart';
import 'package:innovahub_app/core/Api/comment_service.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:intl/intl.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  static const String routeName = 'product_page';

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late ProductResponse product;

  TextEditingController commentController = TextEditingController();
  int quantity = 1;
  List<ProductComment> comments = [];
  bool isLoadingComments = false;

  late ProductCommentsResponse productCommentsResponse;

  @override
  void initState() {
    super.initState();
    productCommentsResponse = ProductCommentsResponse(
      message: '',
      comments: [],
      numOfComments: 0,
      averageRating: 0,
      ratingBreakdown: {},
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    product = ModalRoute.of(context)!.settings.arguments as ProductResponse;
    _loadComments();
  }

  Future<void> _loadComments() async {
    setState(() {
      isLoadingComments = true;
    });
    try {
      final response = await fetchProductComments(product.productId);
      if (response != null) {
        setState(() {
          comments = response.comments;
          productCommentsResponse = response;
        });
      }
    } catch (e) {
      print('Error loading comments: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoadingComments = false;
        });
      }
    }
  }

  Future<void> addComment() async {
    if (commentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Comment cannot be empty!")),
      );
      return;
    }

    final message = await CommentService.postComment(
      product.productId,
      commentController.text,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );

    if (message == "Comment added successfully!") {
      commentController.clear();
      await _loadComments(); // Refresh comments after adding new one
    }
  }

  Future<void> addToCart() async {
    final cartService = CartService();

    try {
      final success = await cartService.addToCart(product.productId, quantity);

      if (success) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Success',
          text: 'Product added to cart',
        );
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error',
          text: 'Failed to add product to cart',
        );
      }
    } catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Network Error',
        text: 'Please check your internet connection',
      );
    }
  }

  // Method to navigate to review screen and refresh when returning
  Future<void> _navigateToReviews() async {
    final result = await Navigator.pushNamed(
        context, 'ReviewScreen' // Replace with your actual route name
        );

    // If the review screen returns true, refresh the comments
    if (result == true) {
      await _loadComments();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentRating = productCommentsResponse.averageRating.toInt();

    return Scaffold(
      backgroundColor: Constant.white3Color,
      appBar: AppBar(
        backgroundColor: Constant.whiteColor,
        elevation: 0,
        title: const Text(
          'Innova',
          style: TextStyle(
            color: Constant.blackColorDark,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage('assets/images/image-13.png'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Constant.mainColor,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(80),
                ),
              ),
              width: double.infinity,
              height: 70,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Constant.whiteColor,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  product.productImage,
                  fit: BoxFit.cover,
                  width: 350,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error_outline, size: 100),
                ),
              ),
            ),

            SizedBox(
              height: 75,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: List.generate(
                  4,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        product.productImage,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error_outline, size: 50),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/owner.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        product.authorName,
                        style: const TextStyle(
                          color: Constant.blackColorDark,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.message,
                          color: Constant.mainColor,
                          size: 25,
                        ),
                        onPressed: () {
                          // Action on message icon press
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.name,
                    style: const TextStyle(
                      color: Constant.blackColorDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Constant.blackColorDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: const TextStyle(
                      color: Constant.blackColorDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // تقييم المنتج والعدد الإجمالي للتقييمات
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.favorite_border,
                      color: Constant.blackColorDark,
                      size: 30,
                    ),
                    onPressed: () {
                      // Action for favorite icon
                    },
                  ),
                  const Spacer(),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < currentRating ? Icons.star : Icons.star_border,
                        color: index < currentRating
                            ? Colors.amber
                            : Constant.greyColor,
                      );
                    }),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "${productCommentsResponse.averageRating.toString()} Review(s)",
                    style: TextStyle(color: Constant.greyColor4),
                  ),
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: Constant.whiteColor,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Text(
                    'Available quantity: ${product.stock}',
                    style: const TextStyle(
                      color: Constant.greyColor4,
                      fontSize: 15,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: Constant.whiteColor,
                      border: Border.all(color: Constant.greyColor4),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          if (quantity > 1) quantity--;
                        });
                      },
                      icon: const Icon(
                        Icons.remove,
                        size: 30,
                        color: Constant.mainColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    "$quantity",
                    style: const TextStyle(
                      color: Constant.mainColor,
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: Constant.whiteColor,
                      border: Border.all(color: Constant.greyColor4),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          if (quantity < product.stock) quantity++;
                        });
                      },
                      icon: const Icon(
                        Icons.add,
                        size: 30,
                        color: Constant.mainColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(
                color: Constant.greyColor2, indent: 18, endIndent: 18),

            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Product Ratings & Reviews',
                        style: TextStyle(
                          color: Constant.mainColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: _navigateToReviews,
                        child: const Text(
                          'Write Review',
                          style: TextStyle(
                            color: Constant.mainColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildRatingSummary(),
                  const SizedBox(height: 16),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'There are ${comments.length} reviews for this product',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Constant.greyColor4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Divider(),
                  if (isLoadingComments)
                    const Center(child: CircularProgressIndicator())
                  else if (comments.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          "No reviews yet. Be the first to review this product!",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: comments.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) =>
                          _buildReviewItem(comments[index]),
                    ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
      // Add floating action button for quick review access
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToReviews,
        backgroundColor: Constant.mainColor,
        icon: const Icon(Icons.rate_review, color: Colors.white),
        label: const Text(
          'Write Review',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildRatingSummary() {
    final totalRatings =
        (productCommentsResponse.ratingBreakdown['5 star'] ?? 0) +
            (productCommentsResponse.ratingBreakdown['4 star'] ?? 0) +
            (productCommentsResponse.ratingBreakdown['3 star'] ?? 0) +
            (productCommentsResponse.ratingBreakdown['2 star'] ?? 0) +
            (productCommentsResponse.ratingBreakdown['1 star'] ?? 0);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Text(
              productCommentsResponse.averageRating.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Constant.black2Color,
              ),
            ),
            Text(
              'Based on ${totalRatings} Ratings',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            children: [
              _buildRatingBar(
                5,
                totalRatings > 0
                    ? (productCommentsResponse.ratingBreakdown['5 star'] ?? 0) /
                        totalRatings
                    : 0,
                Colors.green,
              ),
              _buildRatingBar(
                4,
                totalRatings > 0
                    ? (productCommentsResponse.ratingBreakdown['4 star'] ?? 0) /
                        totalRatings
                    : 0,
                Colors.lightGreen,
              ),
              _buildRatingBar(
                3,
                totalRatings > 0
                    ? (productCommentsResponse.ratingBreakdown['3 star'] ?? 0) /
                        totalRatings
                    : 0,
                Colors.amber,
              ),
              _buildRatingBar(
                2,
                totalRatings > 0
                    ? (productCommentsResponse.ratingBreakdown['2 star'] ?? 0) /
                        totalRatings
                    : 0,
                Colors.orange,
              ),
              _buildRatingBar(
                1,
                totalRatings > 0
                    ? (productCommentsResponse.ratingBreakdown['1 star'] ?? 0) /
                        totalRatings
                    : 0,
                Colors.deepOrange,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRatingBar(int stars, double percentage, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text('$stars star'),
          const SizedBox(width: 8),
          Expanded(
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey[200],
              color: color,
              minHeight: 8,
            ),
          ),
          const SizedBox(width: 8),
          Text('${(percentage * 100).toStringAsFixed(1)}%'),
        ],
      ),
    );
  }

  Widget _buildReviewItem(ProductComment comment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Text(
                  comment.userName.isNotEmpty
                      ? comment.userName[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                comment.userName.isNotEmpty ? comment.userName : 'Anonymous',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '${formatTime(comment.createdAt)}', // Format: "10:30 AM"
                style: const TextStyle(
                  color: Color.fromARGB(
                      255, 67, 66, 66), // Different color for time
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index <
                        productCommentsResponse
                            .averageRating // Using product's rating
                    ? Icons.star
                    : Icons.star_border,
                color: Colors.amber,
                size: 18,
              );
            }),
          ),
          const SizedBox(height: 8),
          Text(
            comment.commentText,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Helpful',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String formatTime(DateTime dateTime) {
    // Formats to something like "10:30 AM"
    return DateFormat('h:mm a').format(dateTime);
  }
}*/
