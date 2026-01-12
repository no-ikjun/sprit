import 'package:flutter/material.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/book_report.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/widgets/custom_button.dart';

class BookReportEdit extends StatefulWidget {
  final String report;
  final String reportUuid;
  final Function callback;
  const BookReportEdit({
    super.key,
    required this.report,
    required this.reportUuid,
    required this.callback,
  });

  @override
  State<BookReportEdit> createState() => _BookReportEditState();
}

class _BookReportEditState extends State<BookReportEdit> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.report);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        child: SafeArea(
          maintainBottomViewPadding: true,
          child: Column(
            children: [
              const SizedBox(
                height: 22,
              ),
              const Text(
                '독후감 수정',
                style: TextStyles.notificationConfirmModalTitleStyle,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: 18,
              ),
              SizedBox(
                width: Scaler.width(0.8, context),
                child: TextField(
                  controller: _controller,
                  onChanged: (value) {
                    setState(() {
                      _controller.text = value;
                    });
                  },
                  autofocus: true,
                  keyboardType: TextInputType.multiline,
                  maxLines: 12,
                  style: TextStyles.myLibraryBookReportStyle.copyWith(
                    height: 1.6,
                    color: ColorSet.text,
                    fontSize: 15,
                  ),
                  decoration: const InputDecoration(
                    hintText: "독후감 작성",
                    hintStyle: TextStyles.timerBottomSheetHintTextStyle,
                    contentPadding: EdgeInsets.all(15),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: ColorSet.lightGrey,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: ColorSet.lightGrey,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: Scaler.width(0.8, context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      width: Scaler.width(0.8, context) * 0.5 - 5,
                      height: 50,
                      color: ColorSet.lightGrey,
                      borderColor: ColorSet.lightGrey,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        '취소',
                        style: TextStyles.buttonLabelStyle,
                      ),
                    ),
                    CustomButton(
                      width: Scaler.width(0.8, context) * 0.5 - 5,
                      height: 50,
                      onPressed: () async {
                        if (_controller.text.isEmpty) {
                          return;
                        }
                        await BookReportService.updateBookReport(
                          widget.reportUuid,
                          _controller.text,
                        );
                        widget.callback();
                        Navigator.pop(context);
                      },
                      child: const Text(
                        '수정하기',
                        style: TextStyles.buttonLabelStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
