import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/review.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/util/functions.dart';
import 'package:sprit/widgets/star_row.dart';

class ReviewContent extends StatelessWidget {
  final ReviewInfo review;
  const ReviewContent({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Container(
          width: Scaler.width(0.85, context),
          decoration: BoxDecoration(
            color: ColorSet.white,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/profile_img.png',
                        width: 30,
                      ),
                      const SizedBox(width: 7),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            '독자 ${review.userUuid.substring(2, 7)}',
                            style: TextStyles.bookReviewNameStyle,
                          ),
                          Text(
                            getPastTime(review.createdAt),
                            style: TextStyles.bookReviewDateStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                  StarRowWidget(
                    star: review.score.toDouble(),
                    size: 14,
                    gap: 3,
                  )
                ],
              ),
              review.content == ''
                  ? const SizedBox(height: 0)
                  : const SizedBox(height: 10),
              review.content == ''
                  ? Container()
                  : SizedBox(
                      width: Scaler.width(0.85, context) - 20,
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              review.content,
                              style: TextStyles.bookReviewContentStyle,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
