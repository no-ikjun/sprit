import 'package:flutter/material.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/book.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/widgets/custom_app_bar.dart';
import 'package:sprit/widgets/remove_glow.dart';

class AddRecordScreen extends StatefulWidget {
  const AddRecordScreen({super.key});

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
