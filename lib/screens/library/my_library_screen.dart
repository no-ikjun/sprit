import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/util/functions.dart';
import 'package:sprit/popups/library/section_order.dart';
import 'package:sprit/providers/library_section_order.dart';
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
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<LibrarySectionOrderState>(context, listen: false)
          .loadOrderFromPrefs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
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
                              onTap: () {
                                showModal(context, const LibrarySectionOrder(),
                                    false);
                              },
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
                  Column(
                    children: context
                        .watch<LibrarySectionOrderState>()
                        .getSectionOrder
                        .map((section) {
                          switch (section) {
                            case LibrarySection.bookMark:
                              return const BookMarkComponent();
                            case LibrarySection.bookInfo:
                              return const MyBookInfoComponent();
                            case LibrarySection.phrase:
                              return const MyPhraseComponent();
                            case LibrarySection.report:
                              return const MyBookReportComponent();
                            default:
                              return Container();
                          }
                        })
                        .expand(
                            (widget) => [widget, const SizedBox(height: 35)])
                        .toList(),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: CupertinoActivityIndicator(
                      radius: 18,
                      animating: true,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
