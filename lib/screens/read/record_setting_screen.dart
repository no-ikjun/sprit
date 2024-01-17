import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/book.dart';
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

class RecordSettingScreen extends StatefulWidget {
  final String bookUuid;
  const RecordSettingScreen({super.key, required this.bookUuid});

  @override
  State<RecordSettingScreen> createState() => _RecordSettingScreenState();
}

class _RecordSettingScreenState extends State<RecordSettingScreen> {
  bool isBookSelected = false;
  BookInfo bookInfo = const BookInfo(
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

  @override
  void initState() {
    super.initState();
    if (widget.bookUuid == '') {
      //선택된 책 없을 때
    } else {
      getBookInfoByUuid(context, widget.bookUuid).then((value) {
        setState(() {
          bookInfo = value;
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
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '읽을 책을 선택해주세요 📕',
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
                            Row(
                              children: [
                                Container(
                                  height: 34,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  decoration: const BoxDecoration(
                                    color: ColorSet.superLightGrey,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(17),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    '읽는 중인 책',
                                    style: TextStyles.readBookSelectButtonStyle,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Container(
                                  height: 34,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: ColorSet.primary.withOpacity(0.8),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(17),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '읽을 책 목록',
                                    style: TextStyles.readBookSelectButtonStyle
                                        .copyWith(
                                      color: ColorSet.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Row(
                              children: [
                                Text(
                                  '직접 검색',
                                  style: TextStyles.readBookSearchButtonStyle,
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
                        height: 150,
                        child: ScrollConfiguration(
                          behavior: RemoveGlow(),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: bookList.length,
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    (index == 0)
                                        ? SizedBox(
                                            width: Scaler.width(0.075, context),
                                          )
                                        : const SizedBox(
                                            width: 0,
                                          ),
                                    BookThumbnail(imgUrl: bookList[index]),
                                    (index == bookList.length - 1)
                                        ? SizedBox(
                                            width: Scaler.width(0.075, context),
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
