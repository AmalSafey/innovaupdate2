/*import 'package:http/http.dart' as http;
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
*/
import 'dart:convert';
import 'package:http/http.dart' as http;

// Comment model
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

  Map<String, dynamic> toJson() {
    return {
      'CommentId': commentId,
      'UserId': userId,
      'UserName': userName,
      'CommentText': commentText,
      'CreatedAt': createdAt.toIso8601String(),
    };
  }
}

// Rating breakdown model
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

  Map<String, dynamic> toJson() {
    return {
      '1 star': oneStar,
      '2 star': twoStar,
      '3 star': threeStar,
      '4 star': fourStar,
      '5 star': fiveStar,
    };
  }
}

// Main comments response model
class ProductCommentsResponse {
  final String message;
  final int numOfComments;
  final List<Comment> comments;
  final double averageRating;
  final RatingBreakdown ratingBreakdown;

  ProductCommentsResponse({
    required this.message,
    required this.numOfComments,
    required this.comments,
    required this.averageRating,
    required this.ratingBreakdown,
  });

  factory ProductCommentsResponse.fromJson(Map<String, dynamic> json) {
    return ProductCommentsResponse(
      message: json['Message'],
      numOfComments: json['NumOfComments'],
      comments: (json['Comments'] as List)
          .map((commentJson) => Comment.fromJson(commentJson))
          .toList(),
      averageRating: (json['AverageRating'] ?? 0).toDouble(),
      ratingBreakdown: RatingBreakdown.fromJson(json['RatingBreakdown']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Message': message,
      'NumOfComments': numOfComments,
      'Comments': comments.map((comment) => comment.toJson()).toList(),
      'AverageRating': averageRating,
      'RatingBreakdown': ratingBreakdown.toJson(),
    };
  }
}

// API Service class
class ProductCommentsService {
  static const String baseUrl = 'https://innova-hub.premiumasp.net/api/Product';

  // Get all comments for a specific product
  static Future<ProductCommentsResponse?> getAllProductComments(
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
        return ProductCommentsResponse.fromJson(jsonData);
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
