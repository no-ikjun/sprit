import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sprit/providers/counts.dart';

class Counter extends StatelessWidget {
  const Counter({super.key});

  @override
  Widget build(BuildContext context) {
    print('Counter');

    return Text(
      context.watch<Counts>().count.toString(),
      style: const TextStyle(
        fontSize: 20,
      ),
    );
  }
}
