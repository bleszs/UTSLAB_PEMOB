import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:quizora/controllers/quiz_controller.dart';
import 'package:quizora/data/questions.dart';
import 'package:quizora/models/question.dart';

void main() {
  test(
    'Android smoke fixture agrees with all 16 puzzles, scoring and practice',
    () {
      final fixture =
          jsonDecode(File('tool/quest_smoke_scenario.json').readAsStringSync())
              as Map<String, dynamic>;
      final expected = fixture['expected'] as Map<String, dynamic>;
      expect(questions.length, fixture['total']);
      expect(missions.length, fixture['missionCount']);
      expect(questions.map((q) => q.type).toSet().length, fixture['typeCount']);
      final classics = fixture['classicQuestions'] as List<dynamic>;
      expect(
        classics.length,
        questions.where((q) => q.type == QuestionType.multipleChoice).length,
      );
      for (final entry in classics) {
        final question = questions[(entry['position'] as int) - 1];
        expect(question.id, entry['id']);
        expect(question.type, QuestionType.multipleChoice);
        final index = (entry['choice'] as String).codeUnitAt(0) - 65;
        final chosen = question.items[index];
        expect(chosen.label, entry['label']);
        expect(question.evaluate([chosen.id]), true);
      }
      final hints = (fixture['hintQuestionIds'] as List<dynamic>)
          .cast<String>();
      final wrong = fixture['wrongAnswers'] as Map<String, dynamic>;
      final quiz = QuizController(questions: questions)
        ..setPlayer('Adit', avatar: 'detective');
      addTearDown(quiz.dispose);
      quiz.startMission();
      for (final question in questions) {
        expect(quiz.current.id, question.id);
        if (hints.contains(question.id)) quiz.useHint();
        final answer = wrong[question.id] == null
            ? question.answerKey
            : (wrong[question.id] as List<dynamic>).cast<String>();
        quiz.updateAnswer(answer);
        expect(quiz.submit(), true);
        expect(quiz.submit(), false);
        quiz.next();
      }
      expect(quiz.completed, true);
      expect(quiz.total, expected['total']);
      expect(quiz.correct, expected['correct']);
      expect(quiz.score, expected['accuracy']);
      expect(quiz.points, expected['points']);
      expect(quiz.bestStreak, expected['bestCombo']);
      expect(quiz.hintCount, expected['hints']);
      expect(quiz.incorrect.map((q) => q.id).toSet(), wrong.keys.toSet());
      expect(quiz.startPractice(), true);
      expect(quiz.total, wrong.length);
      expect(quiz.points, 0);
      while (!quiz.completed) {
        quiz.updateAnswer(quiz.current.answerKey);
        expect(quiz.submit(), true);
        quiz.next();
      }
      expect(quiz.score, 100);
      expect(quiz.points, 100);
      quiz.reset();
      expect(quiz.name, isEmpty);
      expect(quiz.hasSession, false);
    },
  );
}
