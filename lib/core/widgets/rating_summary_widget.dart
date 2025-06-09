
import 'package:flutter/material.dart';
import 'package:innovahub_app/Models/products/rating_model.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:innovahub_app/core/widgets/rating_bar_widget.dart';

class RatingSummaryWidget extends StatelessWidget {
  final double averageRating;
  final int numOfComments;
  final RatingBreakdown ratingBreakdown;

  const RatingSummaryWidget({
    super.key,
    required this.averageRating,
    required this.numOfComments,
    required this.ratingBreakdown,
  });

  @override
  Widget build(BuildContext context) {
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
              averageRating.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Constant.black2Color,
              ),
            ),
            Text(
              'Based on $numOfComments Ratings',
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
              RatingBarWidget(
                stars: 5,
                percentage: totalRatings > 0 ? ratingBreakdown.fiveStar / totalRatings : 0,
                color: Colors.green,
              ),
              RatingBarWidget(
                stars: 4,
                percentage: totalRatings > 0 ? ratingBreakdown.fourStar / totalRatings : 0,
                color: Colors.lightGreen,
              ),
              RatingBarWidget(
                stars: 3,
                percentage: totalRatings > 0 ? ratingBreakdown.threeStar / totalRatings : 0,
                color: Colors.amber,
              ),
              RatingBarWidget(
                stars: 2,
                percentage: totalRatings > 0 ? ratingBreakdown.twoStar / totalRatings : 0,
                color: Colors.orange,
              ),
              RatingBarWidget(
                stars: 1,
                percentage: totalRatings > 0 ? ratingBreakdown.oneStar / totalRatings : 0,
                color: Colors.deepOrange,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
