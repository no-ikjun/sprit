import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/review.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/widgets/star_row.dart';

class ReviewContent extends StatelessWidget {
  final ReviewInfo review;
  const ReviewContent({Key? key, required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            vertical: 14,
            horizontal: Scaler.width(0.075, context),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/profile_icon.svg',
                        width: 38,
                      ),
                      const SizedBox(width: 4),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '독자 ${review.userUuid.substring(2, 7)}',
                            style: TextStyles.bookReviewNameStyle,
                          ),
                          Text(
                            review.createdAt.substring(0, 10),
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
        Container(
          width: Scaler.width(1, context),
          height: 1,
          color: ColorSet.lightGrey,
        ),
      ],
    );
  }
}
