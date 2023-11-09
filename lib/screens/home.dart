import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sprit/providers/counts.dart';
import 'package:sprit/widgets/button.dart';
import 'package:sprit/widgets/counter.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider'),
      ),
      body: ChangeNotifierProvider(
        create: (BuildContext context) => Counts(),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Counter(),
              Buttons(),
            ],
          ),
        ),
      ),
    );
  }
}
