import 'package:flutter/material.dart';
import '../controllers/quiz_controller.dart';
import '../data/questions.dart';
import '../widgets/app_header.dart';
import '../widgets/custom_primary_button.dart';
import '../widgets/responsive_page.dart';
import 'quiz_screen.dart';

class MissionScreen extends StatelessWidget {
  const MissionScreen({
    super.key,
    required this.quiz,
    required this.onToggleTheme,
  });
  final QuizController quiz;
  final VoidCallback onToggleTheme;

  void _start(
    BuildContext context, {
    String? id,
    String title = 'Maraton Pilihan Ganda',
    bool bonus = false,
  }) {
    if (bonus) {
      quiz.startBonus();
    } else {
      quiz.startMission(missionId: id, title: title);
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => QuizScreen(quiz: quiz, onToggleTheme: onToggleTheme),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ResponsivePage(
      header: AppHeader(
        dark: theme.brightness == Brightness.dark,
        onToggleTheme: onToggleTheme,
        onBack: () => Navigator.of(context).pop(),
        title: 'Pilih misi kuis',
      ),
      footer: CustomPrimaryButton(
        label: 'Maraton ${quiz.bank.length} Soal',
        icon: Icons.bolt_rounded,
        onPressed: () => _start(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Text(
            'Misi mana dulu, ${quiz.name}?',
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Text(
            'Setiap misi berisi empat soal pilihan ganda. Baca cerita dan pilih satu jawaban A, B, C, atau D.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 28),
          for (var i = 0; i < missions.length; i++) ...[
            Material(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => _start(
                  context,
                  id: missions[i].id,
                  title: missions[i].title,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Row(
                    children: [
                      Icon(
                        const [
                          Icons.slideshow_rounded,
                          Icons.event_note_rounded,
                          Icons.lock_outline_rounded,
                          Icons.fact_check_outlined,
                        ][i % 4],
                        color: theme.colorScheme.primary,
                        size: 32,
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              missions[i].title,
                              style: theme.textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              missions[i].description,
                              style: theme.textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${quiz.bank.where((q) => q.missionId == missions[i].id).length} soal · pilihan ganda A–D',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
          ],
          if (quiz.bonusBank.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text('Tantangan tambahan', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Opsional: ${quiz.bonusBank.length} puzzle interaktif dengan susun urutan, cocokkan bukti, dan rakit kode. Sesi dan skornya terpisah dari kuis pilihan ganda.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                key: const Key('bonus_zone'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                ),
                onPressed: () => _start(context, bonus: true),
                icon: const Icon(Icons.extension_outlined),
                label: const Text('Zona Puzzle Bonus'),
              ),
            ),
          ],
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
