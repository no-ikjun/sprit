import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/widgets/custom_app_bar.dart';

class BookDetailScreen extends StatefulWidget {
  final String bookUuid;

  const BookDetailScreen({Key? key, required this.bookUuid}) : super(key: key);

  @override
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorSet.background,
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: Column(
          children: [
            CustomAppBar(
              label: '상세 정보',
            )
          ],
        ),
      ),
    );
  }
}
