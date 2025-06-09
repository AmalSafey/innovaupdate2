
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