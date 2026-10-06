import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quizora/main.dart';
import 'package:quizora/controllers/quiz_controller.dart';
import 'package:quizora/data/questions.dart';
import 'package:quizora/models/question.dart';
import 'package:quizora/widgets/puzzle_interactor.dart';

Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> solveVisible(WidgetTester tester) async {
  final quiz = tester
      .widget<PuzzleInteractor>(find.byType(PuzzleInteractor))
      .quiz;
  final q = quiz.current;
  switch (q.type) {
    case QuestionType.sequence:
      for (var target = 0; target < q.answerKey.length; target++) {
        final id = q.answerKey[target];
        final label = q.items.firstWhere((i) => i.id == id).label;
        while (quiz.answer.indexOf(id) > target) {
          await tapVisible(tester, find.byTooltip('Naikkan $label'));
        }
      }
    case QuestionType.matching:
    case QuestionType.categorize:
      for (var i = 0; i < q.items.length; i++) {
        final label = q.targets.firstWhere((t) => t.id == q.answerKey[i]).label;
        await tapVisible(tester, find.widgetWithText(ChoiceChip, label).at(i));
      }
    case QuestionType.codeBuilder:
      for (final id in q.answerKey) {
        await tapVisible(tester, find.widgetWithText(ActionChip, id));
      }
    case QuestionType.hotspot:
    case QuestionType.scenario:
    case QuestionType.multiSelect:
      for (final id in q.answerKey) {
        await tapVisible(
          tester,
          find.text(q.items.firstWhere((item) => item.id == id).label),
        );
      }
  }
  expect(quiz.canSubmit, true);
}

void setSize(WidgetTester tester, Size value) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = value;
}

