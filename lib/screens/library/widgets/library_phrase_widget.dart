import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/amplitude_service.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/util/functions.dart';
import 'package:sprit/common/value/amplitude_events.dart';
import 'package:sprit/popups/library/delete_phrase.dart';
import 'package:sprit/popups/library/patch_phrase.dart';
import 'package:sprit/providers/user_info.dart';

class LibraryPhraseWidget extends StatelessWidget {
  final String phraseUuid;
  final String bookTitle;
  final String phrase;
  final Function callback;
  const LibraryPhraseWidget({
    super.key,
    required this.phraseUuid,
    required this.bookTitle,
    required this.phrase,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        AmplitudeService().logEvent(
          AmplitudeEvent.libraryPhraseDelete,
          context.read<UserInfoState>().userInfo.userUuid,
          eventProperties: {
            'bookTitle': bookTitle,
            'phrase': phrase,
          },
        );
        HapticFeedback.heavyImpact();
        showModal(
          context,
          DeletePhrase(
            bookTitle: bookTitle,
            phraseUuid: phraseUuid,
            callback: callback,
          ),
          false,
        );
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
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
                  onTap: () {
                    AmplitudeService().logEvent(
                      AmplitudeEvent.libraryPhraseShowMore,
                      context.read<UserInfoState>().userInfo.userUuid,
                      eventProperties: {
                        'bookTitle': bookTitle,
                        'phrase': phrase,
                      },
                    );
                    showModal(
                      context,
                      PatchPhrase(
                        bookTitle: bookTitle,
                        phrase: phrase,
                        phraseUuid: phraseUuid,
                        callback: callback,
                      ),
                      false,
                    );
                  },
                  child: const Icon(
                    Icons.edit,
                    color: ColorSet.lightGrey,
                    size: 20,
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
      ),
    );
  }
}
