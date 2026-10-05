import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quizora/main.dart';
import 'package:quizora/data/questions.dart';
import 'package:quizora/widgets/option_card.dart';

void main() {
  Future<void> tapVisible(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  void size(WidgetTester tester, Size value) {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = value;
  }

  tearDown(() {});
  testWidgets('full quiz, review and replay flow; empty names are rejected', (
    tester,
  ) async {
    size(tester, const Size(390, 844));
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const QuizoraApp());
    await tapVisible(tester, find.text('Mulai Kuis'));
    expect(find.text('Isi nama dulu, lalu mulai kuis.'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('name_input')), 'Ayu');
    await tapVisible(tester, find.text('Mulai Kuis'));
    expect(find.text('Soal 1 dari 10'), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
    for (var i = 0; i < questions.length; i++) {
      await tapVisible(
        tester,
        find.byType(OptionCard).at(questions[i].correctIndex),
      );
      await tapVisible(
        tester,
        find.text(i == 9 ? 'Lihat Hasil' : 'Selanjutnya'),
      );
    }
    expect(find.text('Hebat, Ayu!'), findsOneWidget);
    expect(find.text('100'), findsOneWidget);
    expect(find.text('10 dari 10 jawaban benar'), findsOneWidget);
    await tapVisible(tester, find.text('Lihat Pembahasan'));
    expect(find.text('Soal 1 · Benar'), findsOneWidget);
    await tapVisible(tester, find.byTooltip('Kembali'));
    await tapVisible(tester, find.text('Main Lagi'));
    expect(find.byKey(const Key('name_input')), findsOneWidget);
    expect(
      tester
          .widget<TextFormField>(find.byKey(const Key('name_input')))
          .controller!
          .text,
      isEmpty,
    );
    expect(tester.takeException(), isNull);
  });
  testWidgets('rotation, theme and back navigation preserve selection', (
    tester,
  ) async {
    size(tester, const Size(320, 568));
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const QuizoraApp());
    await tester.enterText(
      find.byKey(const Key('name_input')),
      'Nama pengguna panjang',
    );
    await tapVisible(tester, find.text('Mulai Kuis'));
    await tapVisible(tester, find.text('Mars'));
    size(tester, const Size(844, 390));
    await tester.pumpAndSettle();
    expect(
      tester.widget<OptionCard>(find.byType(OptionCard).at(1)).selected,
      true,
    );
    await tapVisible(tester, find.byTooltip('Aktifkan mode gelap'));
    expect(
      tester.widget<OptionCard>(find.byType(OptionCard).at(1)).selected,
      true,
    );
    await tapVisible(tester, find.text('Selanjutnya'));
    await tapVisible(tester, find.byTooltip('Kembali'));
    expect(find.text('Soal 1 dari 10'), findsOneWidget);
    expect(
      tester.widget<OptionCard>(find.byType(OptionCard).at(1)).selected,
      true,
    );
    expect(tester.takeException(), isNull);
  });
  testWidgets('small landscape remains scrollable with enlarged text', (
    tester,
  ) async {
    size(tester, const Size(568, 320));
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(const QuizoraApp());
    await tester.enterText(find.byKey(const Key('name_input')), 'Ayu');
    await tapVisible(tester, find.text('Mulai Kuis'));
    await tapVisible(tester, find.text('Mars'));
    expect(tester.takeException(), isNull);
  });
}
