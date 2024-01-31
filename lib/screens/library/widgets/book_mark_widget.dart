import 'package:flutter/material.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/widgets/book_thumbnail.dart';

class BookMarkWidget extends StatelessWidget {
  final String bookUuid;
  final String thumbnail;
  final int lastPage;
  const BookMarkWidget({
    super.key,
    required this.bookUuid,
    required this.thumbnail,
    required this.lastPage,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          BookThumbnail(
            imgUrl: thumbnail,
            width: Scaler.width(0.25, context),
            height: Scaler.width(0.25, context) * 1.4444,
          ),
          const SizedBox(
            height: 5,
          ),
          const Text(
            '마지막 기록',
            style: TextStyles.myLibraryBookMarkStyle,
          ),
          Text(
            lastPage == 0 ? '기록 없음' : '$lastPage쪽',
            style: TextStyles.myLibraryBookMarkPageStyle,
          ),
        ],
      ),
    );
  }
}
