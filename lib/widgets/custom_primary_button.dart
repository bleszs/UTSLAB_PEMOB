import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class CustomPrimaryButton extends StatelessWidget {
  const CustomPrimaryButton({super.key, required this.label, required this.onPressed, this.icon = Icons.arrow_forward_rounded});
  final String label;
  final VoidCallback? onPressed;
  final IconData icon;
  @override
  Widget build(BuildContext context) => SizedBox(width: double.infinity, child: FilledButton(
    onPressed: onPressed,
    style: FilledButton.styleFrom(
      backgroundColor: AppColors.yellow, foregroundColor: AppColors.ink,
      disabledBackgroundColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: .10),
      disabledForegroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
      minimumSize: const Size(0, 58), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      elevation: onPressed == null ? 0 : 3, shadowColor: AppColors.yellow.withValues(alpha: .25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    ),
    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Flexible(child: Text(label, textAlign: TextAlign.center)), const SizedBox(width: 12), Icon(icon, size: 20),
    ]),
  ));
}
