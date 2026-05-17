import 'package:chat_blockchain_app/theme.dart';
import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final Widget child;
  const CardWidget({required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.onSecondary,
      child: child,
    );
  }
}