import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/book.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/screens/read/widgets/selected_book.dart';
import 'package:sprit/widgets/custom_app_bar.dart';
import 'package:sprit/widgets/remove_glow.dart';

Future<BookInfo> getBookInfo(
  BuildContext context,
  String bookUuid,
) async {
  return await BookInfoService.getBookInfoByUuid(context, bookUuid);
}

class ReadTimerScreen extends StatefulWidget {
  final String bookUuid;
  const ReadTimerScreen({super.key, required this.bookUuid});

  @override
  State<ReadTimerScreen> createState() => _ReadTimerScreenState();
}

class _ReadTimerScreenState extends State<ReadTimerScreen> {
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

  @override
  void initState() {
    super.initState();
    getBookInfo(context, widget.bookUuid).then(
      (value) => setState(() {
        selectedBookInfo = value;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorSet.background,
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: Column(
          children: [
            const CustomAppBar(
              label: '독서 기록',
            ),
            ScrollConfiguration(
              behavior: RemoveGlow(),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SelectedBook(
                      selectedBookInfo: selectedBookInfo,
                      padding: 10,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text(
                      '독서 기록 중 🔥',
                      style: TextStyles.readRecordTitleStyle,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      width: Scaler.width(0.63, context),
                      height: Scaler.width(0.63, context),
                      decoration: BoxDecoration(
                        color: ColorSet.white,
                        borderRadius: BorderRadius.circular(
                          Scaler.width(0.63, context),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: ColorSet.primary.withOpacity(0.3),
                            offset: const Offset(0, 0),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 25),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              children: [
                                Text(
                                  '독서 목표',
                                  style: TextStyles.timerGoalTitleStyle,
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  '2시간',
                                  style: TextStyles.timerGoalDescriptionStyle,
                                ),
                              ],
                            ),
                            const Text(
                              '00:00:00',
                              style: TextStyles.timerTimeStyle,
                            ),
                            Column(
                              children: [
                                const SizedBox(
                                  height: 6,
                                ),
                                SvgPicture.asset(
                                  'assets/images/play_button.svg',
                                  width: Scaler.width(0.63, context) * 0.2,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Column(
                      children: [
                        const Text(
                          '기억하고 싶은 내용이 있다면?',
                          style: TextStyles.timerLeaveMentStyle,
                        ),
                        const SizedBox(
                          height: 9,
                        ),
                        InkWell(
                          onTap: () {},
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
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
                              horizontal: 8,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  '문구 남기기',
                                  style: TextStyles.timerLeaveButtonStyle,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                SvgPicture.asset(
                                  'assets/images/write_icon.svg',
                                  width: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 28,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: ColorSet.lightGrey,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 36,
                          ),
                          child: const Center(
                            child: Text(
                              '닫기',
                              style: TextStyles.timerEndingButtonStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: ColorSet.primary,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: ColorSet.primary.withOpacity(0.3),
                                offset: const Offset(0, 4),
                                blurRadius: 4,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                          child: const Center(
                            child: Text(
                              '저장 및 독서 종료',
                              style: TextStyles.timerEndingButtonStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
