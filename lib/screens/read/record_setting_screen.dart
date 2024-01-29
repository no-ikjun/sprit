import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/book.dart';
import 'package:sprit/apis/services/book_library.dart';
import 'package:sprit/apis/services/record.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/util/functions.dart';
import 'package:sprit/common/value/router.dart';
import 'package:sprit/popups/read/record_alert.dart';
import 'package:sprit/providers/selected_book.dart';
import 'package:sprit/providers/selected_record.dart';
import 'package:sprit/screens/read/widgets/selected_book.dart';
import 'package:sprit/widgets/book_thumbnail.dart';
import 'package:sprit/widgets/custom_app_bar.dart';
import 'package:sprit/widgets/custom_button.dart';
import 'package:sprit/widgets/remove_glow.dart';
import 'package:sprit/widgets/toggle_button.dart';

Future<String> setRecord(
  BuildContext context,
  String bookUuid,
  String goalType,
  int goalScale,
  int startPage,
) async {
  return await RecordService.setNewRecord(
    context,
    bookUuid,
    goalType,
    goalScale,
    startPage,
  );
}

Future<RecordInfo> getRecordInfoByUuid(
  BuildContext context,
  String recordUuid,
) async {
  return await RecordService.getRecordByRecordUuid(context, recordUuid);
}

Future<BookInfo> getBookInfoByUuid(
  BuildContext context,
  String uuid,
) async {
  return await BookInfoService.getBookInfoByUuid(context, uuid);
}

Future<List<BookInfo>> getBookList(BuildContext context, String state) async {
  return await BookLibraryService.getBookLibrary(context, state);
}

Future<bool> updateBookLibrary(
  BuildContext context,
  String bookUuid,
  String state,
) async {
  return await BookLibraryService.updateBookLibrary(context, bookUuid, state);
}

Future<int> getLastPage(
  BuildContext context,
  String bookUuid,
) async {
  return await RecordService.getLastPage(context, bookUuid);
}

class RecordSettingScreen extends StatefulWidget {
  final String bookUuid;
  const RecordSettingScreen({super.key, required this.bookUuid});

  @override
  State<RecordSettingScreen> createState() => _RecordSettingScreenState();
}

class _RecordSettingScreenState extends State<RecordSettingScreen> {
  bool isBookInfoLoading = true;

  Future<void> selectBook(BuildContext context, String bookUuid) async {
    setState(() {
      isBookSelected = true;
    });
    await getBookInfoByUuid(context, bookUuid).then((bookInfo) {
      context.read<SelectedBookInfoState>().updateSelectedBookUuid(bookInfo);
    });
  }

  String state = 'READING';
  String goalType = 'TIME';
  int goalTime = 0;
  int goalPage = 0;
  int startPage = 0;

  bool isBookSelected = false;

  List<BookInfo> bookInfoList = [];

  int lastPage = 0;

