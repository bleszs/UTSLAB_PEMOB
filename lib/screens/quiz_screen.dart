import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../controllers/quiz_controller.dart';
import '../models/question.dart';
import '../widgets/app_header.dart';
import '../widgets/custom_primary_button.dart';
import '../widgets/puzzle_interactor.dart';
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
  String? _heardAttempt;
  @override
  void initState() {
    super.initState();
    widget.quiz.setNavigationPaused(false);
    widget.quiz.addListener(_feedback);
  }

  void _feedback() {
    final attempt = widget.quiz.attempt;
    final key = '${widget.quiz.sessionNumber}-${widget.quiz.current.id}';
    if (attempt == null || key == _heardAttempt) return;
    _heardAttempt = key;
    if (attempt.correct) {
      HapticFeedback.lightImpact();
    } else {
      HapticFeedback.mediumImpact();
    }
    if (widget.quiz.soundEnabled) SystemSound.play(SystemSoundType.click);
  }

  @override
  void dispose() {
    widget.quiz.removeListener(_feedback);
    widget.quiz.setNavigationPaused(true);
    super.dispose();
  }

  void _advance() {
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
      return ResponsivePage(
        header: AppHeader(
          dark: theme.brightness == Brightness.dark,
          onToggleTheme: widget.onToggleTheme,
          onBack: () => Navigator.of(context).pop(),
          title: 'Quizora Quest',
        ),
        footer: CustomPrimaryButton(
          label: quiz.submitted
              ? (quiz.isLast ? 'Lihat Hasil' : 'Puzzle Berikutnya')
              : 'Kirim Jawaban',
          icon: quiz.submitted
              ? Icons.arrow_forward_rounded
              : Icons.check_rounded,
          onPressed: quiz.submitted
              ? _advance
              : (quiz.canSubmit ? () => quiz.submit() : null),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 20,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  'Puzzle ${quiz.index + 1} / ${quiz.total}',
                  style: theme.textTheme.titleMedium,
                ),
                Text('${quiz.points} poin', style: theme.textTheme.titleMedium),
                Text('Combo ${quiz.streak}', style: theme.textTheme.bodyMedium),
                if (quiz.mode == GameMode.challenge)
                  Semantics(
                    liveRegion: quiz.remainingSeconds <= 10,
                    label: 'Sisa waktu ${quiz.remainingSeconds} detik',
                    child: Text(
                      '${quiz.remainingSeconds} detik',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: quiz.remainingSeconds <= 10
                            ? theme.colorScheme.error
                            : theme.colorScheme.primary,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            LinearProgressIndicator(
              value: quiz.progress,
              semanticsLabel: 'Progress misi',
              semanticsValue: '${quiz.answered} dari ${quiz.total}',
            ),
            const SizedBox(height: 28),
            LayoutBuilder(
              builder: (context, constraints) {
                final story = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quiz.current.title,
                      style: theme.textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      quiz.current.context,
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      quiz.current.instruction,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${quiz.sessionTitle} · ${quiz.current.typeLabel}',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        TextButton.icon(
                          onPressed: quiz.submitted || quiz.usedHint
                              ? null
                              : quiz.useHint,
                          icon: const Icon(Icons.lightbulb_outline_rounded),
                          label: Text(
                            quiz.usedHint
                                ? 'Petunjuk digunakan'
                                : 'Buka Petunjuk',
                          ),
                        ),
                        IconButton(
                          tooltip: quiz.soundEnabled
                              ? 'Matikan suara'
                              : 'Aktifkan suara',
                          onPressed: quiz.toggleSound,
                          icon: Icon(
                            quiz.soundEnabled
                                ? Icons.volume_up_outlined
                                : Icons.volume_off_outlined,
                          ),
                        ),
                      ],
                    ),
                    if (quiz.usedHint) ...[
                      Text(quiz.current.hint, style: theme.textTheme.bodyLarge),
                      const SizedBox(height: 8),
                      Text(
                        'Jawaban benar dengan bantuan: 70 poin. Combo dimulai kembali.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ],
                );
                final work = AnimatedSwitcher(
                  duration: MediaQuery.disableAnimationsOf(context)
                      ? Duration.zero
                      : const Duration(milliseconds: 240),
                  child: quiz.submitted
                      ? PuzzleFeedback(
                          key: ValueKey('feedback-${quiz.current.id}'),
                          quiz: quiz,
                        )
                      : PuzzleInteractor(
                          key: ValueKey('work-${quiz.current.id}'),
                          quiz: quiz,
                        ),
                );
                return constraints.maxWidth >= 720
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: story),
                          const SizedBox(width: 40),
                          Expanded(child: work),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [story, const SizedBox(height: 24), work],
                      );
              },
            ),
            const SizedBox(height: 24),
            Text(
              quiz.submitted
                  ? 'Jawaban terkirim dan terkunci. Baca alasannya sebelum lanjut.'
                  : 'Jawaban dapat diubah sampai kamu menekan Kirim Jawaban.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
          ],
        ),
      );
    },
  );
}

class PuzzleFeedback extends StatelessWidget {
  const PuzzleFeedback({super.key, required this.quiz});
  final QuizController quiz;
  @override
  Widget build(BuildContext context) {
    final attempt = quiz.attempt!;
    final theme = Theme.of(context);
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: attempt.correct
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: DefaultTextStyle.merge(
          style: TextStyle(
            color: attempt.correct
                ? theme.colorScheme.onPrimaryContainer
                : theme.colorScheme.onErrorContainer,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                attempt.correct
                    ? Icons.check_circle_outline_rounded
                    : (attempt.timedOut
                          ? Icons.timer_off_outlined
                          : Icons.cancel_outlined),
                size: 40,
              ),
              const SizedBox(height: 12),
              Text(
                attempt.correct
                    ? 'Buktinya cocok!'
                    : (attempt.timedOut ? 'Waktu habis' : 'Belum tepat'),
                style: theme.textTheme.titleLarge?.copyWith(
                  color: attempt.correct
                      ? theme.colorScheme.onPrimaryContainer
                      : theme.colorScheme.onErrorContainer,
                ),
              ),
              const SizedBox(height: 8),
              Text('+${attempt.points} poin'),
              if (attempt.comboBonus > 0)
                Text('Bonus combo +${attempt.comboBonus}'),
              if (attempt.timeBonus > 0)
                Text('Bonus waktu +${attempt.timeBonus}'),
              const SizedBox(height: 20),
              const Text('Jawabanmu:'),
              Text(quiz.current.describe(attempt.answer)),
              if (!attempt.correct) ...[
                const SizedBox(height: 14),
                const Text('Penyelesaian yang benar:'),
                Text(quiz.current.describe(quiz.current.answerKey)),
              ],
              const SizedBox(height: 20),
              Text(quiz.current.explanation),
            ],
          ),
        ),
      ),
    );
  }
}
