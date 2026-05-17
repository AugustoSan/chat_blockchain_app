import 'package:chat_blockchain_app/theme.dart';
import 'package:flutter/material.dart';

class ElevatedButtonCustom extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final IconData? icon;
  const ElevatedButtonCustom({required this.child, this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: AppColors.onPrimary,
        backgroundColor: AppColors.primaryContainer,
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.md)),
        textStyle: AppTypography.labelCaps.copyWith(fontWeight: FontWeight.w700),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}