
import 'package:flutter/material.dart';
import 'package:innovahub_app/Models/products/comment_model.dart';
import 'package:intl/intl.dart';

class ReviewItemWidget extends StatelessWidget {
  final Comment comment;
  final double averageRating;

  const ReviewItemWidget({
    super.key,
    required this.comment,
    required this.averageRating,
  });

  @override
  Widget build(BuildContext context) {
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
                _formatTime(comment.createdAt),
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
                index < averageRating.toInt()
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

  String _formatTime(DateTime dateTime) {
    return DateFormat('h:mm a').format(dateTime);
  }
}
