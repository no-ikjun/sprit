import 'package:flutter/material.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/common/ui/color_set.dart';

class Modal extends StatelessWidget {
  final Widget content;
  final bool closeButton;
  final double verticalPadding;
  final double horizontalPadding;
  const Modal({
    super.key,
    required this.content,
    this.closeButton = false,
    this.verticalPadding = 12,
    this.horizontalPadding = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ColorSet.white,
      insetPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Wrap(
        children: [
          SizedBox(
            width: Scaler.width(0.85, context),
            child: AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              insetPadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.symmetric(
                vertical: verticalPadding,
                horizontal: horizontalPadding,
              ),
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              content: Column(
                children: [
                  closeButton
                      ? SizedBox(
                          height: 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                splashRadius: 22,
                                iconSize: 23,
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                    const EdgeInsets.all(0),
                                  ),
                                  splashFactory: NoSplash.splashFactory,
                                ),
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(
                                  Icons.close,
                                  color: ColorSet.lightGrey,
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(
                          height: 0,
                        ),
                  content,
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
