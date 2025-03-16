import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/amplitude_service.dart';
import 'package:sprit/apis/services/book.dart';
import 'package:sprit/apis/services/book_library.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/value/amplitude_events.dart';
import 'package:sprit/providers/user_info.dart';
import 'package:sprit/screens/read/widgets/selected_book_by_info.dart';
import 'package:sprit/screens/search/search_screen.dart';
import 'package:sprit/widgets/book_thumbnail.dart';
import 'package:sprit/widgets/custom_app_bar.dart';
import 'package:sprit/widgets/remove_glow.dart';

class AddRecordScreen extends StatefulWidget {
  final String bookUuid;
  const AddRecordScreen({super.key, required this.bookUuid});

  @override
  State<AddRecordScreen> createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  bool isBookInfoLoading = true;
  bool isBookSelected = false;
  BookInfo? bookInfo;

  Future<void> selectBook(BuildContext context, String bookUuid) async {
    setState(() {
      isBookInfoLoading = true;
    });
    BookInfo result = await BookInfoService.getBookInfoByUuid(
      context,
      bookUuid,
    );
    setState(() {
      bookInfo = result;
      isBookSelected = true;
      isBookInfoLoading = false;
    });
  }

  String state = 'READING';
  String goalType = 'TIME';

  List<BookInfo> bookInfoList = [];

