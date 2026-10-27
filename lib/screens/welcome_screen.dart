import 'package:flutter/material.dart';
import '../controllers/quiz_controller.dart';
import '../models/question.dart';
import '../widgets/app_header.dart';
import '../widgets/custom_primary_button.dart';
import '../widgets/quiz_artwork.dart';
import '../widgets/responsive_page.dart';
import 'quiz_screen.dart';
import 'mission_screen.dart';

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
  String _avatar = 'explorer';
  GameMode _mode = GameMode.relaxed;
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
      widget.quiz.setPlayer(_name.text, avatar: _avatar, mode: _mode);
    }
    FocusManager.instance.primaryFocus?.unfocus();
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => resume
            ? QuizScreen(quiz: widget.quiz, onToggleTheme: widget.onToggleTheme)
            : MissionScreen(
                quiz: widget.quiz,
                onToggleTheme: widget.onToggleTheme,
              ),
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
      footer: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomPrimaryButton(
            label: 'Pilih Misi',
            onPressed: () => _openQuiz(),
          ),
          if (widget.quiz.hasSession)
            TextButton(
              onPressed: () => _openQuiz(resume: true),
              child: const Text('Lanjutkan misi sebelumnya'),
            ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 720;
          // Landscape ponsel punya tinggi kecil: perkecil ilustrasi agar tidak
          // terpotong dan tetap proporsional terhadap form.
          final shortViewport = MediaQuery.sizeOf(context).height < 540;
          final artHeight = wide ? (shortViewport ? 180.0 : 340.0) : 210.0;
          final art = Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QuizArtwork(trophy: false, height: artHeight),
              const SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                runSpacing: 8,
                children: [
                  _Feature(
                    icon: Icons.layers_outlined,
                    label: '${widget.quiz.bank.length} soal · 4 misi',
                  ),
                  const _Feature(
                    icon: Icons.fact_check_outlined,
                    label: 'Pilihan ganda A–D',
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
                  'Setiap petunjuk,\nsebuah petualangan.',
                  style: theme.textTheme.headlineLarge,
                ),
                const SizedBox(height: 14),
                Text(
                  'Baca cerita kampus, telusuri petunjuk, lalu pilih satu jawaban yang paling tepat.',
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
                      return 'Isi nama dulu, lalu pilih misi.';
                    }
                    if (value.trim().runes.length > 30) {
                      return 'Gunakan nama maksimal 30 karakter.';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => _openQuiz(),
                ),
                const SizedBox(height: 20),
                Text('Pilih avatarmu', style: theme.textTheme.titleMedium),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final avatar in const [
                      ('explorer', 'Penjelajah', Icons.explore_outlined),
                      ('detective', 'Detektif', Icons.search_rounded),
                      ('inventor', 'Perakit', Icons.lightbulb_outline_rounded),
                    ])
                      ChoiceChip(
                        avatar: Icon(avatar.$3, size: 20),
                        label: Text(avatar.$2),
                        selected: _avatar == avatar.$1,
                        onSelected: (_) => setState(() => _avatar = avatar.$1),
                        padding: const EdgeInsets.all(8),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Text('Cara bermain', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('Santai'),
                      selected: _mode == GameMode.relaxed,
                      onSelected: (_) =>
                          setState(() => _mode = GameMode.relaxed),
                      padding: const EdgeInsets.all(8),
                    ),
                    ChoiceChip(
                      label: const Text('Tantangan'),
                      selected: _mode == GameMode.challenge,
                      onSelected: (_) =>
                          setState(() => _mode = GameMode.challenge),
                      padding: const EdgeInsets.all(8),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _mode == GameMode.relaxed
                      ? 'Tanpa timer. Ambil waktu untuk memahami petunjuk.'
                      : '90 detik per soal. Timer dijeda saat aplikasi ditinggalkan.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 18),
                Center(
                  child: Text(
                    'Cerita fiksi, petunjuk nyata di layar. Siap menyelidiki?',
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: Center(child: art)),
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
