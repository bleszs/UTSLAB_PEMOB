// Run: flutter test tool/capture_test.dart --update-goldens
// These captures use Flutter's test renderer, not an Android emulator.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quizora/controllers/quiz_controller.dart';
import 'package:quizora/data/questions.dart';
import 'package:quizora/screens/quiz_screen.dart';
import 'package:quizora/screens/result_screen.dart';
import 'package:quizora/screens/review_screen.dart';
import 'package:quizora/screens/welcome_screen.dart';
import 'package:quizora/utils/app_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final loader = FontLoader('Nunito');
    for (final name in ['Regular', 'Bold', 'ExtraBold', 'Black']) {
      loader.addFont(rootBundle.load('assets/fonts/Nunito-$name.ttf'));
    }
    await loader.load();
    final icons = FontLoader('MaterialIcons')
      ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
    await icons.load();
  });
  testWidgets('capture actual screens and responsive theme variants', (
    tester,
  ) async {
    final quiz = QuizController(questions: questions);
    addTearDown(quiz.dispose);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.devicePixelRatio = 1;
    Future<void> capture(
      String name,
      Size size,
      Widget screen, {
      bool dark = false,
    }) async {
      tester.view.physicalSize = size;
      await tester.pumpWidget(
        MaterialApp(
          key: ValueKey(name),
          debugShowCheckedModeBanner: false,
          theme: AppTheme.build(dark ? Brightness.dark : Brightness.light),
          home: RepaintBoundary(key: const Key('capture'), child: screen),
        ),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(() async {
        final context = tester.element(find.byKey(const Key('capture')));
        await precacheImage(
          const AssetImage('assets/images/education.png'),
          context,
        );
        await precacheImage(
          const AssetImage('assets/images/trophy.png'),
          context,
        );
      });
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byKey(const Key('capture')),
        matchesGoldenFile('../docs/screenshots/$name.png'),
      );
    }

    await capture(
      'welcome-phone',
      const Size(390, 844),
      WelcomeScreen(quiz: quiz, onToggleTheme: () {}),
    );
    await capture(
      'welcome-wide',
      const Size(1280, 800),
      WelcomeScreen(quiz: quiz, onToggleTheme: () {}),
    );
    quiz.start('Dzakwan');
    quiz.select(1);
    await capture(
      'quiz-phone',
      const Size(390, 844),
      QuizScreen(quiz: quiz, onToggleTheme: () {}),
    );
    await capture(
      'quiz-landscape-dark',
      const Size(844, 390),
      QuizScreen(quiz: quiz, onToggleTheme: () {}),
      dark: true,
    );
    for (var i = 0; i < quiz.total; i++) {
      quiz.select(
        i < 8 ? quiz.current.correctIndex : (quiz.current.correctIndex + 1) % 4,
      );
      quiz.next();
    }
    await capture(
      'result-phone',
      const Size(390, 844),
      ResultScreen(quiz: quiz, onToggleTheme: () {}),
    );
    await capture(
      'result-phone-dark',
      const Size(390, 844),
      ResultScreen(quiz: quiz, onToggleTheme: () {}),
      dark: true,
    );
    await capture(
      'review-phone',
      const Size(390, 844),
      ReviewScreen(quiz: quiz, onToggleTheme: () {}),
    );
  });
}
