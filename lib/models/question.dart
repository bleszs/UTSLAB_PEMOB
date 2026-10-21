enum QuestionType {
  sequence,
  hotspot,
  matching,
  categorize,
  multiSelect,
  codeBuilder,
  scenario,
  multipleChoice,
}

enum GameMode { relaxed, challenge }

class PuzzleItem {
  const PuzzleItem(this.id, this.label, {this.detail = ''});
  final String id;
  final String label;
  final String detail;
}

class Mission {
  const Mission(this.id, this.title, this.description);
  final String id;
  final String title;
  final String description;
}

class Question {
  const Question({
    required this.id,
    required this.missionId,
    required this.type,
    required this.title,
    required this.context,
    required this.instruction,
    required this.items,
    required this.answerKey,
    required this.hint,
    required this.explanation,
    this.targets = const [],
  });
  final String id;
  final String missionId;
  final QuestionType type;
  final String title;
  final String context;
  final String instruction;
  final List<PuzzleItem> items;
  final List<PuzzleItem> targets;
  final List<String> answerKey;
  final String hint;
  final String explanation;
  String get typeLabel => switch (type) {
    QuestionType.sequence => 'Susun alur',
    QuestionType.hotspot => 'Detektif visual',
    QuestionType.matching => 'Cocokkan bukti',
    QuestionType.categorize => 'Kelompokkan',
    QuestionType.multiSelect => 'Pilih kombinasi',
    QuestionType.codeBuilder => 'Rakit kode',
    QuestionType.scenario => 'Ambil keputusan',
    QuestionType.multipleChoice => 'Pilihan ganda',
  };
  List<String> get initialAnswer => switch (type) {
    QuestionType.sequence => items.map((item) => item.id).toList(),
    QuestionType.matching ||
    QuestionType.categorize => List.filled(items.length, ''),
    QuestionType.codeBuilder => List.filled(answerKey.length, ''),
    _ => [],
  };
  bool isComplete(List<String> answer) {
    final ids = items.map((item) => item.id).toSet();
    final targetIds = targets.map((item) => item.id).toSet();
    return switch (type) {
      QuestionType.sequence =>
        answer.length == items.length &&
            answer.toSet().length == items.length &&
            answer.every(ids.contains),
      QuestionType.hotspot ||
      QuestionType.scenario ||
      QuestionType.multipleChoice =>
        answer.length == 1 && ids.contains(answer.single),
      QuestionType.multiSelect =>
        answer.length == answerKey.length &&
            answer.toSet().length == answer.length &&
            answer.every(ids.contains),
      QuestionType.matching =>
        answer.length == items.length &&
            answer.toSet().length == answer.length &&
            answer.every(targetIds.contains),
      QuestionType.categorize =>
        answer.length == items.length && answer.every(targetIds.contains),
      QuestionType.codeBuilder =>
        answer.length == answerKey.length &&
            answer.toSet().length == answer.length &&
            answer.every(ids.contains),
    };
  }

  bool evaluate(List<String> answer) {
    if (!isComplete(answer)) return false;
    if (type == QuestionType.multiSelect) {
      return answer.toSet().containsAll(answerKey) &&
          answerKey.toSet().containsAll(answer);
    }
    if (answer.length != answerKey.length) return false;
    for (var i = 0; i < answer.length; i++) {
      if (answer[i] != answerKey[i]) return false;
    }
    return true;
  }

  String describe(List<String> answer) {
    String label(String id) =>
        [
          ...items,
          ...targets,
        ].where((item) => item.id == id).firstOrNull?.label ??
        'Belum diisi';
    if (type == QuestionType.matching || type == QuestionType.categorize) {
      return List.generate(
        items.length,
        (i) =>
            '${items[i].label} → ${label(i < answer.length ? answer[i] : '')}',
      ).join('\n');
    }
    if (answer.isEmpty) return 'Belum dijawab';
    return answer.map(label).join(type == QuestionType.sequence ? ' → ' : ', ');
  }
}

class PuzzleAttempt {
  PuzzleAttempt({
    required List<String> answer,
    required this.correct,
    required this.usedHint,
    required this.timedOut,
    required this.points,
    required this.comboBonus,
    required this.timeBonus,
  }) : answer = List.unmodifiable(answer);
  final List<String> answer;
  final bool correct;
  final bool usedHint;
  final bool timedOut;
  final int points;
  final int comboBonus;
  final int timeBonus;
}
