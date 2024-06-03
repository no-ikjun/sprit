import 'package:flutter/material.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/widgets/custom_app_bar.dart';
import 'package:sprit/widgets/custom_button.dart';

class InputQuestCodeScreen extends StatefulWidget {
  const InputQuestCodeScreen({super.key});

  @override
  State<InputQuestCodeScreen> createState() => _InputQuestCodeScreenState();
}

class _InputQuestCodeScreenState extends State<InputQuestCodeScreen> {
  String questCode = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorSet.background,
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const CustomAppBar(
                  label: "퀘스트 참여",
                ),
                const SizedBox(
                  height: 35,
                ),
                SizedBox(
                  width: Scaler.width(0.85, context),
                  child: const Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '퀘스트 코드를 입력하세요',
                            style: TextStyles.questGenerateTitleStyle,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '공유받은 코드를 입력하면 퀘스트에 참여할 수 있어요.',
                            style: TextStyles.questGenerateDescriptionStyle,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: Scaler.width(0.85, context),
                  child: TextField(
                    autofocus: true,
                    maxLength: 6,
                    style: TextStyles.questGenerateHintStyle.copyWith(
                      color: ColorSet.text,
                    ),
                    onChanged: (value) {
                      setState(() {
                        questCode = value;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: "000000",
                      hintStyle: TextStyles.questGenerateHintStyle,
                      border: InputBorder.none,
                      counterText: "",
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                CustomButton(
                  width: Scaler.width(0.85, context),
                  height: 50,
                  onPressed: () {},
                  child: const Text(
                    '참여하기',
                    style: TextStyles.buttonLabelStyle,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
