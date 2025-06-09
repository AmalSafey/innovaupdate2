
import 'package:innovahub_app/Models/products/comment_model.dart';
import 'package:innovahub_app/Models/products/rating_model.dart';

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