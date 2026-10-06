// Renderer captures, not native Android evidence.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quizora/controllers/quiz_controller.dart';
import 'package:quizora/data/questions.dart';
import 'package:quizora/models/question.dart';
import 'package:quizora/screens/mission_screen.dart';
import 'package:quizora/screens/quiz_screen.dart';
import 'package:quizora/screens/result_screen.dart';
import 'package:quizora/screens/welcome_screen.dart';
import 'package:quizora/utils/app_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final fonts = FontLoader('Nunito');
    for (final name in ['Regular', 'Bold', 'ExtraBold', 'Black']) {
      fonts.addFont(rootBundle.load('assets/fonts/Nunito-$name.ttf'));
    }
    await fonts.load();
    final icons = FontLoader('MaterialIcons')
      ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
    await icons.load();
  });
  testWidgets('capture Quest screens, puzzle variants and feedback', (
    tester,
  ) async {
    final quiz = QuizController(questions: questions);
    addTearDown(quiz.dispose);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.devicePixelRatio = 1;
    Future<void> capture(
      String name,
      Widget screen, {
      Size size = const Size(390, 844),
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
        matchesGoldenFile('../docs/screenshots/quest/$name.png'),
      );
    }

    await capture('welcome', WelcomeScreen(quiz: quiz, onToggleTheme: () {}));
    quiz.setPlayer('Ayu');
    await capture('missions', MissionScreen(quiz: quiz, onToggleTheme: () {}));
    for (final type in QuestionType.values) {
      final q = questions.firstWhere((q) => q.type == type);
      final isolated = QuizController(questions: [q])
        ..setPlayer('Ayu')
        ..startMission();
      await capture(
        type.name,
        QuizScreen(quiz: isolated, onToggleTheme: () {}),
      );
      await tester.pumpWidget(const SizedBox());
      isolated.dispose();
    }
    quiz.startMission(missionId: 'lab', title: 'Kunci Ruang Lab');
    quiz.updateAnswer(['2', '4', '3']);
    await capture(
      'code-landscape-dark',
      QuizScreen(quiz: quiz, onToggleTheme: () {}),
      size: const Size(844, 390),
      dark: true,
    );
    quiz.submit();
    await capture('feedback', QuizScreen(quiz: quiz, onToggleTheme: () {}));
    quiz.next();
    while (!quiz.completed) {
      quiz.updateAnswer(quiz.current.answerKey);
      quiz.submit();
      quiz.next();
    }
    await capture('result', ResultScreen(quiz: quiz, onToggleTheme: () {}));
  });
}
