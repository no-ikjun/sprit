import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/amplitude_service.dart';
import 'package:sprit/apis/services/book.dart';
import 'package:sprit/apis/services/book_library.dart';
import 'package:sprit/apis/services/record.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/util/functions.dart';
import 'package:sprit/common/value/amplitude_events.dart';
import 'package:sprit/popups/read/record_alert.dart';
import 'package:sprit/providers/user_info.dart';
import 'package:sprit/screens/read/widgets/selected_book_by_info.dart';
import 'package:sprit/screens/search/search_screen.dart';
import 'package:sprit/widgets/book_thumbnail.dart';
import 'package:sprit/widgets/custom_app_bar.dart';
import 'package:sprit/widgets/custom_button.dart';
import 'package:sprit/widgets/remove_glow.dart';
import 'package:sprit/widgets/toggle_button.dart';

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

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  bool isDateSelected = false;
  bool isTimeSelected = false;

  int startPage = 0;
  int endPage = 0;

  int readTime = 0;

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
                                                properties: {
                                                  'userUuid': context
                                                      .read<UserInfoState>()
                                                      .userInfo
                                                      .userUuid,
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
                                                properties: {
                                                  'userUuid': context
                                                      .read<UserInfoState>()
                                                      .userInfo
                                                      .userUuid,
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
                                                properties: {
                                                  'userUuid': context
                                                      .read<UserInfoState>()
                                                      .userInfo
                                                      .userUuid,
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
                                            properties: {
                                              'userUuid': context
                                                  .read<UserInfoState>()
                                                  .userInfo
                                                  .userUuid,
                                            },
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
                      const SizedBox(
                        height: 23,
                      ),
                      SizedBox(
                        width: Scaler.width(0.85, context),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '독서 날짜와 시간을 입력하세요 ⏰',
                              style: TextStyles.readRecordTitleStyle,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: Scaler.width(0.85, context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomButton(
                              width: Scaler.width(0.85, context) * 0.5 - 5,
                              height: 40,
                              color: isDateSelected
                                  ? ColorSet.lightGrey
                                  : ColorSet.primary.withOpacity(0.8),
                              borderColor: isDateSelected
                                  ? ColorSet.lightGrey
                                  : ColorSet.primary.withOpacity(0.8),
                              onPressed: () async {
                                DateTime selected = DateTime.now();
                                if (Platform.isAndroid) {
                                  selected =
                                      await showAndroidDatePicker(context) ??
                                          DateTime.now();
                                } else {
                                  selected = await showIosDatePicker(context) ??
                                      DateTime.now();
                                }
                                setState(() {
                                  selectedDate = selected;
                                  isDateSelected = true;
                                });
                              },
                              child: const Text(
                                '날짜 선택',
                                style: TextStyles.buttonLabelStyle,
                              ),
                            ),
                            CustomButton(
                              width: Scaler.width(0.85, context) * 0.5 - 5,
                              height: 40,
                              color: isTimeSelected
                                  ? ColorSet.lightGrey
                                  : ColorSet.primary.withOpacity(0.8),
                              borderColor: isTimeSelected
                                  ? ColorSet.lightGrey
                                  : ColorSet.primary.withOpacity(0.8),
                              onPressed: () async {
                                TimeOfDay selected = TimeOfDay.now();
                                if (Platform.isAndroid) {
                                  selected =
                                      await showAndroidTimePicker(context) ??
                                          TimeOfDay.now();
                                } else {
                                  selected = await showIosTimePicker(context) ??
                                      TimeOfDay.now();
                                }
                                setState(() {
                                  selectedTime = selected;
                                  isTimeSelected = true;
                                });
                              },
                              child: const Text(
                                '시간 선택',
                                style: TextStyles.buttonLabelStyle,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: Scaler.width(0.85, context),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  '독서 날짜',
                                  style: TextStyles.readRecordSubTitleStyle,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  isDateSelected
                                      ? '${selectedDate.year}년  ${selectedDate.month}월  ${selectedDate.day}일'
                                      : '-',
                                  style: TextStyles.readRecordDateStyle,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  '시작 시간',
                                  style: TextStyles.readRecordSubTitleStyle,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  isTimeSelected
                                      ? '${(selectedTime.hour > 13) ? '오후' : '오전'} ${selectedTime.hour % 12}시 ${selectedTime.minute}분'
                                      : '-',
                                  style: TextStyles.readRecordDateStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 23,
                      ),
                      SizedBox(
                        width: Scaler.width(0.85, context),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '독서량을 입력하세요 🌟',
                              style: TextStyles.readRecordTitleStyle,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      CustomToggleButton(
                        width: Scaler.width(0.85, context),
                        height: 40,
                        padding: 3,
                        radius: 8,
                        onLeftTap: () {
                          AmplitudeService().logEvent(
                            AmplitudeEvent.recordGoalType,
                            properties: {
                              'userUuid': context
                                  .read<UserInfoState>()
                                  .userInfo
                                  .userUuid,
                              'goalType': 'TIME',
                            },
                          );
                          setState(() {
                            goalType = 'TIME';
                          });
                        },
                        onRightTap: () {
                          AmplitudeService().logEvent(
                            AmplitudeEvent.recordGoalType,
                            properties: {
                              'userUuid': context
                                  .read<UserInfoState>()
                                  .userInfo
                                  .userUuid,
                              'goalType': 'PAGE',
                            },
                          );
                          setState(() {
                            goalType = 'PAGE';
                          });
                        },
                        leftText: const Text(
                          '시간 기준',
                          style: TextStyles.toggleButtonLabelStyle,
                        ),
                        rightText: const Text(
                          '페이지 수 기준',
                          style: TextStyles.toggleButtonLabelStyle,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      goalType == 'PAGE'
                          ? Container(
                              width: Scaler.width(0.85, context),
                              padding: const EdgeInsets.all(9),
                              decoration: BoxDecoration(
                                color: ColorSet.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    spreadRadius: 0,
                                    blurRadius: 4,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: Scaler.width(0.3, context),
                                        height: 40,
                                        child: TextField(
                                          autofocus: true,
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                              RegExp('[0-9]'),
                                            ),
                                          ],
                                          style: TextStyles.textFieldStyle
                                              .copyWith(
                                            fontSize: 16,
                                          ),
                                          onChanged: (value) => setState(() {
                                            startPage = int.parse(value);
                                          }),
                                          decoration: InputDecoration(
                                            hintText: '시작 페이지',
                                            hintStyle: TextStyles.textFieldStyle
                                                .copyWith(
                                              color: ColorSet.grey,
                                            ),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: ColorSet.primary,
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.all(5),
                                            filled: true,
                                            fillColor: Colors.white,
                                            enabledBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: ColorSet.border,
                                                width: 1.0,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '부터',
                                        style: TextStyles
                                            .readBookSettingMentStyle
                                            .copyWith(
                                          color: ColorSet.semiDarkGrey,
                                        ),
                                      ),
                                      SizedBox(
                                        width: Scaler.width(0.3, context),
                                        height: 40,
                                        child: TextField(
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                              RegExp('[0-9]'),
                                            ),
                                          ],
                                          style: TextStyles.textFieldStyle
                                              .copyWith(
                                            fontSize: 16,
                                          ),
                                          onChanged: (value) => setState(() {
                                            endPage = int.parse(value);
                                          }),
                                          decoration: InputDecoration(
                                            hintText: '끝 페이지',
                                            hintStyle: TextStyles.textFieldStyle
                                                .copyWith(
                                              color: ColorSet.grey,
                                            ),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: ColorSet.primary,
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.all(5),
                                            filled: true,
                                            fillColor: Colors.white,
                                            enabledBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: ColorSet.border,
                                                width: 1.0,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '까지',
                                        style: TextStyles
                                            .readBookSettingMentStyle
                                            .copyWith(
                                          color: ColorSet.semiDarkGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/images/information_grey_icon.svg',
                                        width: 12,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Text(
                                        '시작 페이지와 끝 페이지를 입력해주세요',
                                        style: TextStyles
                                            .readBookSettingWarningStyle,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  CustomButton(
                                    onPressed: () async {
                                      AmplitudeService().logEvent(
                                        AmplitudeEvent.recordAddButton,
                                        properties: {
                                          'userUuid': context
                                              .read<UserInfoState>()
                                              .userInfo
                                              .userUuid,
                                          'goalType': 'PAGE',
                                          'startPage': startPage,
                                        },
                                      );
                                      if (isBookSelected) {
                                        if (goalType == 'PAGE' &&
                                            (startPage == 0 || endPage == 0)) {
                                          showModal(
                                            context,
                                            const RecordAlert(
                                              title: '기록을 시작할 수 없음',
                                              description: '페이지를 입력해주세요',
                                            ),
                                            false,
                                          );
                                        } else if (!(isDateSelected &&
                                            isTimeSelected)) {
                                          showModal(
                                            context,
                                            const RecordAlert(
                                              title: '기록을 시작할 수 없음',
                                              description: '날짜와 시간을 입력해주세요',
                                            ),
                                            false,
                                          );
                                        } else if (startPage >= endPage) {
                                          showModal(
                                            context,
                                            const RecordAlert(
                                              title: '기록을 시작할 수 없음',
                                              description: '페이지를 정확히 입력해주세요',
                                            ),
                                            false,
                                          );
                                        } else {
                                          String result = await RecordService
                                              .addRecordAfterRead(
                                            context,
                                            bookInfo!.bookUuid,
                                            goalType,
                                            (endPage - startPage) * 2,
                                            startPage,
                                            endPage,
                                            selectedDate.add(Duration(
                                                hours: selectedTime.hour,
                                                minutes: selectedTime.minute)),
                                            selectedDate
                                                .add(Duration(
                                                    hours: selectedTime.hour,
                                                    minutes:
                                                        selectedTime.minute))
                                                .add(
                                                  Duration(
                                                    minutes:
                                                        (endPage - startPage) *
                                                            3,
                                                  ),
                                                ),
                                          );
                                          if (result == '') {
                                            showModal(
                                              context,
                                              const RecordAlert(
                                                title: '기록을 시작할 수 없음',
                                                description: '기록 추가에 실패했어요',
                                              ),
                                              false,
                                            );
                                          } else {
                                            Navigator.pop(context);
                                            showModal(
                                              context,
                                              const RecordAlert(
                                                  title: '기록 추가 완료',
                                                  description:
                                                      '정상적으로 추가되었어요.\n기록 탭에서 독서 기록을 확인하세요.'),
                                              false,
                                            );
                                          }
                                        }
                                      } else {
                                        showModal(
                                          context,
                                          const RecordAlert(
                                            title: '기록을 시작할 수 없음',
                                            description:
                                                '독서를 시작하려면\n읽을 책을 선택해야 해요',
                                          ),
                                          false,
                                        );
                                      }
                                    },
                                    width: Scaler.width(1, context),
                                    height: 45,
                                    child: const Text(
                                      '독서 기록 추가',
                                      style: TextStyles.loginButtonStyle,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              width: Scaler.width(0.85, context),
                              padding: const EdgeInsets.all(9),
                              decoration: BoxDecoration(
                                color: ColorSet.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    spreadRadius: 0,
                                    blurRadius: 4,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: Scaler.width(0.3, context),
                                        child: Column(
                                          children: [
                                            const Text(
                                              '독서 시간',
                                              style: TextStyles
                                                  .readRecordEndingTextButtonStyle,
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              readTime >= 60
                                                  ? '${readTime ~/ 60}시간\n${readTime % 60}분'
                                                  : '$readTime분',
                                              style: TextStyles
                                                  .readRecordTimeStyle,
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: Scaler.width(0.5, context),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                CustomButton(
                                                  width: Scaler.width(
                                                              0.5, context) *
                                                          0.5 -
                                                      2.5,
                                                  height: 40,
                                                  color:
                                                      ColorSet.superLightGrey,
                                                  borderColor:
                                                      ColorSet.superLightGrey,
                                                  onPressed: () {
                                                    HapticFeedback
                                                        .lightImpact();
                                                    setState(() {
                                                      readTime += 5;
                                                    });
                                                  },
                                                  child: const Text(
                                                    '+ 5분',
                                                    style: TextStyles
                                                        .readRecordButtonLabelStyle,
                                                  ),
                                                ),
                                                CustomButton(
                                                  width: Scaler.width(
                                                              0.5, context) *
                                                          0.5 -
                                                      2.5,
                                                  height: 40,
                                                  color:
                                                      ColorSet.superLightGrey,
                                                  borderColor:
                                                      ColorSet.superLightGrey,
                                                  onPressed: () {
                                                    HapticFeedback
                                                        .lightImpact();
                                                    setState(() {
                                                      readTime += 15;
                                                    });
                                                  },
                                                  child: const Text(
                                                    '+ 15분',
                                                    style: TextStyles
                                                        .readRecordButtonLabelStyle,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                CustomButton(
                                                  width: Scaler.width(
                                                              0.5, context) *
                                                          0.5 -
                                                      2.5,
                                                  height: 40,
                                                  color:
                                                      ColorSet.superLightGrey,
                                                  borderColor:
                                                      ColorSet.superLightGrey,
                                                  onPressed: () {
                                                    HapticFeedback
                                                        .lightImpact();
                                                    setState(() {
                                                      readTime += 30;
                                                    });
                                                  },
                                                  child: const Text(
                                                    '+ 30분',
                                                    style: TextStyles
                                                        .readRecordButtonLabelStyle,
                                                  ),
                                                ),
                                                CustomButton(
                                                  width: Scaler.width(
                                                              0.5, context) *
                                                          0.5 -
                                                      2.5,
                                                  height: 40,
                                                  color:
                                                      ColorSet.superLightGrey,
                                                  borderColor:
                                                      ColorSet.superLightGrey,
                                                  onPressed: () {
                                                    HapticFeedback
                                                        .lightImpact();
                                                    setState(() {
                                                      readTime += 60;
                                                    });
                                                  },
                                                  child: const Text(
                                                    '+ 1시간',
                                                    style: TextStyles
                                                        .readRecordButtonLabelStyle,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            CustomButton(
                                              onPressed: () {
                                                HapticFeedback.lightImpact();
                                                setState(() {
                                                  readTime = 0;
                                                });
                                              },
                                              width: Scaler.width(0.5, context),
                                              height: 40,
                                              color: ColorSet.superLightGrey,
                                              borderColor:
                                                  ColorSet.superLightGrey,
                                              child: const Text(
                                                '초기화',
                                                style: TextStyles
                                                    .readRecordButtonLabelStyle,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/images/information_grey_icon.svg',
                                        width: 12,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Text(
                                        '버튼을 눌러 독서 시간을 입력해주세요',
                                        style: TextStyles
                                            .readBookSettingWarningStyle,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  CustomButton(
                                    onPressed: () async {
                                      AmplitudeService().logEvent(
                                        AmplitudeEvent.recordAddButton,
                                        properties: {
                                          'userUuid': context
                                              .read<UserInfoState>()
                                              .userInfo
                                              .userUuid,
                                          'goalType': 'TIME',
                                          'startPage': startPage,
                                        },
                                      );
                                      if (isBookSelected) {
                                        if (goalType == 'TIME' &&
                                            readTime == 0) {
                                          showModal(
                                            context,
                                            const RecordAlert(
                                              title: '기록을 시작할 수 없음',
                                              description: '독서량을 입력해주세요',
                                            ),
                                            false,
                                          );
                                        } else if (!(isDateSelected &&
                                            isTimeSelected)) {
                                          showModal(
                                            context,
                                            const RecordAlert(
                                              title: '기록을 시작할 수 없음',
                                              description: '날짜와 시간을 입력해주세요',
                                            ),
                                            false,
                                          );
                                        } else {
                                          String result = await RecordService
                                              .addRecordAfterRead(
                                            context,
                                            bookInfo!.bookUuid,
                                            goalType,
                                            readTime,
                                            startPage,
                                            endPage,
                                            selectedDate.add(Duration(
                                                hours: selectedTime.hour,
                                                minutes: selectedTime.minute)),
                                            selectedDate
                                                .add(Duration(
                                                    hours: selectedTime.hour,
                                                    minutes:
                                                        selectedTime.minute))
                                                .add(Duration(
                                                    minutes: readTime)),
                                          );
                                          if (result == '') {
                                            showModal(
                                              context,
                                              const RecordAlert(
                                                title: '기록을 시작할 수 없음',
                                                description: '기록 추가에 실패했어요',
                                              ),
                                              false,
                                            );
                                          } else {
                                            Navigator.pop(context);
                                            showModal(
                                              context,
                                              const RecordAlert(
                                                  title: '기록 추가 완료',
                                                  description:
                                                      '정상적으로 추가되었어요.\n기록 탭에서 독서 기록을 확인하세요.'),
                                              false,
                                            );
                                          }
                                        }
                                      } else {
                                        showModal(
                                          context,
                                          const RecordAlert(
                                            title: '기록을 시작할 수 없음',
                                            description:
                                                '독서를 시작하려면\n읽을 책을 선택해야 해요',
                                          ),
                                          false,
                                        );
                                      }
                                    },
                                    width: Scaler.width(1, context),
                                    height: 45,
                                    child: const Text(
                                      '독서 기록 추가',
                                      style: TextStyles.loginButtonStyle,
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

Future<DateTime?> showAndroidDatePicker(BuildContext context) async {
  return showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime.now(),
    helpText: '날짜 선택',
    cancelText: '취소',
    confirmText: '확인',
    builder: (BuildContext context, Widget? widget) => Theme(
      data: ThemeData(
        colorScheme: const ColorScheme.light(primary: ColorSet.primary),
        datePickerTheme: const DatePickerThemeData(
          backgroundColor: Colors.white,
          dividerColor: ColorSet.primaryLight,
          headerBackgroundColor: ColorSet.primaryLight,
          headerForegroundColor: Colors.white,
        ),
      ),
      child: widget!,
    ),
  );
}

Future<DateTime?> showIosDatePicker(BuildContext context) async {
  DateTime? selectedDate = DateTime.now();

  await showCupertinoModalPopup(
    context: context,
    builder: (context) => Container(
      height: 350,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: const BoxDecoration(
              color: ColorSet.white,
              border: null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Text(
                    '취소',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Text(
                    '확인',
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () => Navigator.of(context).pop(selectedDate),
                ),
              ],
            ),
          ),
          // Date Picker
          Expanded(
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: DateTime.now(),
              minimumDate: DateTime(2000),
              maximumDate: DateTime.now(),
              onDateTimeChanged: (DateTime value) {
                selectedDate = value;
              },
            ),
          ),
        ],
      ),
    ),
  );

  return selectedDate;
}

Future<TimeOfDay?> showAndroidTimePicker(BuildContext context) async {
  return showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
    helpText: '시간 선택',
    cancelText: '취소',
    confirmText: '확인',
    builder: (BuildContext context, Widget? widget) => Theme(
      data: ThemeData(
        colorScheme: const ColorScheme.light(primary: ColorSet.primary),
        timePickerTheme: const TimePickerThemeData(
          backgroundColor: Colors.white,
          dialBackgroundColor: ColorSet.primaryLight,
          hourMinuteColor: ColorSet.primaryLight,
          hourMinuteTextColor: Colors.white,
        ),
      ),
      child: widget!,
    ),
  );
}

Future<TimeOfDay?> showIosTimePicker(BuildContext context) async {
  TimeOfDay selectedTime = TimeOfDay.now();

  await showCupertinoModalPopup(
    context: context,
    builder: (context) => Container(
      height: 350,
      color: Colors.white,
      child: Column(
        children: [
          // 상단 버튼 (취소 / 확인)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: const BoxDecoration(
              color: ColorSet.white,
              border: null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Text(
                    '취소',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Text(
                    '확인',
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () => Navigator.of(context).pop(selectedTime),
                ),
              ],
            ),
          ),

          // Time Picker
          Expanded(
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              initialDateTime: DateTime.now(),
              onDateTimeChanged: (DateTime value) {
                selectedTime = TimeOfDay.fromDateTime(value);
              },
            ),
          ),
        ],
      ),
    ),
  );

  return selectedTime;
}
