import 'package:flutter/material.dart';
import '../controllers/quiz_controller.dart';
import '../widgets/app_header.dart';

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
    final scheme = theme.colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: AppHeader(
                      dark: theme.brightness == Brightness.dark,
                      onToggleTheme: onToggleTheme,
                      onBack: () => Navigator.of(context).pop(),
                      title: 'Pembahasan',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      'Pelajari jawabanmu, lalu coba lagi dengan lebih percaya diri.',
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.only(bottom: 24),
                      itemCount: quiz.total,
                      separatorBuilder: (_, _) => const Divider(height: 32),
                      itemBuilder: (context, index) {
                        final question = quiz.questions[index];
                        final answer = quiz.answers[index];
                        final correct = answer == question.correctIndex;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  correct
                                      ? Icons.check_circle_outline_rounded
                                      : Icons.cancel_outlined,
                                  color: correct
                                      ? scheme.primary
                                      : scheme.error,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Soal ${index + 1} · ${correct ? 'Benar' : 'Salah'}',
                                  style: theme.textTheme.titleMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              question.text,
                              style: theme.textTheme.titleLarge,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Jawabanmu: ${answer == null ? 'Belum dijawab' : question.options[answer]}',
                              style: theme.textTheme.bodyLarge,
                            ),
                            if (!correct)
                              Text(
                                'Jawaban benar: ${question.options[question.correctIndex]}',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: scheme.primary,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            const SizedBox(height: 10),
                            Text(
                              question.explanation,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        );
                      },
                    ),
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
