import 'package:flutter/material.dart';

class FollowScreen extends StatelessWidget {
  final String type;
  const FollowScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Follower Screen'),
      ),
    );
  }
}
