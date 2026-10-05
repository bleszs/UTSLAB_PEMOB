import 'package:flutter/material.dart';

class OptionCard extends StatelessWidget {
  const OptionCard({
    super.key,
    required this.index,
    required this.text,
    required this.selected,
    required this.onTap,
  });
  final int index;
  final String text;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final foreground = selected ? scheme.onPrimary : scheme.onSurface;
    return Semantics(
      button: true,
      selected: selected,
      inMutuallyExclusiveGroup: true,
      label: 'Pilihan ${String.fromCharCode(65 + index)}: $text',
      child: Material(
        color: selected ? scheme.primary : scheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: selected ? scheme.primary : scheme.outlineVariant,
            width: selected ? 2 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: ExcludeSemantics(
              child: Row(
                children: [
                  Container(
                    height: 34,
                    width: 34,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected
                          ? foreground.withValues(alpha: .15)
                          : scheme.primary.withValues(alpha: .08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      String.fromCharCode(65 + index),
                      style: TextStyle(
                        color: selected ? foreground : scheme.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      text,
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: foreground),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    selected
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: selected ? foreground : scheme.onSurfaceVariant,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