  @override
  void initState() {
    super.initState();
    BookLibraryService.getBookLibrary(
      context,
      state,
    ).then((value) {
      setState(() {
        bookInfoList = value;
        isBookInfoLoading = false;
      });
    });
    if (widget.bookUuid != '') {
      selectBook(context, widget.bookUuid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorSet.background,
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: Column(
          children: [
            const CustomAppBar(
              label: '기록 추가',
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: RemoveGlow(),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: Scaler.width(0.85, context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              isBookSelected ? '책이 선택되었어요 📘' : '책을 선택해주세요 📕',
                              style: TextStyles.readRecordTitleStyle,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      !isBookSelected
                          ? Column(
                              children: [
                                SizedBox(
                                  width: Scaler.width(0.85, context),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              AmplitudeService().logEvent(
                                                AmplitudeEvent
                                                    .recordSelectButton,
                                                context
                                                    .read<UserInfoState>()
                                                    .userInfo
                                                    .userUuid,
                                                eventProperties: {
                                                  'state': 'READING',
                                                },
                                              );
                                              setState(() {
                                                state = 'READING';
                                                isBookInfoLoading = true;
                                              });
                                              await BookLibraryService
                                                  .getBookLibrary(
                                                context,
                                                state,
                                              ).then((value) {
                                                setState(() {
                                                  bookInfoList = value;
                                                  isBookInfoLoading = false;
                                                });
                                              });
                                            },
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            child: Container(
                                              height: 34,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 12,
                                              ),
                                              decoration: BoxDecoration(
                                                color: (state == 'READING')
                                                    ? ColorSet.primary
                                                        .withOpacity(0.8)
                                                    : ColorSet.superLightGrey,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(17),
                                                ),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                '읽는 중',
                                                style: TextStyles
                                                    .readBookSelectButtonStyle
                                                    .copyWith(
                                                  color: (state == 'READING')
                                                      ? ColorSet.white
                                                      : ColorSet.semiDarkGrey,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              AmplitudeService().logEvent(
                                                AmplitudeEvent
                                                    .recordSelectButton,
                                                context
                                                    .read<UserInfoState>()
                                                    .userInfo
                                                    .userUuid,
                                                eventProperties: {
                                                  'state': 'BEFORE',
                                                },
                                              );
                                              setState(() {
                                                state = 'BEFORE';
                                                isBookInfoLoading = true;
                                              });
                                              await BookLibraryService
                                                  .getBookLibrary(
                                                context,
                                                state,
                                              ).then((value) {
                                                setState(() {
                                                  bookInfoList = value;
                                                  isBookInfoLoading = false;
                                                });
                                              });
                                            },
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            child: Container(
                                              height: 34,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 12,
                                              ),
                                              decoration: BoxDecoration(
                                                color: (state == 'BEFORE')
                                                    ? ColorSet.primary
                                                        .withOpacity(0.8)
                                                    : ColorSet.superLightGrey,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(17),
                                                ),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                '독서 전',
                                                style: TextStyles
                                                    .readBookSelectButtonStyle
                                                    .copyWith(
                                                  color: (state == 'BEFORE')
                                                      ? ColorSet.white
                                                      : ColorSet.semiDarkGrey,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              AmplitudeService().logEvent(
                                                AmplitudeEvent
                                                    .recordSelectButton,
                                                context
                                                    .read<UserInfoState>()
                                                    .userInfo
                                                    .userUuid,
                                                eventProperties: {
                                                  'state': 'AFTER',
                                                },
                                              );
                                              setState(() {
                                                state = 'AFTER';
                                                isBookInfoLoading = true;
                                              });
                                              await BookLibraryService
                                                  .getBookLibrary(
                                                context,
                                                state,
                                              ).then((value) {
                                                setState(() {
                                                  bookInfoList = value;
                                                  isBookInfoLoading = false;
                                                });
                                              });
                                            },
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            child: Container(
                                              height: 34,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 12,
                                              ),
                                              decoration: BoxDecoration(
                                                color: (state == 'AFTER')
                                                    ? ColorSet.primary
                                                        .withOpacity(0.8)
                                                    : ColorSet.superLightGrey,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(17),
                                                ),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                '독서 후',
                                                style: TextStyles
                                                    .readBookSelectButtonStyle
                                                    .copyWith(
                                                  color: (state == 'AFTER')
                                                      ? ColorSet.white
                                                      : ColorSet.semiDarkGrey,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      InkWell(
                                        onTap: () {
                                          AmplitudeService().logEvent(
                                            AmplitudeEvent.recordSelectSearch,
                                            context
                                                .read<UserInfoState>()
                                                .userInfo
                                                .userUuid,
                                          );
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const SearchScreen(
                                                redirect: 'addRecord',
                                                //isFirstOpen: true,
                                              ),
                                            ),
                                          );
                                        },
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        child: const Row(
                                          children: [
                                            Text(
                                              '직접 검색',
                                              style: TextStyles
                                                  .readBookSearchButtonStyle,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Icon(
                                              Icons.search,
                                              size: 14,
                                              color: ColorSet.darkGrey,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                bookInfoList.isEmpty && !isBookInfoLoading
                                    ? Container(
                                        width: Scaler.width(0.85, context),
                                        height: 150,
                                        alignment: Alignment.center,
                                        child: Text(
                                          state == 'READING'
                                              ? '읽는 중인 책이 없어요 🥲'
                                              : '읽을 책목록이 비어있어요 😢',
                                          style: TextStyles
                                              .readBookSettingMentStyle
                                              .copyWith(
                                            color: ColorSet.semiDarkGrey,
                                          ),
                                        ),
                                      )
                                    : SizedBox(
                                        width: Scaler.width(1, context),
                                        height: 150,
                                        child: ScrollConfiguration(
                                          behavior: RemoveGlow(),
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: bookInfoList.length,
                                              itemBuilder: (context, index) {
                                                return Row(
                                                  children: [
                                                    (index == 0)
                                                        ? SizedBox(
                                                            width: Scaler.width(
                                                                0.075, context),
                                                          )
                                                        : const SizedBox(
                                                            width: 0,
                                                          ),
                                                    InkWell(
                                                      onTap: () async {
                                                        setState(() {
                                                          isBookSelected = true;
                                                        });
                                                        await selectBook(
                                                          context,
                                                          bookInfoList[index]
                                                              .bookUuid,
                                                        );
                                                      },
                                                      splashColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      child: BookThumbnail(
                                                          imgUrl: bookInfoList[
                                                                  index]
                                                              .thumbnail),
                                                    ),
                                                    (index ==
                                                            bookInfoList
                                                                    .length -
                                                                1)
                                                        ? SizedBox(
                                                            width: Scaler.width(
                                                                0.075, context),
                                                          )
                                                        : const SizedBox(
                                                            width: 10,
                                                          ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                              ],
                            )
                          : SizedBox(
                              width: Scaler.width(0.85, context),
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  bookInfo != null
                                      ? SelectedBookByInfo(
                                          isLoading: isBookInfoLoading,
                                          selectedBookInfo: bookInfo!,
                                        )
                                      : Container(),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          isBookSelected = false;
                                        });
                                      },
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      child: SvgPicture.asset(
                                        'assets/images/cancel_icon.svg',
                                        width: 25,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
