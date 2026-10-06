import 'package:flutter/material.dart';
import '../controllers/quiz_controller.dart';
import '../widgets/app_header.dart';
import '../widgets/custom_primary_button.dart';
import '../widgets/quiz_artwork.dart';
import '../widgets/responsive_page.dart';
import '../utils/app_theme.dart';
import 'quiz_screen.dart';
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
    return ResponsivePage(
      header: AppHeader(
        dark: theme.brightness == Brightness.dark,
        onToggleTheme: onToggleTheme,
        title: 'Misi selesai',
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Icon(
                switch (quiz.avatar) {
                  'detective' => Icons.search_rounded,
                  'inventor' => Icons.lightbulb_outline_rounded,
                  _ => Icons.explore_outlined,
                },
                color: theme.colorScheme.primary,
                size: 32,
              ),
              const SizedBox(height: 10),
              Text(
                'Misi tuntas, ${quiz.name}!',
                style: theme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                quiz.sessionTitle,
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              if (quiz.practice)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Hasil latihan baru · terpisah dari sesi sebelumnya',
                  ),
                ),
              const QuizArtwork(trophy: true, height: 170),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.purple,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Text(
                      '${quiz.score}%',
                      style: theme.textTheme.displayLarge?.copyWith(
                        color: AppColors.yellow,
                      ),
                    ),
                    const Text(
                      'Akurasi percobaan pertama',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${quiz.correct} dari ${quiz.total} puzzle benar',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(color: Color(0xFFAA7AFF)),
                    const SizedBox(height: 20),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 28,
                      runSpacing: 16,
                      children: [
                        _Stat('${quiz.points}', 'Poin permainan'),
                        _Stat('${quiz.bestStreak}', 'Combo terbaik'),
                        _Stat('${quiz.hintCount}', 'Petunjuk'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                quiz.incorrect.isEmpty
                    ? 'Semua petunjuk terpecahkan. Siap mencoba misi lain?'
                    : '${quiz.incorrect.length} puzzle bisa kamu latih lagi${quiz.timedOutCount > 0 ? ' · ${quiz.timedOutCount} waktu habis' : ''}.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              if (quiz.incorrect.isNotEmpty) ...[
                CustomPrimaryButton(
                  label: 'Latih yang Belum Tepat',
                  icon: Icons.school_outlined,
                  onPressed: () {
                    if (!quiz.startPractice()) return;
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (_) => QuizScreen(
                          quiz: quiz,
                          onToggleTheme: onToggleTheme,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
              ],
              TextButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        ReviewScreen(quiz: quiz, onToggleTheme: onToggleTheme),
                  ),
                ),
                icon: const Icon(Icons.fact_check_outlined),
                label: const Text('Lihat Pembahasan'),
              ),
              const SizedBox(height: 12),
              CustomPrimaryButton(
                label: 'Main Lagi',
                icon: Icons.replay_rounded,
                onPressed: () {
                  quiz.reset();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.value, this.label);
  final String value;
  final String label;
  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        value,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(color: Colors.white),
      ),
      Text(label, style: const TextStyle(color: Colors.white)),
    ],
  );
}
