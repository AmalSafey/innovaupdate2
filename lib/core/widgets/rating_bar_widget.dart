

import 'package:flutter/material.dart';

class RatingBarWidget extends StatelessWidget {
  final int stars;
  final double percentage;
  final Color color;

  const RatingBarWidget({
    super.key,
    required this.stars,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
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
}
