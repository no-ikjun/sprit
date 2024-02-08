import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/book_library.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/widgets/custom_button.dart';

class BookStateChange extends StatefulWidget {
  final String bookTitle;
  final String bookUuid;
  final Function callback;
  const BookStateChange({
    super.key,
    required this.bookTitle,
    required this.bookUuid,
    required this.callback,
  });

  @override
  State<BookStateChange> createState() => _BookStateChangeState();
}

class _BookStateChangeState extends State<BookStateChange> {
  String selectedState = "READING";
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 22,
        ),
        Text(
          widget.bookTitle,
          style: TextStyles.notificationConfirmModalTitleStyle,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(
          height: 14,
        ),
        const Text(
          '책의 독서 상태를 변경할 수 있어요',
          style: TextStyles.notificationConfirmModalDescriptionStyle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: Scaler.width(0.6, context),
          child: DropdownButtonFormField2(
            isExpanded: true,
            decoration: const InputDecoration(
              contentPadding: EdgeInsetsDirectional.symmetric(
                vertical: 5,
                horizontal: 5,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                borderSide: BorderSide(
                  color: ColorSet.border,
                  width: 1.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                borderSide: BorderSide(
                  color: ColorSet.border,
                  width: 1.0,
                ),
              ),
            ),
            hint: Text(
              '독서 상태를 선택하세요',
              style: TextStyles.textFieldStyle.copyWith(
                color: ColorSet.grey,
                fontSize: 16,
              ),
            ),
            items: [
              DropdownMenuItem(
                value: "BEFORE",
                child: Text(
                  '앞으로 읽을 책',
                  style: TextStyles.textFieldStyle.copyWith(
                    color: ColorSet.darkGrey,
                    fontSize: 16,
                  ),
                ),
              ),
              DropdownMenuItem(
                value: "READING",
                child: Text(
                  '읽는 중인 책',
                  style: TextStyles.textFieldStyle.copyWith(
                    color: ColorSet.darkGrey,
                    fontSize: 16,
                  ),
                ),
              ),
              DropdownMenuItem(
                value: "AFTER",
                child: Text(
                  '모두 읽은 책',
                  style: TextStyles.textFieldStyle.copyWith(
                    color: ColorSet.darkGrey,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
            validator: (value) {
              if (value == null) {
                return '상태를 선택해주세요';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                selectedState = value.toString();
              });
            },
            buttonStyleData: ButtonStyleData(
              padding: const EdgeInsets.only(right: 8),
              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.transparent;
                  }
                  return Colors.transparent;
                },
              ),
            ),
            iconStyleData: const IconStyleData(
              icon: Icon(
                Icons.arrow_drop_down,
                color: ColorSet.grey,
              ),
              iconSize: 24,
            ),
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            menuItemStyleData: MenuItemStyleData(
              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.transparent;
                  }
                  return Colors.transparent;
                },
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        CustomButton(
          onPressed: () async {
            await BookLibraryService.updateBookLibrary(
              context,
              widget.bookUuid,
              selectedState,
            );
            widget.callback();
            Navigator.pop(context);
          },
          width: Scaler.width(0.85, context),
          height: 45,
          child: const Text(
            '확인',
            style: TextStyles.loginButtonStyle,
          ),
        )
      ],
    );
  }
}
