import 'package:flutter/material.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';

class LibraryPhraseWidget extends StatelessWidget {
  final String phraseUuid;
  final String bookTitle;
  final String phrase;
  const LibraryPhraseWidget({
    super.key,
    required this.phraseUuid,
    required this.bookTitle,
    required this.phrase,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Scaler.width(0.85, context),
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
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        bookTitle,
                        style: TextStyles.myLibraryPhraseTitleStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {},
                child: const Icon(
                  Icons.edit,
                  color: ColorSet.lightGrey,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: Scaler.width(0.85, context) - 24,
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    phrase,
                    style: TextStyles.myLibraryPhraseDescriptionStyle,
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