void main() {
  testWidgets('semantic tap activates hotspot and choices and respects lock', (
    tester,
  ) async {
    setSize(tester, const Size(390, 844));
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final semantics = tester.ensureSemantics();
    try {
      for (final q in [questions[1], questions[4], questions[3]]) {
        final quiz = QuizController(questions: [q])
          ..setPlayer('Ayu')
          ..startMission();
        await tester.pumpWidget(
          MaterialApp(
            key: ValueKey(q.id),
            home: Scaffold(
              body: ListenableBuilder(
                listenable: quiz,
                builder: (context, _) => PuzzleInteractor(quiz: quiz),
              ),
            ),
          ),
        );
        final item = q.items.first;
        final label =
            'Pilih ${item.label}${item.detail.isEmpty ? '' : ': ${item.detail}'}';
        final node = tester.getSemantics(find.bySemanticsLabel(label));
        expect(node.getSemanticsData().hasAction(SemanticsAction.tap), true);
        node.owner!.performAction(node.id, SemanticsAction.tap);
        await tester.pump();
        expect(quiz.answer, [item.id]);
        quiz.updateAnswer(q.answerKey);
        quiz.submit();
        await tester.pump();
        final locked = tester.getSemantics(find.bySemanticsLabel(label));
        expect(locked.getSemanticsData().hasAction(SemanticsAction.tap), false);
        expect(locked.getSemanticsData().flagsCollection.isEnabled, false);
        locked.owner!.performAction(locked.id, SemanticsAction.tap);
        expect(quiz.answer, q.answerKey);
        await tester.pumpWidget(const SizedBox());
        quiz.dispose();
      }
    } finally {
      semantics.dispose();
    }
  });
  testWidgets('long-press token drag fills a slot and keeps token IDs unique', (
    tester,
  ) async {
    setSize(tester, const Size(390, 844));
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final quiz = QuizController(questions: [questions[8]])
      ..setPlayer('Ayu')
      ..startMission();
    addTearDown(quiz.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListenableBuilder(
            listenable: quiz,
            builder: (context, _) => PuzzleInteractor(quiz: quiz),
          ),
        ),
      ),
    );
    final token = find.widgetWithText(ActionChip, '2');
    final slot = find.byType(OutlinedButton).first;
    final gesture = await tester.startGesture(tester.getCenter(token));
    await tester.pump(const Duration(milliseconds: 600));
    await gesture.moveTo(tester.getCenter(slot));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();
    expect(quiz.answer, ['2', '', '']);
    await tester.tap(find.widgetWithText(ActionChip, '4'));
    await tester.pumpAndSettle();
    expect(quiz.answer, ['2', '4', '']);
    expect(tester.takeException(), isNull);
  });
  testWidgets(
    'all seven interactions complete marathon, review and clean replay',
    (tester) async {
      setSize(tester, const Size(390, 844));
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const QuizoraApp());
      await tapVisible(tester, find.text('Pilih Misi'));
      expect(find.text('Isi nama dulu, lalu pilih misi.'), findsOneWidget);
      await tester.enterText(find.byKey(const Key('name_input')), 'Ayu');
      await tapVisible(tester, find.text('Pilih Misi'));
      await tapVisible(tester, find.text('Maraton 12 Puzzle'));
      for (var i = 0; i < 12; i++) {
        await solveVisible(tester);
        await tapVisible(tester, find.text('Kirim Jawaban'));
        expect(find.text('Buktinya cocok!'), findsOneWidget);
        await tapVisible(
          tester,
          find.text(i == 11 ? 'Lihat Hasil' : 'Puzzle Berikutnya'),
        );
      }
      expect(find.text('100%'), findsOneWidget);
      expect(find.text('1470'), findsOneWidget);
      await tapVisible(tester, find.text('Lihat Pembahasan'));
      expect(find.text('Alur file yang tertukar'), findsOneWidget);
      await tapVisible(tester, find.byTooltip('Kembali'));
      await tapVisible(tester, find.text('Main Lagi'));
      expect(
        tester
            .widget<TextFormField>(find.byKey(const Key('name_input')))
            .controller!
            .text,
        isEmpty,
      );
      expect(find.text('Isi nama dulu, lalu pilih misi.'), findsNothing);
      expect(find.text('Lanjutkan misi sebelumnya'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'code tokens survive landscape, theme and leaving/resuming a mission',
    (tester) async {
      setSize(tester, const Size(390, 844));
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const QuizoraApp());
      await tester.enterText(find.byKey(const Key('name_input')), 'Ayu');
      await tapVisible(tester, find.text('Pilih Misi'));
      await tapVisible(tester, find.text('Kunci Ruang Lab'));
      await tapVisible(tester, find.widgetWithText(ActionChip, '2'));
      final quiz = tester
          .widget<PuzzleInteractor>(find.byType(PuzzleInteractor))
          .quiz;
      setSize(tester, const Size(844, 390));
      await tester.pumpAndSettle();
      expect(quiz.answer, ['2', '', '']);
      await tapVisible(tester, find.byTooltip('Aktifkan mode gelap'));
      expect(quiz.answer, ['2', '', '']);
      await tapVisible(tester, find.byTooltip('Kembali'));
      await tapVisible(tester, find.text('Lanjutkan misi sebelumnya'));
      expect(quiz.answer, ['2', '', '']);
      await tapVisible(tester, find.widgetWithText(ActionChip, '4'));
      await tapVisible(tester, find.widgetWithText(ActionChip, '3'));
      await tapVisible(tester, find.text('Buka Petunjuk'));
      await tapVisible(tester, find.text('Kirim Jawaban'));
      expect(quiz.attempt!.points, 70);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'small landscape and enlarged text support every renderer without overflow',
    (tester) async {
      setSize(tester, const Size(568, 320));
      tester.platformDispatcher.textScaleFactorTestValue = 1.5;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pumpWidget(const QuizoraApp());
      await tester.enterText(
        find.byKey(const Key('name_input')),
        'Nama cukup panjang',
      );
      await tapVisible(tester, find.text('Pilih Misi'));
      await tapVisible(tester, find.text('Maraton 12 Puzzle'));
      for (var i = 0; i < 12; i++) {
        await solveVisible(tester);
        expect(tester.takeException(), isNull);
        await tapVisible(tester, find.text('Kirim Jawaban'));
        await tapVisible(
          tester,
          find.text(i == 11 ? 'Lihat Hasil' : 'Puzzle Berikutnya'),
        );
      }
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'wrong answer exposes explanation and practice only contains that puzzle',
    (tester) async {
      setSize(tester, const Size(390, 844));
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const QuizoraApp());
      await tester.enterText(find.byKey(const Key('name_input')), 'Bela');
      await tapVisible(tester, find.text('Pilih Misi'));
      await tapVisible(tester, find.text('Selamatkan Presentasi'));
      await tapVisible(tester, find.text('Kirim Jawaban'));
      expect(find.text('Belum tepat'), findsOneWidget);
      await tapVisible(tester, find.text('Puzzle Berikutnya'));
      for (var i = 0; i < 3; i++) {
        await solveVisible(tester);
        await tapVisible(tester, find.text('Kirim Jawaban'));
        await tapVisible(
          tester,
          find.text(i == 2 ? 'Lihat Hasil' : 'Puzzle Berikutnya'),
        );
      }
      expect(find.text('75%'), findsOneWidget);
      await tapVisible(tester, find.text('Latih yang Belum Tepat'));
      expect(find.text('Puzzle 1 / 1'), findsOneWidget);
      await solveVisible(tester);
      await tapVisible(tester, find.text('Kirim Jawaban'));
      await tapVisible(tester, find.text('Lihat Hasil'));
      expect(find.text('100%'), findsOneWidget);
      expect(find.text('100'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
