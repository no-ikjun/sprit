import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/book.dart';
import 'package:sprit/apis/services/book_library.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/widgets/book_thumbnail.dart';
import 'package:sprit/widgets/custom_app_bar.dart';
import 'package:sprit/widgets/custom_button.dart';
import 'package:sprit/widgets/remove_glow.dart';
import 'package:sprit/widgets/toggle_button.dart';

List<String> bookList = [
  "https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F5558360%3Ftimestamp%3D20231130163416",
  "https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F1492847%3Ftimestamp%3D20211121150826",
  "https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F5736671%3Ftimestamp%3D20221107221349",
  "https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F6054852%3Ftimestamp%3D20240105161839",
];

Future<BookInfo> getBookInfoByUuid(
  BuildContext context,
  String uuid,
) async {
  return await BookInfoService.getBookInfoByUuid(context, uuid);
}

Future<List<BookInfo>> getBookList(BuildContext context, String state) async {
  return await BookLibraryService.getBookLibrary(context, state);
}

class RecordSettingScreen extends StatefulWidget {
  final String bookUuid;
  const RecordSettingScreen({super.key, required this.bookUuid});

  @override
  State<RecordSettingScreen> createState() => _RecordSettingScreenState();
}

class _RecordSettingScreenState extends State<RecordSettingScreen> {
  String state = 'READING';

  bool isBookSelected = false;
  BookInfo selectedBookInfo = const BookInfo(
    bookUuid: '',
    isbn: '',
    title: '',
    authors: [],
    publisher: '',
    translators: [],
    searchUrl: '',
    thumbnail: '',
    content: '',
    publishedAt: '',
    updatedAt: '',
    score: 0,
  );

  List<BookInfo> bookInfoList = [];

  @override
  void initState() {
    super.initState();
    if (widget.bookUuid == '') {
      getBookList(context, state).then((value) {
        setState(() {
          bookInfoList = value;
        });
      });
    } else {
      getBookInfoByUuid(context, widget.bookUuid).then((value) {
        setState(() {
          selectedBookInfo = value;
          isBookSelected = true;
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
                                              });
                                              await getBookList(context, state)
                                                  .then((value) {
                                                setState(() {
                                                  bookInfoList = value;
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
                                              });
                                              await getBookList(context, state)
                                                  .then((value) {
                                                setState(() {
                                                  bookInfoList = value;
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
                                SizedBox(
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
                                                  await getBookInfoByUuid(
                                                          context,
                                                          bookInfoList[index]
                                                              .bookUuid)
                                                      .then((value) {
                                                    setState(() {
                                                      selectedBookInfo = value;
                                                      isBookSelected = true;
                                                    });
                                                  });
                                                },
                                                splashColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                child: BookThumbnail(
                                                    imgUrl: bookInfoList[index]
                                                        .thumbnail),
                                              ),
                                              (index == bookList.length - 1)
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
                                  Container(
                                    width: Scaler.width(0.85, context),
                                    padding: const EdgeInsets.all(15),
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
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        BookThumbnail(
                                          imgUrl: selectedBookInfo.thumbnail,
                                          width: 76.15,
                                          height: 110,
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        SizedBox(
                                          height: 110,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: Scaler.width(
                                                        0.85, context) -
                                                    118.15,
                                                child: Text(
                                                  selectedBookInfo.title,
                                                  style: TextStyles
                                                      .readBookSelectedTitleStyle,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        '저자 ',
                                                        style: TextStyles
                                                            .readBookSelectedDescriptionStyle
                                                            .copyWith(
                                                          color: ColorSet.grey,
                                                        ),
                                                      ),
                                                      Text(
                                                        selectedBookInfo
                                                            .authors[0],
                                                        style: TextStyles
                                                            .readBookSelectedDescriptionStyle,
                                                      ),
                                                      selectedBookInfo
                                                              .translators
                                                              .isNotEmpty
                                                          ? Text(
                                                              ' 번역 ',
                                                              style: TextStyles
                                                                  .readBookSelectedDescriptionStyle
                                                                  .copyWith(
                                                                color: ColorSet
                                                                    .grey,
                                                              ),
                                                            )
                                                          : const SizedBox(),
                                                      selectedBookInfo
                                                              .translators
                                                              .isNotEmpty
                                                          ? Text(
                                                              selectedBookInfo
                                                                  .translators[0],
                                                              style: TextStyles
                                                                  .readBookSelectedDescriptionStyle,
                                                            )
                                                          : const SizedBox(),
                                                    ],
                                                  ),
                                                  Text(
                                                    '${selectedBookInfo.publisher} · ${selectedBookInfo.publishedAt.substring(0, 10)}',
                                                    style: TextStyles
                                                        .readBookSelectedDescriptionStyle
                                                        .copyWith(
                                                      color: ColorSet.grey,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          isBookSelected = false;
                                          selectedBookInfo = const BookInfo(
                                            bookUuid: '',
                                            isbn: '',
                                            title: '',
                                            authors: [],
                                            publisher: '',
                                            translators: [],
                                            searchUrl: '',
                                            thumbnail: '',
                                            content: '',
                                            publishedAt: '',
                                            updatedAt: '',
                                            score: 0,
                                          );
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
                        onLeftTap: () {},
                        onRightTap: () {},
                        leftText: const Text(
                          '페이지 수 기준',
                          style: TextStyles.toggleButtonLabelStyle,
                        ),
                        rightText: const Text(
                          '시간 기준',
                          style: TextStyles.toggleButtonLabelStyle,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: Scaler.width(0.8, context) - 16 * 9,
                                  child: TextField(
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp('[0-9]'),
                                      ),
                                    ],
                                    style: TextStyles.textFieldStyle.copyWith(
                                      fontSize: 18,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: '페이지 수 입력',
                                      hintStyle:
                                          TextStyles.textFieldStyle.copyWith(
                                        color: ColorSet.grey,
                                        fontSize: 16,
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ColorSet.grey, width: 1.0),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                      ),
                                      contentPadding: const EdgeInsets.all(10),
                                      filled: true,
                                      fillColor: Colors.white,
                                      enabledBorder: const OutlineInputBorder(
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
                                  style: TextStyles.readBookSettingMentStyle,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              '몇 쪽부터 읽기 시작하는지 알려주세요',
                              style:
                                  TextStyles.readBookSettingMentStyle.copyWith(
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
                                    style: TextStyles.textFieldStyle.copyWith(
                                      fontSize: 16,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: '시작 페이지 번호',
                                      hintStyle:
                                          TextStyles.textFieldStyle.copyWith(
                                        color: ColorSet.grey,
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ColorSet.grey, width: 1.0),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                      ),
                                      contentPadding: const EdgeInsets.all(5),
                                      filled: true,
                                      fillColor: Colors.white,
                                      enabledBorder: const OutlineInputBorder(
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
                                  style: TextStyles.readBookSettingMentStyle
                                      .copyWith(
                                    color: ColorSet.semiDarkGrey,
                                  ),
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
                                  style: TextStyles.readBookSettingWarningStyle,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            CustomButton(
                              onPressed: () {},
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
