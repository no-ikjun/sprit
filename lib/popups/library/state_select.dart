import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/providers/library_book_state.dart';
import 'package:sprit/widgets/custom_button.dart';

class LibraryStateSelect extends StatefulWidget {
  final List<LibraryBookState> libraryBookState;
  final Function callback;
  const LibraryStateSelect({
    super.key,
    required this.libraryBookState,
    required this.callback,
  });

  @override
  State<LibraryStateSelect> createState() => _LibraryStateSelectState();
}

class _LibraryStateSelectState extends State<LibraryStateSelect> {
  List<LibraryBookState> bookLibraryByStateListStateList = [];

  @override
  void initState() {
    bookLibraryByStateListStateList = widget.libraryBookState;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 22,
        ),
        const Text(
          '책 정보 설정',
          style: TextStyles.notificationConfirmModalTitleStyle,
        ),
        const SizedBox(
          height: 14,
        ),
        const Text(
          '책 정보에 표시할 상태를 모두 선택하세요',
          style: TextStyles.notificationConfirmModalDescriptionStyle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          width: Scaler.width(0.85, context),
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  if (bookLibraryByStateListStateList
                      .contains(LibraryBookState.before)) {
                    bookLibraryByStateListStateList
                        .remove(LibraryBookState.before);
                  } else {
                    bookLibraryByStateListStateList
                        .add(LibraryBookState.before);
                  }
                  setState(() {});
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '앞으로 읽을 책',
                        style: TextStyles.myLibraryInfoStateStyle.copyWith(
                          color: bookLibraryByStateListStateList
                                  .contains(LibraryBookState.before)
                              ? ColorSet.primary
                              : ColorSet.grey,
                        ),
                      ),
                    ),
                    SvgPicture.asset(
                      bookLibraryByStateListStateList
                              .contains(LibraryBookState.before)
                          ? 'assets/images/check_icon_blue.svg'
                          : 'assets/images/check_icon_grey.svg',
                      width: 30,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () {
                  if (bookLibraryByStateListStateList
                      .contains(LibraryBookState.reading)) {
                    bookLibraryByStateListStateList
                        .remove(LibraryBookState.reading);
                  } else {
                    bookLibraryByStateListStateList
                        .add(LibraryBookState.reading);
                  }
                  setState(() {});
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '읽는 중인 책',
                        style: TextStyles.myLibraryInfoStateStyle.copyWith(
                          color: bookLibraryByStateListStateList
                                  .contains(LibraryBookState.reading)
                              ? ColorSet.primary
                              : ColorSet.grey,
                        ),
                      ),
                    ),
                    SvgPicture.asset(
                      bookLibraryByStateListStateList
                              .contains(LibraryBookState.reading)
                          ? 'assets/images/check_icon_blue.svg'
                          : 'assets/images/check_icon_grey.svg',
                      width: 30,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () {
                  if (bookLibraryByStateListStateList
                      .contains(LibraryBookState.after)) {
                    bookLibraryByStateListStateList
                        .remove(LibraryBookState.after);
                  } else {
                    bookLibraryByStateListStateList.add(LibraryBookState.after);
                  }
                  setState(() {});
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '이미 읽은 책',
                        style: TextStyles.myLibraryInfoStateStyle.copyWith(
                          color: bookLibraryByStateListStateList
                                  .contains(LibraryBookState.after)
                              ? ColorSet.primary
                              : ColorSet.grey,
                        ),
                      ),
                    ),
                    SvgPicture.asset(
                      bookLibraryByStateListStateList
                              .contains(LibraryBookState.after)
                          ? 'assets/images/check_icon_blue.svg'
                          : 'assets/images/check_icon_grey.svg',
                      width: 30,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        CustomButton(
          onPressed: () async {
            if (bookLibraryByStateListStateList.isEmpty) {
              bookLibraryByStateListStateList = [
                LibraryBookState.reading,
              ];
            }
            context
                .read<LibraryBookListState>()
                .updateLibraryBookState(bookLibraryByStateListStateList);
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            prefs.setString(
                'bookState', bookLibraryByStateListStateList.toString());
            widget.callback();
            Navigator.pop(context);
          },
          width: Scaler.width(0.85, context),
          height: 45,
          child: const Text(
            '적용하기',
            style: TextStyles.loginButtonStyle,
          ),
        ),
      ],
    );
  }
}
