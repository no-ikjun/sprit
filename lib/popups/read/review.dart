import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/amplitude_service.dart';
import 'package:sprit/apis/services/review.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/value/amplitude_events.dart';
import 'package:sprit/providers/selected_book.dart';
import 'package:sprit/providers/user_info.dart';
import 'package:sprit/widgets/book_thumbnail.dart';
import 'package:sprit/widgets/custom_button.dart';

Future<bool> setReview(
  BuildContext context,
  int score,
  String bookUuid,
  String content,
) async {
  return await ReviewService.setReview(context, score, bookUuid, content);
}

class ReviewModal extends StatefulWidget {
  const ReviewModal({
    super.key,
  });
  @override
  State<ReviewModal> createState() => _ReviewModalState();
}

class _ReviewModalState extends State<ReviewModal> {
  String review = '';
  int score = 5;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 22,
        ),
        const Text(
          '방금 읽으신 책은 어땠나요?',
          style: TextStyles.notificationConfirmModalTitleStyle,
        ),
        const SizedBox(
          height: 14,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BookThumbnail(
              imgUrl: context
                  .read<SelectedBookInfoState>()
                  .getSelectedBookInfo
                  .thumbnail,
              width: 55.38,
              height: 80,
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: Scaler.width(0.8, context) - 87.38,
                    ),
                    child: Text(
                      context
                          .read<SelectedBookInfoState>()
                          .getSelectedBookInfo
                          .title,
                      style: TextStyles.shareModalBookTitleStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '저자 ',
                            style:
                                TextStyles.shareModalBookAuthorStyle.copyWith(
                              color: ColorSet.grey,
                            ),
                          ),
                          Text(
                            context
                                .read<SelectedBookInfoState>()
                                .getSelectedBookInfo
                                .authors[0],
                            style: TextStyles.shareModalBookAuthorStyle,
                          ),
                        ],
                      ),
                      Text(
                        '${context.read<SelectedBookInfoState>().getSelectedBookInfo.publisher} · ${(context.read<SelectedBookInfoState>().getSelectedBookInfo.publishedAt.length > 9) ? context.read<SelectedBookInfoState>().getSelectedBookInfo.publishedAt.substring(0, 10) : context.read<SelectedBookInfoState>().getSelectedBookInfo.publishedAt}',
                        style: TextStyles.shareModalBookAuthorStyle.copyWith(
                          color: ColorSet.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
        const SizedBox(
          height: 14,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  score = 1;
                });
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: SvgPicture.asset(
                score > 0
                    ? 'assets/images/star_yellow.svg'
                    : 'assets/images/star_grey.svg',
                width: 24,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  score = 2;
                });
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: SvgPicture.asset(
                score > 1
                    ? 'assets/images/star_yellow.svg'
                    : 'assets/images/star_grey.svg',
                width: 24,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  score = 3;
                });
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: SvgPicture.asset(
                score > 2
                    ? 'assets/images/star_yellow.svg'
                    : 'assets/images/star_grey.svg',
                width: 24,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  score = 4;
                });
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: SvgPicture.asset(
                score > 3
                    ? 'assets/images/star_yellow.svg'
                    : 'assets/images/star_grey.svg',
                width: 24,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  score = 5;
                });
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: SvgPicture.asset(
                score > 4
                    ? 'assets/images/star_yellow.svg'
                    : 'assets/images/star_grey.svg',
                width: 24,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 18,
        ),
        SizedBox(
          width: Scaler.width(0.8, context),
          child: TextField(
            onChanged: (value) {
              setState(() {
                review = value;
              });
            },
            autofocus: true,
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: "한줄평을 적어주세요",
              hintStyle: TextStyles.timerBottomSheetHintTextStyle,
              contentPadding: EdgeInsets.all(15),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: ColorSet.lightGrey,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: ColorSet.lightGrey,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        CustomButton(
          width: Scaler.width(0.85, context),
          height: 50,
          onPressed: () async {
            AmplitudeService().logEvent(
              AmplitudeEvent.recordReviewSaveButton,
              properties: {
                'userUuid': context.read<UserInfoState>().userInfo.userUuid,
              },
            );
            await setReview(
              context,
              score,
              context
                  .read<SelectedBookInfoState>()
                  .getSelectedBookInfo
                  .bookUuid,
              review,
            );
            Navigator.pop(context);
          },
          child: const Text(
            '작성 완료',
            style: TextStyles.buttonLabelStyle,
          ),
        ),
      ],
    );
  }
}
