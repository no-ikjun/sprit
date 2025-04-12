import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/amplitude_service.dart';
import 'package:sprit/apis/services/book_library.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/util/functions.dart';
import 'package:sprit/common/value/amplitude_events.dart';
import 'package:sprit/common/value/router.dart';
import 'package:sprit/popups/library/state_select.dart';
import 'package:sprit/providers/library_book_state.dart';
import 'package:sprit/providers/user_info.dart';
import 'package:sprit/screens/library/widgets/my_book_info.dart';

Future<BookLibraryByStateListCallback> getBookLibraryByState(
  BuildContext context,
  List<LibraryBookState> stateList,
  int page,
) async {
  return await BookLibraryService.getBookLibraryByState(
    context,
    stateList,
    page,
  );
}

class MyBookInfoComponent extends StatefulWidget {
  const MyBookInfoComponent({super.key});

  @override
  State<MyBookInfoComponent> createState() => _MyBookInfoComponentState();
}

class _MyBookInfoComponentState extends State<MyBookInfoComponent> {
  List<BookLibraryByStateList> bookLibraryByStateList = [];
  bool bookLibraryByStateListMoreAvailable = false;
  int bookLibraryByStateListCurrentPage = 1;

  void _initialize() async {
    final result = await getBookLibraryByState(
      context,
      context.read<LibraryBookListState>().getLibraryBookState,
      bookLibraryByStateListCurrentPage,
    );
    if (mounted) {
      setState(() {
        bookLibraryByStateList = result.bookLibraryByStateList;
        bookLibraryByStateListMoreAvailable = result.moreAvailable;
      });
    }
  }

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: Scaler.width(0.85, context),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                '나의 책 정보',
                style: TextStyles.myLibrarySubTitleStyle,
              ),
              const SizedBox(
                width: 15,
              ),
              InkWell(
                onTap: () {
                  AmplitudeService().logEvent(
                    AmplitudeEvent.libraryMyBookChoiceButton,
                    properties: {
                      'userUuid':
                          context.read<UserInfoState>().userInfo.userUuid,
                    },
                  );
                  showModal(
                      context,
                      LibraryStateSelect(
                          libraryBookState: context
                              .read<LibraryBookListState>()
                              .getLibraryBookState,
                          callback: () async {
                            setState(() {
                              bookLibraryByStateList = [];
                              bookLibraryByStateListMoreAvailable = false;
                              bookLibraryByStateListCurrentPage = 1;
                            });
                            await getBookLibraryByState(
                              context,
                              context
                                  .read<LibraryBookListState>()
                                  .getLibraryBookState,
                              bookLibraryByStateListCurrentPage,
                            ).then((value) {
                              setState(() {
                                bookLibraryByStateList =
                                    value.bookLibraryByStateList;
                                bookLibraryByStateListMoreAvailable =
                                    value.moreAvailable;
                                bookLibraryByStateListCurrentPage = 1;
                              });
                            });
                          }),
                      false);
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Row(
                  children: [
                    Text(
                      getSelectedKindString(
                        context
                            .watch<LibraryBookListState>()
                            .getLibraryBookState,
                      ),
                      style: TextStyles.myLibraryMyBookStyle,
                    ),
                    SvgPicture.asset(
                      'assets/images/show_more_semi_dark_grey.svg',
                      width: 21,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        bookLibraryByStateList.isNotEmpty
            ? Container(
                width: Scaler.width(0.85, context),
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: ColorSet.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ListView.builder(
                      itemCount: bookLibraryByStateList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            MyBookInfoWidget(
                              bookUuid: bookLibraryByStateList[index].bookUuid,
                              count: bookLibraryByStateList[index].count,
                              state: bookLibraryByStateList[index].state,
                              callback: () {
                                setState(() {
                                  bookLibraryByStateList = [];
                                  bookLibraryByStateListMoreAvailable = false;
                                  bookLibraryByStateListCurrentPage = 1;
                                });
                                getBookLibraryByState(
                                  context,
                                  context
                                      .read<LibraryBookListState>()
                                      .getLibraryBookState,
                                  bookLibraryByStateListCurrentPage,
                                ).then((value) {
                                  setState(() {
                                    bookLibraryByStateList =
                                        value.bookLibraryByStateList;
                                    bookLibraryByStateListMoreAvailable =
                                        value.moreAvailable;
                                    bookLibraryByStateListCurrentPage = 1;
                                  });
                                });
                              },
                            ),
                            index != bookLibraryByStateList.length - 1
                                ? const SizedBox(
                                    height: 12,
                                  )
                                : Container(),
                          ],
                        );
                      },
                    ),
                    bookLibraryByStateListMoreAvailable
                        ? Column(
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              InkWell(
                                onTap: () async {
                                  AmplitudeService().logEvent(
                                    AmplitudeEvent.libraryMyBookShowMore,
                                    properties: {
                                      'userUuid': context
                                          .read<UserInfoState>()
                                          .userInfo
                                          .userUuid,
                                    },
                                  );
                                  await getBookLibraryByState(
                                    context,
                                    context
                                        .read<LibraryBookListState>()
                                        .getLibraryBookState,
                                    bookLibraryByStateListCurrentPage + 1,
                                  ).then((value) {
                                    setState(() {
                                      bookLibraryByStateList
                                          .addAll(value.bookLibraryByStateList);
                                      bookLibraryByStateListMoreAvailable =
                                          value.moreAvailable;
                                      bookLibraryByStateListCurrentPage++;
                                    });
                                  });
                                },
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      '더보기',
                                      style: TextStyles.myLibraryShowMoreStyle,
                                    ),
                                    SvgPicture.asset(
                                      'assets/images/show_more_grey.svg',
                                      width: 21,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        : bookLibraryByStateList.length > 3
                            ? Column(
                                children: [
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      setState(() {
                                        bookLibraryByStateList =
                                            bookLibraryByStateList.sublist(
                                                0, 3);
                                        bookLibraryByStateListMoreAvailable =
                                            true;
                                        bookLibraryByStateListCurrentPage = 1;
                                      });
                                    },
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          '숨기기',
                                          style:
                                              TextStyles.myLibraryShowMoreStyle,
                                        ),
                                        Transform.rotate(
                                          angle: 180 * math.pi / 180,
                                          child: SvgPicture.asset(
                                            'assets/images/show_more_grey.svg',
                                            width: 21,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                  ],
                ),
              )
            : Container(
                width: Scaler.width(0.85, context),
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: ColorSet.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: Scaler.width(0.85, context),
                  height: 80,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '등록된 책 정보가 없어요',
                          style: TextStyles.myLibraryWarningStyle.copyWith(
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              RouteName.search,
                            );
                          },
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: ColorSet.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  offset: const Offset(0, 0),
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '책 검색하고 등록하기 ',
                                  style: TextStyles.myLibraryBookMarkEmptyStyle,
                                ),
                                Icon(
                                  Icons.search,
                                  size: 16,
                                  color: ColorSet.darkGrey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