  @override
  void initState() {
    super.initState();
    getBookList(context, state).then((value) {
      setState(() {
        bookInfoList = value;
        isBookInfoLoading = false;
      });
    });
    if (widget.bookUuid != '') {
      setState(() {
        isBookSelected = true;
      });
      selectBook(context, widget.bookUuid);
      getLastPage(context, widget.bookUuid).then((value) {
        setState(() {
          lastPage = value;
        });
      });
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
              label: '독서 기록',
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
                              isBookSelected
                                  ? '읽을 책이 정해졌어요 📘'
                                  : '읽을 책을 선택해주세요 📕',
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
                                              setState(() {
                                                state = 'READING';
                                                isBookInfoLoading = true;
                                              });
                                              await getBookList(context, state)
                                                  .then((value) {
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
                                                '읽는 중인 책',
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
                                            width: 8,
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              setState(() {
                                                state = 'BEFORE';
                                                isBookInfoLoading = true;
                                              });
                                              await getBookList(context, state)
                                                  .then((value) {
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
                                                '읽을 책 목록',
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
                                        ],
                                      ),
                                      const Row(
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
                                      )
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
                                                        context
                                                            .read<
                                                                SelectedBookInfoState>()
                                                            .updateSelectedBookUuid(
                                                              bookInfoList[
                                                                  index],
                                                            );
                                                        getLastPage(
                                                          context,
                                                          bookInfoList[index]
                                                              .bookUuid,
                                                        ).then((value) {
                                                          setState(() {
                                                            lastPage = value;
                                                          });
                                                        });
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
                                  const SelectedBook(
                                    isLoading: false,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          isBookSelected = false;
                                          lastPage = 0;
                                          context
                                              .read<SelectedBookInfoState>()
                                              .removeSelectedBookUuid();
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
                              '목표 독서량을 설정해주세요 🌟',
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
                          setState(() {
                            goalType = 'TIME';
                            goalPage = 0;
                            goalTime = 0;
                          });
                        },
                        onRightTap: () {
                          setState(() {
                            goalType = 'PAGE';
                            goalPage = 0;
                            goalTime = 0;
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
                                        width:
                                            Scaler.width(0.8, context) - 16 * 9,
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
                                            fontSize: 18,
                                          ),
                                          onChanged: (value) => setState(() {
                                            goalPage = int.parse(value);
                                          }),
                                          decoration: InputDecoration(
                                            hintText: '페이지 수 입력',
                                            hintStyle: TextStyles.textFieldStyle
                                                .copyWith(
                                              color: ColorSet.grey,
                                              fontSize: 16,
                                            ),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: ColorSet.grey,
                                                  width: 1.0),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.all(10),
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
                                      const Text(
                                        '페이지 만큼 읽을게요',
                                        style:
                                            TextStyles.readBookSettingMentStyle,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    '몇 쪽부터 읽기 시작하는지 알려주세요',
                                    style: TextStyles.readBookSettingMentStyle
                                        .copyWith(
                                      color: ColorSet.semiDarkGrey,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 130,
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
                                            if (value == '') {
                                              startPage = 0;
                                              return;
                                            }
                                            startPage = int.parse(value);
                                          }),
                                          decoration: InputDecoration(
                                            hintText: '시작 페이지 번호',
                                            hintStyle: TextStyles.textFieldStyle
                                                .copyWith(
                                              color: ColorSet.grey,
                                            ),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: ColorSet.grey,
                                                  width: 1.0),
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
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '쪽',
                                        style: TextStyles
                                            .readBookSettingMentStyle
                                            .copyWith(
                                          color: ColorSet.semiDarkGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  (lastPage != 0 &&
                                          lastPage > startPage &&
                                          startPage != 0)
                                      ? Text(
                                          '저번에 $lastPage쪽까지 읽지 않으셨나요?',
                                          style: TextStyles
                                              .endReadingPageValidationStyle,
                                        )
                                      : Container(),
                                  const SizedBox(
                                    height: 6,
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
                                        '독서가 끝나면 독서 타이머를 멈추는 것을 잊지 마세요',
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
                                      if (isBookSelected) {
                                        if (goalType == 'PAGE' &&
                                            goalPage == 0) {
                                          showModal(
                                            context,
                                            const RecordAlert(
                                              title: '기록을 시작할 수 없음',
                                              description:
                                                  '독서를 시작하려면\n목표 독서량을 입력해야 해요',
                                            ),
                                            false,
                                          );
                                        } else if (goalType == 'PAGE' &&
                                            startPage == 0) {
                                          showModal(
                                            context,
                                            const RecordAlert(
                                              title: '기록을 시작할 수 없음',
                                              description: '시작 페이지를 입력해주세요',
                                            ),
                                            false,
                                          );
                                        } else if (goalType == 'PAGE' &&
                                            goalPage > 500) {
                                          showModal(
                                            context,
                                            const RecordAlert(
                                              title: '기록을 시작할 수 없음',
                                              description:
                                                  '독서 기록은 한 번에\n최대 500페이지까지만 가능해요',
                                            ),
                                            false,
                                          );
                                        } else {
                                          await setRecord(
                                            context,
                                            context
                                                .read<SelectedBookInfoState>()
                                                .getSelectedBookInfo
                                                .bookUuid,
                                            'PAGE',
                                            goalPage,
                                            startPage,
                                          ).then((value) async {
                                            if (value != '') {
                                              await getRecordInfoByUuid(
                                                      context, value)
                                                  .then(
                                                (value) {
                                                  context
                                                      .read<
                                                          SelectedRecordInfoState>()
                                                      .updateSelectedRecord(
                                                          value);
                                                  Navigator.pushNamed(
                                                    context,
                                                    RouteName.readTimer,
                                                  );
                                                  updateBookLibrary(
                                                    context,
                                                    context
                                                        .read<
                                                            SelectedBookInfoState>()
                                                        .getSelectedBookInfo
                                                        .bookUuid,
                                                    'READING',
                                                  );
                                                },
                                              );
                                            } else {
                                              showModal(
                                                context,
                                                const RecordAlert(
                                                  title: '기록을 시작할 수 없음',
                                                  description: '다시 시도해주세요',
                                                ),
                                                false,
                                              );
                                            }
                                          });
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
                                      '독서 시작',
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
                                        width: Scaler.width(0.8, context) -
                                            16 * 6.5,
                                        child: DropdownButtonFormField2(
                                          isExpanded: true,
                                          decoration: const InputDecoration(
                                            contentPadding:
                                                EdgeInsetsDirectional.symmetric(
                                              vertical: 5,
                                              horizontal: 10,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              borderSide: BorderSide(
                                                color: ColorSet.border,
                                                width: 1.0,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              borderSide: BorderSide(
                                                color: ColorSet.border,
                                                width: 1.0,
                                              ),
                                            ),
                                          ),
                                          hint: Text(
                                            '목표 시간 선택',
                                            style: TextStyles.textFieldStyle
                                                .copyWith(
                                              color: ColorSet.grey,
                                              fontSize: 16,
                                            ),
                                          ),
                                          items: [
                                            DropdownMenuItem(
                                              value: 10,
                                              child: Text(
                                                '10분',
                                                style: TextStyles.textFieldStyle
                                                    .copyWith(
                                                  color: ColorSet.darkGrey,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            DropdownMenuItem(
                                              value: 30,
                                              child: Text(
                                                '30분',
                                                style: TextStyles.textFieldStyle
                                                    .copyWith(
                                                  color: ColorSet.darkGrey,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            DropdownMenuItem(
                                              value: 60,
                                              child: Text(
                                                '1시간',
                                                style: TextStyles.textFieldStyle
                                                    .copyWith(
                                                  color: ColorSet.darkGrey,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            DropdownMenuItem(
                                              value: 120,
                                              child: Text(
                                                '2시간',
                                                style: TextStyles.textFieldStyle
                                                    .copyWith(
                                                  color: ColorSet.darkGrey,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            DropdownMenuItem(
                                              value: 180,
                                              child: Text(
                                                '3시간',
                                                style: TextStyles.textFieldStyle
                                                    .copyWith(
                                                  color: ColorSet.darkGrey,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            DropdownMenuItem(
                                              value: 240,
                                              child: Text(
                                                '4시간',
                                                style: TextStyles.textFieldStyle
                                                    .copyWith(
                                                  color: ColorSet.darkGrey,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ],
                                          validator: (value) {
                                            if (value == null) {
                                              return '이유를 선택해주세요';
                                            }
                                            return null;
                                          },
                                          onChanged: (value) {
                                            setState(() {
                                              goalTime = value as int;
                                            });
                                          },
                                          buttonStyleData: ButtonStyleData(
                                            padding:
                                                const EdgeInsets.only(right: 8),
                                            overlayColor: MaterialStateProperty
                                                .resolveWith<Color?>(
                                              (Set<MaterialState> states) {
                                                if (states.contains(
                                                    MaterialState.pressed)) {
                                                  return Colors.transparent;
                                                }
                                                return Colors.transparent;
                                              },
                                            ),
                                          ),
                                          iconStyleData: const IconStyleData(
                                            icon: Icon(
                                              Icons.arrow_drop_down,
                                              color: ColorSet.grey,
                                            ),
                                            iconSize: 24,
                                          ),
                                          dropdownStyleData: DropdownStyleData(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          menuItemStyleData: MenuItemStyleData(
                                            overlayColor: MaterialStateProperty
                                                .resolveWith<Color?>(
                                              (Set<MaterialState> states) {
                                                if (states.contains(
                                                    MaterialState.pressed)) {
                                                  return Colors.transparent;
                                                }
                                                return Colors.transparent;
                                              },
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        '동안 읽을게요',
                                        style:
                                            TextStyles.readBookSettingMentStyle,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 12,
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
                                        '독서가 끝나면 독서 타이머를 멈추는 것을 잊지 마세요',
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
                                      if (isBookSelected) {
                                        if (goalType == 'TIME' &&
                                            goalTime == 0) {
                                          showModal(
                                            context,
                                            const RecordAlert(
                                              title: '기록을 시작할 수 없음',
                                              description:
                                                  '독서를 시작하려면\n목표 독서량을 입력해야 해요',
                                            ),
                                            false,
                                          );
                                        } else {
                                          await setRecord(
                                            context,
                                            context
                                                .read<SelectedBookInfoState>()
                                                .getSelectedBookInfo
                                                .bookUuid,
                                            'TIME',
                                            goalTime,
                                            startPage,
                                          ).then((value) async {
                                            if (value != '') {
                                              await getRecordInfoByUuid(
                                                      context, value)
                                                  .then(
                                                (value) {
                                                  context
                                                      .read<
                                                          SelectedRecordInfoState>()
                                                      .updateSelectedRecord(
                                                          value);
                                                  Navigator.pushNamed(
                                                    context,
                                                    RouteName.readTimer,
                                                  );
                                                  updateBookLibrary(
                                                    context,
                                                    context
                                                        .read<
                                                            SelectedBookInfoState>()
                                                        .getSelectedBookInfo
                                                        .bookUuid,
                                                    'READING',
                                                  );
                                                },
                                              );
                                            } else {
                                              showModal(
                                                context,
                                                const RecordAlert(
                                                  title: '기록을 시작할 수 없음',
                                                  description: '다시 시도해주세요',
                                                ),
                                                false,
                                              );
                                            }
                                          });
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
                                      '독서 시작',
                                      style: TextStyles.loginButtonStyle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      const SizedBox(
                        height: 20,
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
