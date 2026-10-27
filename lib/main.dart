import 'package:flutter/material.dart';
import 'controllers/quiz_controller.dart';
import 'data/questions.dart';
import 'data/bonus_questions.dart';
import 'screens/welcome_screen.dart';
import 'utils/app_theme.dart';

void main() => runApp(const QuizoraApp());

class QuizoraApp extends StatefulWidget {
  const QuizoraApp({super.key});
  @override
  State<QuizoraApp> createState() => _QuizoraAppState();
}

class _QuizoraAppState extends State<QuizoraApp> with WidgetsBindingObserver {
  final QuizController _quiz = QuizController(
    questions: questions,
    bonusQuestions: bonusQuestions,
  );
  final ValueNotifier<ThemeMode> _theme = ValueNotifier(ThemeMode.system);
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _quiz.setLifecyclePaused(state != AppLifecycleState.resumed);
  }

  void _toggleTheme() {
    final dark =
        _theme.value == ThemeMode.dark ||
        (_theme.value == ThemeMode.system &&
            WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                Brightness.dark);
    _theme.value = dark ? ThemeMode.light : ThemeMode.dark;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _quiz.dispose();
    _theme.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<ThemeMode>(
    valueListenable: _theme,
    builder: (context, mode, _) => MaterialApp(
      title: 'Quizora Quest',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(Brightness.light),
      darkTheme: AppTheme.build(Brightness.dark),
      themeMode: mode,
      home: WelcomeScreen(quiz: _quiz, onToggleTheme: _toggleTheme),
    ),
  );
}
