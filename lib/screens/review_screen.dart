import 'package:flutter/material.dart';
import '../controllers/quiz_controller.dart';
import '../widgets/app_header.dart';
import '../widgets/responsive_page.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({
    super.key,
    required this.quiz,
    required this.onToggleTheme,
  });
  final QuizController quiz;
  final VoidCallback onToggleTheme;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ResponsivePage(
      header: AppHeader(
        dark: theme.brightness == Brightness.dark,
        onToggleTheme: onToggleTheme,
        onBack: () => Navigator.of(context).pop(),
        title: 'Pembahasan',
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Telusuri kembali buktinya.',
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          for (final q in quiz.questions) ...[
            Row(
              children: [
                Icon(
                  quiz.attemptFor(q.id)!.correct
                      ? Icons.check_circle_outline_rounded
                      : Icons.search_rounded,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(q.title, style: theme.textTheme.titleLarge),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${quiz.attemptFor(q.id)!.correct ? 'Benar' : (quiz.attemptFor(q.id)!.timedOut ? 'Waktu habis' : 'Belum tepat')} · ${quiz.attemptFor(q.id)!.points} poin',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Text('Jawabanmu:\n${q.describe(quiz.attemptFor(q.id)!.answer)}'),
            const SizedBox(height: 12),
            Text('Penyelesaian:\n${q.describe(q.answerKey)}'),
            const SizedBox(height: 12),
            Text(q.explanation, style: theme.textTheme.bodyLarge),
            const Divider(height: 40),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
