import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/book.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/providers/selected_book.dart';
import 'package:sprit/widgets/book_thumbnail.dart';
import 'package:sprit/widgets/custom_button.dart';

class RecordShareModal extends StatelessWidget {
  const RecordShareModal({
    super.key,
    required this.amount,
  });

  final String amount;

  @override
  Widget build(BuildContext context) {
    final BookInfo bookInfo =
        context.read<SelectedBookInfoState>().getSelectedBookInfo;
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        child: SafeArea(
          maintainBottomViewPadding: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 8,
              ),
              Container(
                width: 60,
                height: 8,
                decoration: BoxDecoration(
                  color: ColorSet.superLightGrey,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: Scaler.width(0.8, context),
                decoration: BoxDecoration(
                  color: ColorSet.background,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: ColorSet.lightGrey,
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    SvgPicture.asset(
                      'assets/images/share_badge.svg',
                      width: 160,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      '2024년 1월 26일',
                      style: TextStyles.shareModalDateStyle,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      amount,
                      style: TextStyles.shareModalAmountStyle,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BookThumbnail(
                          imgUrl: bookInfo.thumbnail,
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
                              Text(
                                bookInfo.title,
                                style: TextStyles.shareModalBookTitleStyle,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '저자 ',
                                        style: TextStyles
                                            .shareModalBookAuthorStyle
                                            .copyWith(
                                          color: ColorSet.grey,
                                        ),
                                      ),
                                      Text(
                                        bookInfo.authors[0],
                                        style: TextStyles
                                            .shareModalBookAuthorStyle,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${bookInfo.publisher} · ${(bookInfo.publishedAt.length > 9) ? bookInfo.publishedAt.substring(0, 10) : bookInfo.publishedAt}',
                                    style: TextStyles.shareModalBookAuthorStyle
                                        .copyWith(
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
                      height: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CustomButton(
                onPressed: () {},
                width: Scaler.width(0.8, context),
                height: 45,
                child: const Text(
                  '공유하기',
                  style: TextStyles.loginButtonStyle,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
