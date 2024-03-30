import 'package:flutter/material.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/widgets/custom_app_bar.dart';

class LibraryPhraseScreen extends StatelessWidget {
  const LibraryPhraseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorSet.background,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              label: '저장된 문구 (스크랩)',
            ),
          ],
        ),
      ),
    );
  }
}
