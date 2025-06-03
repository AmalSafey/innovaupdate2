import 'package:flutter/material.dart';
import 'package:innovahub_app/core/widgets/rating_semmary.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Test Page'),
        ),
        body: const Column(
          children: [
            RatingSummary(
              counter: 13,
              average: 3.846,
              counterFiveStars: 5,
              counterFourStars: 4,
              counterThreeStars: 2,
              counterTwoStars: 1,
              counterOneStars: 1,
            ),
          ],
        ));
  }
}
// user name
// user rating
// user description " review "
