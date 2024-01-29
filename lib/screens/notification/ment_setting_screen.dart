import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/book.dart';
import 'package:sprit/apis/services/phrase.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/screens/notification/widgets/remind_ment.dart';
import 'package:sprit/widgets/custom_app_bar.dart';
import 'package:sprit/widgets/custom_button.dart';
import 'package:sprit/widgets/remove_glow.dart';

Future<List<PhraseInfo>> getPhraseList(BuildContext context) async {
  return await PhraseService.getAllPhrase(context);
}

Future<BookInfo> getBookInfo(BuildContext context, String bookUuid) async {
  return await BookInfoService.getBookInfoByUuid(context, bookUuid);
}

class MentSettingScreen extends StatefulWidget {
  const MentSettingScreen({super.key});

  @override
  State<MentSettingScreen> createState() => _MentSettingScreenState();
}

class _MentSettingScreenState extends State<MentSettingScreen> {
  List<PhraseInfo> phraseList = [];
  List<BookInfo> bookInfoList = [];
  List<bool> switchValueList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getPhraseList(context).then((value) async {
      for (var element in value) {
        await getBookInfo(context, element.bookUuid).then((value) {
          bookInfoList.add(value);
          setState(() {
            switchValueList.add(element.remind);
          });
        });
      }
      setState(() {
        phraseList = value;
        isLoading = false;
      });
    });
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
              label: "알림 설정",
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: RemoveGlow(),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: Scaler.width(0.85, context),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '리마인드 문구 선택 💬',
                                  style: TextStyles
                                      .notificationTimeSettingTitleStyle,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: Scaler.width(0.85, context),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: phraseList.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    RemindMentWidget(
                                      title: bookInfoList[index].title,
                                      description: phraseList[index].phrase,
                                      switchValue: switchValueList[index],
                                      onToggle: () async {
                                        if (phraseList[index].phrase.length >
                                            40) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                '40자 이하의 문구만 선택 가능합니다',
                                              ),
                                              backgroundColor: ColorSet.text,
                                            ),
                                          );
                                        } else {
                                          setState(() {
                                            switchValueList[index] =
                                                !switchValueList[index];
                                          });
                                          await PhraseService.updatePhrase(
                                            context,
                                            phraseList[index].phraseUuid,
                                            switchValueList[index],
                                          );
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: Scaler.width(0.85, context),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomButton(
                                  onPressed: () {},
                                  width: Scaler.width(0.85 * 0.4, context) - 5,
                                  height: 45,
                                  color: ColorSet.lightGrey,
                                  borderColor: ColorSet.lightGrey,
                                  child: const Text(
                                    '모두 동의',
                                    style: TextStyles.loginButtonStyle,
                                  ),
                                ),
                                CustomButton(
                                  onPressed: () {},
                                  width: Scaler.width(0.85 * 0.6, context) - 5,
                                  height: 45,
                                  child: const Text(
                                    '적용하기',
                                    style: TextStyles.loginButtonStyle,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const SizedBox(
                            height: 18,
                          ),
                          SizedBox(
                            width: Scaler.width(0.85, context),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/information_grey_icon.svg',
                                  width: 14,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text(
                                  '리마인드 알림은 일주일에 최대 두 번 발송됩니다',
                                  style: TextStyles
                                      .notificationTimeSettingInformationStyle,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                        ],
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
