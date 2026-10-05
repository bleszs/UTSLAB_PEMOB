import 'package:flutter/material.dart';
import '../controllers/quiz_controller.dart';
import '../utils/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/custom_primary_button.dart';
import '../widgets/quiz_artwork.dart';
import '../widgets/responsive_page.dart';
import 'review_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.quiz,
    required this.onToggleTheme,
  });
  final QuizController quiz;
  final VoidCallback onToggleTheme;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final perfect = quiz.correct == quiz.total;
    final praise = quiz.score >= 70 ? 'Hebat' : 'Terima kasih sudah mencoba';
    return ResponsivePage(
      header: AppHeader(
        dark: theme.brightness == Brightness.dark,
        onToggleTheme: onToggleTheme,
        title: 'Hasil kuis',
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$praise, ${quiz.name}!',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  perfect
                      ? 'Sempurna! Semua jawabanmu benar.'
                      : 'Setiap tantangan membawa pengetahuan baru.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                const QuizArtwork(trophy: true, height: 195),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: AppColors.purple,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      Semantics(
                        label: 'Skor akhir ${quiz.score} dari 100',
                        child: ExcludeSemantics(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.end,
                            children: [
                              Text(
                                '${quiz.score}',
                                style: theme.textTheme.displayLarge?.copyWith(
                                  color: AppColors.yellow,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 8,
                                  left: 6,
                                ),
                                child: Text(
                                  '/ 100',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${quiz.correct} dari ${quiz.total} jawaban benar',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 22),
                      const Divider(color: Color(0xFFAA7AFF)),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _Statistic(
                              value: '${quiz.total}',
                              label: 'Soal',
                              icon: Icons.layers_outlined,
                            ),
                          ),
                          Expanded(
                            child: _Statistic(
                              value: '${quiz.correct}',
                              label: 'Benar',
                              icon: Icons.check_circle_outline_rounded,
                            ),
                          ),
                          Expanded(
                            child: _Statistic(
                              value: '${quiz.total - quiz.correct}',
                              label: 'Salah',
                              icon: Icons.cancel_outlined,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                CustomPrimaryButton(
                  label: 'Main Lagi',
                  icon: Icons.replay_rounded,
                  onPressed: () {
                    quiz.reset();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => ReviewScreen(
                        quiz: quiz,
                        onToggleTheme: onToggleTheme,
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.fact_check_outlined),
                  label: const Text('Lihat Pembahasan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Statistic extends StatelessWidget {
  const _Statistic({
    required this.value,
    required this.label,
    required this.icon,
  });
  final String value;
  final String label;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Icon(icon, size: 21, color: AppColors.yellow),
      const SizedBox(height: 8),
      Text(
        value,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(color: Colors.white),
      ),
      Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: Colors.white),
      ),
    ],
  );
}
