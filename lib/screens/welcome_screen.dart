import 'package:flutter/material.dart';
import '../controllers/quiz_controller.dart';
import '../widgets/app_header.dart';
import '../widgets/custom_primary_button.dart';
import '../widgets/quiz_artwork.dart';
import '../widgets/responsive_page.dart';
import 'quiz_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({
    super.key,
    required this.quiz,
    required this.onToggleTheme,
  });
  final QuizController quiz;
  final VoidCallback onToggleTheme;
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  bool _submitted = false;
  @override
  void initState() {
    super.initState();
    widget.quiz.addListener(_sessionChanged);
  }

  void _sessionChanged() {
    if (widget.quiz.name.isEmpty) {
      _submitted = false;
      _form.currentState?.reset();
      _name.clear();
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.quiz.removeListener(_sessionChanged);
    _name.dispose();
    super.dispose();
  }

  Future<void> _openQuiz({bool resume = false}) async {
    if (!resume) {
      _submitted = true;
      if (!_form.currentState!.validate()) return;
      widget.quiz.start(_name.text);
    }
    FocusManager.instance.primaryFocus?.unfocus();
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            QuizScreen(quiz: widget.quiz, onToggleTheme: widget.onToggleTheme),
      ),
    );
    if (!mounted) return;
    if (widget.quiz.name.isEmpty) {
      _submitted = false;
      _form.currentState?.reset();
      _name.clear();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return ResponsivePage(
      header: AppHeader(
        dark: theme.brightness == Brightness.dark,
        onToggleTheme: widget.onToggleTheme,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 720;
          final art = Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QuizArtwork(trophy: false, height: wide ? 340 : 210),
              const SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                runSpacing: 8,
                children: [
                  _Feature(
                    icon: Icons.layers_outlined,
                    label: '${widget.quiz.total} soal',
                  ),
                  const _Feature(
                    icon: Icons.timer_outlined,
                    label: 'Tanpa batas waktu',
                  ),
                ],
              ),
            ],
          );
          final intro = Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Rasa ingin tahu,\nbertemu tantangan.',
                  style: theme.textTheme.headlineLarge,
                ),
                const SizedBox(height: 14),
                Text(
                  'Uji pengetahuanmu, temukan hal baru, dan rayakan setiap jawaban benar.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 30),
                Text('Siapa nama kamu?', style: theme.textTheme.titleMedium),
                const SizedBox(height: 10),
                TextFormField(
                  key: const Key('name_input'),
                  controller: _name,
                  maxLength: 30,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.done,
                  onChanged: (_) {
                    if (_submitted) _form.currentState?.validate();
                  },
                  decoration: const InputDecoration(
                    hintText: 'Tulis nama panggilanmu',
                    prefixIcon: Icon(Icons.person_outline_rounded),
                    counterText: '',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Isi nama dulu, lalu mulai kuis.';
                    }
                    if (value.trim().runes.length > 30) {
                      return 'Gunakan nama maksimal 30 karakter.';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => _openQuiz(),
                ),
                const SizedBox(height: 20),
                CustomPrimaryButton(
                  label: 'Mulai Kuis',
                  onPressed: () => _openQuiz(),
                ),
                if (widget.quiz.hasSession) ...[
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton(
                      onPressed: () => _openQuiz(resume: true),
                      child: const Text('Lanjutkan kuis sebelumnya'),
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                Center(
                  child: Text(
                    'Satu pilihan per soal. Siap mencoba?',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          );
          return Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 28),
            child: wide
                ? Row(
                    children: [
                      Expanded(child: art),
                      const SizedBox(width: 56),
                      Expanded(child: intro),
                    ],
                  )
                : Column(children: [art, const SizedBox(height: 30), intro]),
          );
        },
      ),
    );
  }
}

class _Feature extends StatelessWidget {
  const _Feature({required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
      const SizedBox(width: 6),
      Text(label, style: Theme.of(context).textTheme.bodyMedium),
    ],
  );
}
