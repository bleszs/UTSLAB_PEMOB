// README and design review captures of real Flutter widgets, not Android screenshots.
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quizora/controllers/quiz_controller.dart';
import 'package:quizora/data/questions.dart';
import 'package:quizora/data/bonus_questions.dart';
import 'package:quizora/models/question.dart';
import 'package:quizora/screens/mission_screen.dart';
import 'package:quizora/screens/quiz_screen.dart';
import 'package:quizora/screens/result_screen.dart';
import 'package:quizora/screens/review_screen.dart';
import 'package:quizora/screens/welcome_screen.dart';
import 'package:quizora/utils/app_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('capture current multiple-choice pages and responsive states', (
    tester,
  ) async {
    final font = FontLoader('Nunito');
    for (final name in ['Regular', 'Bold', 'ExtraBold', 'Black']) {
      font.addFont(rootBundle.load('assets/fonts/Nunito-$name.ttf'));
    }
    await font.load();
    final symbols = FontLoader('CaptureSymbols')
      ..addFont(
        Future.value(
          ByteData.sublistView(
            File('C:/Windows/Fonts/segoeui.ttf').readAsBytesSync(),
          ),
        ),
      );
    await symbols.load();
    await (FontLoader(
      'MaterialIcons',
    )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final out = Directory('screenshots')..createSync();
    QuizController quiz() =>
        QuizController(questions: questions, bonusQuestions: bonusQuestions)
          ..setPlayer('Ayu');
    Future<void> capture(
      String name,
      Widget screen, {
      Size size = const Size(390, 844),
      bool dark = false,
      double textScale = 1,
      bool fullContent = false,
    }) async {
      tester.view.physicalSize = size;
      await tester.pumpWidget(
        MaterialApp(
          key: ValueKey(name),
          debugShowCheckedModeBanner: false,
          theme: AppTheme.build(dark ? Brightness.dark : Brightness.light)
              .copyWith(
                textTheme: AppTheme.build(
                  dark ? Brightness.dark : Brightness.light,
                ).textTheme.apply(fontFamilyFallback: const ['CaptureSymbols']),
              ),
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(textScale)),
            child: child!,
          ),
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
      if (fullContent) {
        final scrollable = find.byType(Scrollable).first;
        final state = tester.state<ScrollableState>(scrollable);
        tester.view.physicalSize = Size(
          size.width,
          (size.height + state.position.maxScrollExtent).ceilToDouble(),
        );
        await tester.pumpAndSettle();
      }
      expect(tester.takeException(), isNull, reason: name);
      await tester.runAsync(() async {
        final boundary = tester.renderObject<RenderRepaintBoundary>(
          find.byKey(const Key('capture')),
        );
        final image = await boundary.toImage(pixelRatio: 1);
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        File(
          '${out.path}/$name.png',
        ).writeAsBytesSync(bytes!.buffer.asUint8List());
        image.dispose();
      });
      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
    }

    final timer =
        QuizController(
            questions: questions,
            bonusQuestions: bonusQuestions,
            now: () => DateTime(2026, 10, 27),
          )
          ..setPlayer('Ayu', mode: GameMode.challenge)
          ..startMission(missionId: 'quiz', title: 'Kuis Pilihan Ganda');
    await capture(
      '11-timer',
      QuizScreen(quiz: timer, onToggleTheme: () {}),
      fullContent: true,
    );
    timer.dispose();
    if (const bool.fromEnvironment('CAPTURE_ONLY_TIMER')) {
      return;
    }
    final profile = quiz();
    await capture(
      '01-welcome',
      WelcomeScreen(quiz: profile, onToggleTheme: () {}),
      fullContent: true,
    );
    await capture(
      '02-missions',
      MissionScreen(quiz: profile, onToggleTheme: () {}),
      fullContent: true,
    );
    profile.startMission();
    await capture(
      '03-quiz',
      QuizScreen(quiz: profile, onToggleTheme: () {}),
      fullContent: true,
    );
    profile.updateAnswer(profile.current.answerKey);
    await capture(
      '03-quiz-selected',
      QuizScreen(quiz: profile, onToggleTheme: () {}),
      fullContent: true,
    );
    profile.submit();
    await capture(
      '03-feedback',
      QuizScreen(quiz: profile, onToggleTheme: () {}),
      fullContent: true,
    );
    while (!profile.completed) {
      if (!profile.submitted) {
        profile.updateAnswer(profile.current.answerKey);
        profile.submit();
      }
      profile.next();
    }
    await capture(
      '04-result',
      ResultScreen(quiz: profile, onToggleTheme: () {}),
      fullContent: true,
    );
    await capture(
      '05-review',
      ReviewScreen(quiz: profile, onToggleTheme: () {}),
    );
    profile.dispose();
    for (final spec in [
      ('06-tablet', const Size(800, 1280), false, 1.0),
      ('07-landscape', const Size(844, 390), false, 1.0),
      ('08-dark', const Size(390, 844), true, 1.0),
      ('09-large-text', const Size(568, 320), false, 1.5),
    ]) {
      final q = quiz()..startMission();
      for (var i = 0; i < 2; i++) {
        q.updateAnswer(q.current.answerKey);
        q.submit();
        q.next();
      }
      q.updateAnswer(q.current.answerKey);
      await capture(
        spec.$1,
        QuizScreen(quiz: q, onToggleTheme: () {}),
        size: spec.$2,
        dark: spec.$3,
        textScale: spec.$4,
      );
      q.dispose();
    }
    final bonus = quiz()..startBonus();
    await capture('10-bonus', QuizScreen(quiz: bonus, onToggleTheme: () {}));
    bonus.dispose();
  });
}
