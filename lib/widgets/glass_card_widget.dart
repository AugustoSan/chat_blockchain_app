import 'package:chat_blockchain_app/theme.dart';
import 'package:flutter/material.dart';

class GlassCardWidget extends StatelessWidget {
  final Widget child;
  const GlassCardWidget({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: context.customTokens.glassCard,
      child: child,
    );
  }
}