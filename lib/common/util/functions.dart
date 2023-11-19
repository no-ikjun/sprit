import 'package:flutter/material.dart';
import 'package:sprit/widgets/modal.dart';

showModal(BuildContext context, Widget content, bool closeButton) async {
  await showDialog<String>(
    context: context,
    builder: (context) => Modal(
      content: content,
      closeButton: closeButton,
    ),
  );
}
