import 'package:flutter/material.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/widgets/book_thumbnail.dart';

class GraphBookRecord extends StatelessWidget {
  const GraphBookRecord({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const BookThumbnail(
          imgUrl:
              'https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F6309543%3Ftimestamp%3D20231123162806',
          width: 55.38,
          height: 80,
        ),
        const SizedBox(
          width: 15,
        ),
        SizedBox(
          height: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: ColorSet.green,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text(
                        '당신이 모르는 민주주의',
                        style: TextStyles.analyticsGraphBookTitleStyle,
                      ),
                    ],
                  ),
                  const Text(
                    '저자 · 출판사',
                    style: TextStyles.analyticsGraphBookAuthorStyle,
                  ),
                ],
              ),
              SizedBox(
                width: Scaler.width(0.85, context) - 30 - 55.38 - 15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width:
                          (Scaler.width(0.85, context) - 30 - 55.38 - 15) * 0.7,
                      height: 5,
                      decoration: BoxDecoration(
                        color: ColorSet.superLightGrey,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const Text(
                      '7시간 17분',
                      style: TextStyles.analyticsGraphBookTimeStyle,
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
