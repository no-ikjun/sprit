import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/screens/library/ordered_component/book_mark.dart';
import 'package:sprit/screens/library/ordered_component/book_report.dart';
import 'package:sprit/screens/library/ordered_component/my_book_info.dart';
import 'package:sprit/screens/library/ordered_component/phrase_info.dart';

class MyLibraryScreen extends StatefulWidget {
  const MyLibraryScreen({super.key});

  @override
  State<MyLibraryScreen> createState() => _MyLibraryScreenState();
}

class _MyLibraryScreenState extends State<MyLibraryScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: true,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: Scaler.width(0.85, context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '내 서재',
                        style: TextStyles.myLibraryTitleStyle,
                      ),
                      InkWell(
                        onTap: () {},
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: SvgPicture.asset(
                          'assets/images/setting_gear.svg',
                          width: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const BookMarkComponent(),
            const SizedBox(
              height: 35,
            ),
            const MyBookInfoComponent(),
            const SizedBox(
              height: 35,
            ),
            const MyPhraseComponent(),
            const SizedBox(
              height: 35,
            ),
            const MyBookReportComponent(),
            const SizedBox(
              height: 35,
            ),
          ],
        ),
      ),
    );
  }
}
