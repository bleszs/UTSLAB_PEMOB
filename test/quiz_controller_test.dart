import 'package:flutter_test/flutter_test.dart';
import 'package:quizora/controllers/quiz_controller.dart';
import 'package:quizora/data/questions.dart';

void main() {
  late QuizController quiz;
  setUp(() => quiz = QuizController(questions: questions));
  tearDown(() => quiz.dispose());

  test(
    'names are required and trimmed, and unanswered navigation is blocked',
    () {
      expect(() => quiz.start('   '), throwsArgumentError);
      expect(() => quiz.start('x' * 31), throwsArgumentError);
      quiz.start('  Dzakwan  ');
      expect(quiz.name, 'Dzakwan');
      expect(quiz.next(), false);
      expect(quiz.index, 0);
      expect(quiz.answered, 0);
      expect(() => quiz.select(4), throwsRangeError);
    },
  );
  test('answers survive backward navigation and can be revised', () {
    quiz.start('Ayu');
    quiz.select(0);
    quiz.next();
    quiz.select(2);
    quiz.previous();
    expect(quiz.selected, 0);
    quiz.select(1);
    expect(quiz.answered, 2);
    quiz.next();
    expect(quiz.selected, 2);
    expect(quiz.answers, [
      1,
      2,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
    ]);
  });
  test(
    'mixed answers produce exact score and completion cannot double count',
    () {
      quiz.start('Ayu');
      for (var i = 0; i < quiz.total; i++) {
        quiz.select(
          i < 8
              ? quiz.current.correctIndex
              : (quiz.current.correctIndex + 1) % 4,
        );
        expect(quiz.next(), i == quiz.total - 1);
      }
      expect(quiz.completed, true);
      expect(quiz.correct, 8);
      expect(quiz.score, 80);
      expect(quiz.progress, 1);
      expect(quiz.next(), false);
      quiz.select(0);
      expect(quiz.correct, 8);
      quiz.reset();
      expect(quiz.name, isEmpty);
      expect(quiz.answered, 0);
      expect(quiz.index, 0);
      expect(quiz.completed, false);
    },
  );
  test('zero and perfect scores use the same scale', () {
    for (final perfect in [false, true]) {
      quiz.start('Ayu');
      for (var i = 0; i < quiz.total; i++) {
        quiz.select(
          perfect
              ? quiz.current.correctIndex
              : (quiz.current.correctIndex + 1) % 4,
        );
        quiz.next();
      }
      expect(quiz.score, perfect ? 100 : 0);
    }
  });
  test('question bank has unique IDs and exactly four options', () {
    expect(questions.map((q) => q.id).toSet().length, questions.length);
    for (final q in questions) {
      expect(q.options.length, 4);
      expect(q.options.toSet().length, 4);
      expect(q.explanation, isNotEmpty);
    }
  });
}
