import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductCommentsResponse {
  final String message;
  final int numOfComments;
  final List<ProductComment> comments;
  final int averageRating;
  final Map<String, int> ratingBreakdown;

  ProductCommentsResponse({
    required this.message,
    required this.comments,
    required this.numOfComments,
    required this.averageRating,
    required this.ratingBreakdown,
  });

  factory ProductCommentsResponse.fromJson(Map<String, dynamic> json) {
    try {
      return ProductCommentsResponse(
        message: json['Message'] ?? 'No message',
        numOfComments: json['NumOfComments'] ?? 0,
        comments: (json['Comments'] as List? ?? [])
            .map((item) => ProductComment.fromJson(item))
            .toList(),
        averageRating: json['AverageRating'] ?? 0,
        ratingBreakdown: Map<String, int>.from(json['RatingBreakdown'] ?? {}),
      );
    } catch (e) {
      print('Error parsing ProductCommentsResponse: $e');
      return ProductCommentsResponse(
        message: 'Error parsing response',
        numOfComments: 0,
        comments: [],
        averageRating: 0,
        ratingBreakdown: {},
      );
    }
  }
}

class ProductComment {
  final int commentId;
  final String userId;
  final String userName;
  final String commentText;
  final DateTime createdAt;

  ProductComment({
    required this.commentId,
    required this.userId,
    required this.userName,
    required this.commentText,
    required this.createdAt,
  });

  factory ProductComment.fromJson(Map<String, dynamic> json) {
    try {
      return ProductComment(
        commentId: json['CommentId'] ?? 0,
        userId: json['UserId'] ?? '',
        userName: json['UserName'] ?? 'Unknown',
        commentText: json['CommentText'] ?? '',
        createdAt:
            DateTime.parse(json['CreatedAt'] ?? DateTime.now().toString()),
      );
    } catch (e) {
      print('Error parsing ProductComment: $e');
      return ProductComment(
        commentId: 0,
        userId: '',
        userName: 'Error',
        commentText: 'Could not load comment',
        createdAt: DateTime.now(),
      );
    }
  }
}

Future<ProductCommentsResponse?> fetchProductComments(int productId) async {
  final url = Uri.parse(
      'https://innova-hub.premiumasp.net/api/Product/GetAllProductComments/$productId');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print('Raw API response: $jsonData'); // Debug print
      return ProductCommentsResponse.fromJson(jsonData);
    } else {
      print('Error: ${response.statusCode}, Body: ${response.body}');
      return null;
    }
  } catch (e) {
    print('Exception occurred: $e');
    return null;
  }
}
