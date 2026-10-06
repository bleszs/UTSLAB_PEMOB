import 'package:flutter_test/flutter_test.dart';
import 'package:quizora/controllers/quiz_controller.dart';
import 'package:quizora/data/questions.dart';
import 'package:quizora/models/question.dart';

void main() {
  QuizController create({DateTime Function()? now}) {
    final quiz = QuizController(questions: questions, now: now);
    addTearDown(quiz.dispose);
    return quiz;
  }

  void solve(QuizController quiz) {
    quiz.updateAnswer(quiz.current.answerKey);
    expect(quiz.submit(), true);
  }

  test('all seven evaluators reject incomplete, duplicate and unknown IDs', () {
    expect(questions.map((q) => q.type).toSet(), QuestionType.values.toSet());
    expect(questions.map((q) => q.id).toSet().length, 12);
    for (final q in questions) {
      expect(q.evaluate(q.answerKey), true, reason: q.id);
      expect(q.evaluate([]), false);
      expect(q.evaluate(['unknown']), false);
      if (q.answerKey.length > 1 && q.type != QuestionType.categorize) {
        expect(
          q.evaluate(List.filled(q.answerKey.length, q.answerKey.first)),
          false,
        );
      }
    }
    expect(questions[4].evaluate(['b', 'a']), true); // set order is irrelevant
    expect(questions[8].evaluate(['3', '4', '2']), false); // code order matters
    expect(questions.first.evaluate(questions.first.initialAnswer), false);
  });
  test('profile validation and mission filtering are explicit', () {
    final quiz = create();
    expect(() => quiz.setPlayer('   '), throwsArgumentError);
    expect(() => quiz.setPlayer('a' * 31), throwsArgumentError);
    expect(() => quiz.setPlayer('Ayu', avatar: 'unknown'), throwsArgumentError);
    quiz.setPlayer(' Ayu ', avatar: 'detective');
    quiz.startMission(missionId: 'lab', title: 'Kunci Ruang Lab');
    expect(quiz.name, 'Ayu');
    expect(quiz.total, 4);
    expect(quiz.current.id, 'q09');
    expect(() => quiz.startMission(missionId: 'missing'), throwsArgumentError);
    expect(
      () => QuizController(questions: [questions.first, questions.first]),
      throwsArgumentError,
    );
  });
  test(
    'submission blocks incomplete input, locks immutable answers and never double counts',
    () {
      final quiz = create();
      quiz.setPlayer('Ayu');
      quiz.startMission(missionId: 'lab');
      expect(quiz.canSubmit, false);
      expect(quiz.submit(), false);
      expect(quiz.next(), false);
      final draft = ['2', '4', '3'];
      quiz.updateAnswer(draft);
      draft[0] = '1';
      expect(quiz.answer, ['2', '4', '3']);
      expect(() => quiz.answer.add('4'), throwsUnsupportedError);
      expect(quiz.submit(), true);
      expect(quiz.points, 100);
      expect(quiz.submit(), false);
      quiz.updateAnswer(['1', '2', '3']);
      expect(quiz.answer, ['2', '4', '3']);
      expect(quiz.attempt!.correct, true);
      expect(() => quiz.attempt!.answer.clear(), throwsUnsupportedError);
    },
  );
  test('accuracy, combo and hint points have separate rules', () {
    final quiz = create();
    quiz.setPlayer('Ayu');
    quiz.startMission();
    for (var i = 0; i < 12; i++) {
      solve(quiz);
      quiz.next();
    }
    expect(quiz.completed, true);
    expect(quiz.score, 100);
    expect(quiz.points, 1470);
    expect(quiz.bestStreak, 12);
    expect(quiz.startPractice(), false);
    quiz.setPlayer('Bela');
    quiz.startMission(missionId: 'presentation');
    solve(quiz);
    quiz.next();
    quiz.useHint();
    quiz.useHint();
    solve(quiz);
    quiz.next();
    solve(quiz);
    quiz.next();
    solve(quiz);
    quiz.next();
    expect(quiz.score, 100);
    expect(quiz.points, 370);
    expect(quiz.hintCount, 1);
    expect(quiz.bestStreak, 2);
  });
  test(
    'practice includes only failed questions in a new session and reset clears player',
    () {
      final quiz = create();
      quiz.setPlayer('Ayu');
      quiz.startMission(missionId: 'presentation');
      quiz.submit(); // authored shuffled sequence is wrong
      quiz.next();
      for (var i = 0; i < 3; i++) {
        solve(quiz);
        quiz.next();
      }
      expect(quiz.score, 75);
      expect(quiz.incorrect.single.id, 'q01');
      final previousSession = quiz.sessionNumber;
      expect(quiz.startPractice(), true);
      expect(quiz.sessionNumber, previousSession + 1);
      expect(quiz.total, 1);
      expect(quiz.points, 0);
      expect(quiz.practice, true);
      expect(quiz.name, 'Ayu');
      solve(quiz);
      quiz.next();
      expect(quiz.score, 100);
      quiz.reset();
      expect(quiz.name, isEmpty);
      expect(quiz.hasSession, false);
      expect(quiz.answered, 0);
    },
  );
  test(
    'clock pauses for navigation and app lifecycle; expired input cannot earn points',
    () {
      var time = DateTime(2026, 10, 7);
      final quiz = create(now: () => time);
      quiz.setPlayer('Ayu', mode: GameMode.challenge);
      quiz.startMission(missionId: 'lab');
      quiz.setNavigationPaused(false);
      time = time.add(const Duration(seconds: 20));
      expect(quiz.remainingSeconds, 70);
      quiz.setNavigationPaused(true);
      time = time.add(const Duration(minutes: 3));
      expect(quiz.remainingSeconds, 70);
      quiz.setLifecyclePaused(true);
      quiz.setNavigationPaused(false);
      time = time.add(const Duration(minutes: 2));
      expect(quiz.remainingSeconds, 70);
      quiz.setLifecyclePaused(false);
      quiz.updateAnswer(quiz.current.answerKey);
      time = time.add(const Duration(seconds: 70));
      expect(quiz.submit(), true);
      expect(quiz.attempt!.timedOut, true);
      expect(quiz.points, 0);
      expect(quiz.submit(), false);
      quiz.next();
      expect(quiz.remainingSeconds, 90);
      time = time.add(const Duration(seconds: 91));
      quiz.checkClock();
      expect(quiz.attempt!.timedOut, true);
      expect(quiz.timedOutCount, 2);
    },
  );
  test(
    'challenge bonus uses remaining time; changing player clears old drafts',
    () {
      var time = DateTime(2026, 10, 7);
      final quiz = create(now: () => time);
      quiz.setPlayer('Ayu', mode: GameMode.challenge);
      quiz.startMission(missionId: 'lab');
      quiz.setNavigationPaused(false);
      time = time.add(const Duration(seconds: 45));
      solve(quiz);
      expect(quiz.attempt!.timeBonus, 10);
      expect(quiz.points, 110);
      quiz.setPlayer('Bela');
      expect(quiz.hasSession, false);
      expect(quiz.answered, 0);
      expect(quiz.points, 0);
    },
  );
}
