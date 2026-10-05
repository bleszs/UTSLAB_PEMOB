import 'package:flutter/material.dart';
import '../controllers/quiz_controller.dart';
import '../widgets/app_header.dart';
import '../widgets/custom_primary_button.dart';
import '../widgets/option_card.dart';
import '../widgets/responsive_page.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({
    super.key,
    required this.quiz,
    required this.onToggleTheme,
  });
  final QuizController quiz;
  final VoidCallback onToggleTheme;
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  void _back() {
    if (widget.quiz.index > 0) {
      widget.quiz.previous();
    } else {
      Navigator.of(context).pop();
    }
  }

  void _next() {
    if (!widget.quiz.next()) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => ResultScreen(
          quiz: widget.quiz,
          onToggleTheme: widget.onToggleTheme,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.quiz,
    builder: (context, _) {
      final quiz = widget.quiz;
      final theme = Theme.of(context);
      final scheme = theme.colorScheme;
      return PopScope(
        canPop: quiz.index == 0,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) quiz.previous();
        },
        child: ResponsivePage(
          header: AppHeader(
            dark: theme.brightness == Brightness.dark,
            onToggleTheme: widget.onToggleTheme,
            onBack: _back,
            title: 'Pengetahuan umum',
          ),
          footer: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: CustomPrimaryButton(
              label: quiz.isLast ? 'Lihat Hasil' : 'Selanjutnya',
              icon: quiz.isLast
                  ? Icons.emoji_events_outlined
                  : Icons.arrow_forward_rounded,
              onPressed: quiz.selected == null ? null : _next,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Soal ${quiz.index + 1} dari ${quiz.total}',
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  Text(
                    '${quiz.answered} terjawab',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Semantics(
                label: 'Progress jawaban',
                value: '${quiz.answered} dari ${quiz.total}',
                child: LinearProgressIndicator(value: quiz.progress),
              ),
              const SizedBox(height: 32),
              LayoutBuilder(
                builder: (context, constraints) {
                  final question = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Chip(
                        label: Text(quiz.current.category),
                        avatar: Icon(
                          Icons.auto_awesome_outlined,
                          size: 16,
                          color: scheme.primary,
                        ),
                        side: BorderSide.none,
                        backgroundColor: scheme.primary.withValues(alpha: .09),
                        labelStyle: TextStyle(
                          color: scheme.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        quiz.current.text,
                        key: ValueKey(quiz.current.id),
                        style: theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Pilih satu jawaban yang paling tepat.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  );
                  final options = Column(
                    children: [
                      for (var i = 0; i < quiz.current.options.length; i++) ...[
                        OptionCard(
                          key: ValueKey('${quiz.current.id}-$i'),
                          index: i,
                          text: quiz.current.options[i],
                          selected: quiz.selected == i,
                          onTap: () => quiz.select(i),
                        ),
                        if (i < quiz.current.options.length - 1)
                          const SizedBox(height: 12),
                      ],
                    ],
                  );
                  return constraints.maxWidth >= 720
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: question),
                            const SizedBox(width: 48),
                            Expanded(child: options),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            question,
                            const SizedBox(height: 28),
                            options,
                          ],
                        );
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 16,
                    color: scheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Jawaban bisa diubah sebelum kuis selesai.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );
    },
  );
}
