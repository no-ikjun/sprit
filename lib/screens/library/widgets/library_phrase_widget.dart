import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
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
import 'package:sprit/widgets/book_thumbnail.dart';

class LibraryPhraseWidget extends StatefulWidget {
  final String phraseUuid;
  final String bookTitle;
  final String bookThumbnail;
  final String phrase;
  final int page;
  final Function callback;
  const LibraryPhraseWidget({
    super.key,
    required this.phraseUuid,
    required this.bookTitle,
    required this.bookThumbnail,
    required this.phrase,
    required this.page,
    required this.callback,
  });

  @override
  State<LibraryPhraseWidget> createState() => _LibraryPhraseWidgetState();
}

class _LibraryPhraseWidgetState extends State<LibraryPhraseWidget> {
  final GlobalKey _menuKey = GlobalKey();

  void _showPopupMenu(Offset position, BuildContext context) {
    showMenu(
      context: context,
      surfaceTintColor: Colors.transparent,
      color: ColorSet.white,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + 26,
        position.dx,
        position.dy,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      items: [
        PopupMenuItem<int>(
          value: 0,
          child: Row(
            children: [
              SvgPicture.asset('assets/images/edit_icon.svg', width: 18),
              const SizedBox(width: 8),
              const Text(
                '수정하기',
                style: TextStyles.myLibraryPhraseMenuStyle,
              ),
            ],
          ),
        ),
        PopupMenuItem<int>(
          value: 1,
          child: Row(
            children: [
              SvgPicture.asset('assets/images/trash_icon.svg', width: 18),
              const SizedBox(width: 8),
              const Text(
                '삭제하기',
                style: TextStyles.myLibraryPhraseMenuStyle,
              ),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value == 0) {
        AmplitudeService().logEvent(
          AmplitudeEvent.libraryPhraseUpdate,
          context.read<UserInfoState>().userInfo.userUuid,
          eventProperties: {
            'bookTitle': widget.bookTitle,
            'phrase': widget.phrase,
          },
        );
        showModal(
          context,
          PatchPhrase(
            bookTitle: widget.bookTitle,
            phrase: widget.phrase,
            phraseUuid: widget.phraseUuid,
            callback: widget.callback,
          ),
          false,
        );
      }
      if (value == 1) {
        AmplitudeService().logEvent(
          AmplitudeEvent.libraryPhraseDelete,
          context.read<UserInfoState>().userInfo.userUuid,
          eventProperties: {
            'bookTitle': widget.bookTitle,
            'phrase': widget.phrase,
          },
        );
        showModal(
          context,
          DeletePhrase(
            bookTitle: widget.bookTitle,
            phraseUuid: widget.phraseUuid,
            callback: widget.callback,
          ),
          false,
        );
      }
    });
  }

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: Scaler.width(0.85, context) - 30 - 42,
                child: Row(
                  children: [
                    BookThumbnail(
                      imgUrl: widget.bookThumbnail,
                      width: 34.62,
                      height: 50,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.bookTitle,
                            style: TextStyles.myLibraryPhraseTitleStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            widget.page == 0
                                ? '페이지 기록 없음'
                                : 'p. ${widget.page}',
                            style: TextStyles.myLibraryPhrasePageStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                key: _menuKey,
                onTap: () {
                  final RenderBox renderBox =
                      _menuKey.currentContext!.findRenderObject() as RenderBox;
                  final Offset position = renderBox.localToGlobal(Offset.zero);
                  _showPopupMenu(position, context);
                },
                child: SvgPicture.asset(
                  'assets/images/menu_icon.svg',
                  width: 21,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 11,
          ),
          SizedBox(
            width: Scaler.width(0.85, context) - 24,
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    widget.phrase,
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
