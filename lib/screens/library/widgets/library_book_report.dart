import 'package:flutter/material.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/book_report.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';

class LibraryBookReportWidget extends StatelessWidget {
  final BookReportInfo bookReportInfo;
  const LibraryBookReportWidget({
    super.key,
    required this.bookReportInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Scaler.width(0.85, context),
      height: Scaler.width(0.85, context) * 0.86,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: ColorSet.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 0),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: Scaler.width(0.85, context) - 30 - 42,
                child: const Row(
                  children: [
                    Flexible(
                      child: Text(
                        '역행자',
                        style: TextStyles.myLibraryBookReportTitleStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                '2021-09-09',
                style: TextStyles.myLibraryBookReportDateStyle,
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: Scaler.width(0.85, context) - 24,
            child: const Row(
              children: [
                Flexible(
                  child: Text(
                    '이 책의 핵심은 크게 나누면 두 가지로 나뉜다고 생각한다. 1. 인간의 어미얼미;나ㅓ린ㅁ아ㅓ',
                    style: TextStyles.myLibraryBookReportStyle,
                    overflow: TextOverflow.clip,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
