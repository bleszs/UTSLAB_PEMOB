import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    required this.dark,
    required this.onToggleTheme,
    this.onBack,
    this.title,
  });
  final bool dark;
  final VoidCallback onToggleTheme;
  final VoidCallback? onBack;
  final String? title;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      if (onBack != null) ...[
        IconButton(
          onPressed: onBack,
          tooltip: 'Kembali',
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        const SizedBox(width: 4),
      ] else ...[
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(
            Icons.bolt_rounded,
            color: Theme.of(context).colorScheme.onPrimary,
            size: 28,
          ),
        ),
        const SizedBox(width: 10),
      ],
      Expanded(
        child: Text(
          title ?? 'Quizora Quest',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      IconButton(
        onPressed: onToggleTheme,
        tooltip: dark ? 'Aktifkan mode terang' : 'Aktifkan mode gelap',
        icon: Icon(dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
      ),
    ],
  );
}
