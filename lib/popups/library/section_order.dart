import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/providers/library_section_order.dart';
import 'package:sprit/widgets/custom_button.dart';

class LibrarySectionOrder extends StatefulWidget {
  const LibrarySectionOrder({super.key});

  @override
  State<LibrarySectionOrder> createState() => _LibrarySectionOrderState();
}

class _LibrarySectionOrderState extends State<LibrarySectionOrder> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 22,
        ),
        const Text(
          '내 서재 페이지 순서 설정',
          style: TextStyles.notificationConfirmModalTitleStyle,
        ),
        const SizedBox(
          height: 14,
        ),
        const Text(
          '원하시는 순서대로 요소를 끌어다 놓으세요',
          style: TextStyles.notificationConfirmModalDescriptionStyle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: Scaler.width(0.85, context),
          height: 200,
          child: ReorderableListView(
            shrinkWrap: true,
            buildDefaultDragHandles: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollController: (ScrollController(
              initialScrollOffset: 0,
              keepScrollOffset: true,
            )),
            clipBehavior: Clip.none,
            children: <Widget>[
              for (final section
                  in context.read<LibrarySectionOrderState>().getSectionOrder)
                ListTile(
                  dense: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  selectedTileColor: Colors.transparent,
                  selectedColor: ColorSet.background,
                  enableFeedback: true,
                  tileColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  selected: false,
                  key: Key('$section'),
                  title: Text(
                    getName(section),
                    style: TextStyles.myLibrarySectionOrderMenuStyle,
                  ),
                  trailing: const Icon(
                    Icons.menu,
                    color: ColorSet.grey,
                    size: 28,
                  ),
                ),
            ],
            onReorderStart: (index) {
              HapticFeedback.lightImpact();
            },
            onReorderEnd: (index) {
              HapticFeedback.lightImpact();
            },
            onReorder: (int oldIndex, int newIndex) async {
              final List<LibrarySection> sectionOrder =
                  context.read<LibrarySectionOrderState>().getSectionOrder;
              final prefs = await SharedPreferences.getInstance();
              setState(() async {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final LibrarySection item = sectionOrder.removeAt(oldIndex);
                sectionOrder.insert(newIndex, item);
                context.read<LibrarySectionOrderState>().updateSectionOrder(
                      sectionOrder,
                    );
                final orderString = json.encode(
                    sectionOrder.map((item) => item.toString()).toList());
                await prefs.setString('sectionOrder', orderString);
              });
            },
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        CustomButton(
          onPressed: () {
            Navigator.pop(context);
          },
          width: Scaler.width(0.85, context),
          height: 45,
          child: const Text(
            '적용하기',
            style: TextStyles.loginButtonStyle,
          ),
        ),
      ],
    );
  }
}
