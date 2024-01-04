import 'package:flutter/material.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/widgets/custom_app_bar.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

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
              label: '도서 검색',
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Scaler.width(0.075, context),
              ),
              child: TextField(
                textInputAction: TextInputAction.search,
                onSubmitted: (value) => debugPrint(value),
                autofocus: true,
                decoration: InputDecoration(
                  hintText: '검색어를 입력하세요',
                  hintStyle: TextStyles.textFieldStyle.copyWith(
                    color: ColorSet.grey,
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: ColorSet.grey, width: 1.0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: ColorSet.border, width: 1.0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: ColorSet.grey,
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
