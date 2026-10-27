import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/question.dart';

/// Owns puzzle drafts, scoring and clock above routes and orientation changes.
class QuizController extends ChangeNotifier {
  QuizController({
    required List<Question> questions,
    List<Question> bonusQuestions = const [],
    DateTime Function()? now,
    this.timeLimit = const Duration(seconds: 90),
  }) : bank = List.unmodifiable(questions),
       bonusBank = List.unmodifiable(bonusQuestions),
       _now = now ?? DateTime.now {
    final all = [...bank, ...bonusBank];
    if (bank.isEmpty ||
        all.map((q) => q.id).toSet().length != all.length ||
        all.any(
          (q) =>
              q.items.isEmpty ||
              q.items.map((i) => i.id).toSet().length != q.items.length ||
              q.targets.map((i) => i.id).toSet().length != q.targets.length ||
              !q.isComplete(q.answerKey),
        )) {
      throw ArgumentError(
        'Bank puzzle harus memiliki ID unik dan kunci lengkap yang valid.',
      );
    }
    if (timeLimit.inSeconds < 1) {
      throw ArgumentError('Batas waktu minimal satu detik.');
    }
    _questions = bank;
  }
  final List<Question> bank;
  final List<Question> bonusBank;
  final DateTime Function() _now;
  final Duration timeLimit;
  late List<Question> _questions;
  final Map<String, List<String>> _drafts = {};
  final Map<String, PuzzleAttempt> _attempts = {};
  final Set<String> _hints = {};
  String _name = '';
  String _avatar = 'explorer';
  String _sessionTitle = 'Maraton Pilihan Ganda';
  GameMode _mode = GameMode.relaxed;
  int _index = 0;
  int _streak = 0;
  int _bestStreak = 0;
  bool _completed = false;
  bool _practice = false;
  bool _bonus = false;
  bool _navigationPaused = false;
  bool _lifecyclePaused = false;
  bool soundEnabled = true;
  Timer? _timer;
  DateTime? _deadline;
  Duration _remaining = Duration.zero;
  int _lastSeconds = -1;
  int _sessionNumber = 0;
  List<Question> get questions => _questions;
  String get name => _name;
  String get avatar => _avatar;
  String get sessionTitle => _sessionTitle;
  GameMode get mode => _mode;
  bool get practice => _practice;
  bool get isBonus => _bonus;
  int get sessionNumber => _sessionNumber;
  int get index => _index;
  int get total => _questions.length;
  bool get completed => _completed;
  bool get hasSession => _name.isNotEmpty && _drafts.isNotEmpty && !_completed;
  Question get current => _questions[_index];
  List<String> get answer =>
      List.unmodifiable(_drafts[current.id] ?? current.initialAnswer);
  PuzzleAttempt? get attempt => _attempts[current.id];
  PuzzleAttempt? attemptFor(String id) => _attempts[id];
  bool get submitted => attempt != null;
  bool get usedHint => _hints.contains(current.id);
  bool get canSubmit => hasSession && !submitted && current.isComplete(answer);
  bool get isLast => _index == total - 1;
  int get answered => _attempts.length;
  int get correct => _attempts.values.where((a) => a.correct).length;
  int get score => (correct / total * 100).round();
  int get points => _attempts.values.fold(0, (sum, a) => sum + a.points);
  int get streak => _streak;
  int get bestStreak => _bestStreak;
  int get timedOutCount => _attempts.values.where((a) => a.timedOut).length;
  int get hintCount => _hints.length;
  double get progress => answered / total;
  List<Question> get incorrect => List.unmodifiable(
    _questions.where((q) => _attempts[q.id]?.correct == false),
  );
  int get remainingSeconds {
    final remaining = _deadline == null
        ? _remaining
        : _deadline!.difference(_now());
    return max(0, (remaining.inMilliseconds / 1000).ceil());
  }

  void setPlayer(
    String name, {
    String avatar = 'explorer',
    GameMode mode = GameMode.relaxed,
  }) {
    final trimmed = name.trim();
    if (trimmed.isEmpty || trimmed.runes.length > 30) {
      throw ArgumentError('Nama harus berisi 1–30 karakter.');
    }
    if (!['explorer', 'detective', 'inventor'].contains(avatar)) {
      throw ArgumentError('Avatar tidak dikenal.');
    }
    _stopClock();
    _drafts.clear();
    _attempts.clear();
    _hints.clear();
    _questions = bank;
    _index = 0;
    _completed = false;
    _practice = false;
    _bonus = false;
    _streak = 0;
    _bestStreak = 0;
    _name = trimmed;
    _avatar = avatar;
    _mode = mode;
    notifyListeners();
  }

  void startMission({
    String? missionId,
    String title = 'Maraton Pilihan Ganda',
  }) {
    if (_name.isEmpty) throw StateError('Isi nama terlebih dahulu.');
    final selected = missionId == null
        ? bank
        : bank.where((q) => q.missionId == missionId).toList();
    if (selected.isEmpty) throw ArgumentError('Misi tidak ditemukan.');
    _bonus = false;
    _begin(selected, title, practice: false);
  }

  void startBonus() {
    if (_name.isEmpty) throw StateError('Isi nama terlebih dahulu.');
    if (bonusBank.isEmpty) {
      throw StateError('Bank puzzle bonus tidak tersedia.');
    }
    _bonus = true;
    _begin(bonusBank, 'Zona Puzzle Bonus', practice: false);
  }

  void _begin(List<Question> selected, String title, {required bool practice}) {
    _stopClock();
    _questions = List.unmodifiable(selected);
    _sessionTitle = title;
    _practice = practice;
    _index = 0;
    _streak = 0;
    _bestStreak = 0;
    _completed = false;
    _sessionNumber++;
    _drafts.clear();
    _attempts.clear();
    _hints.clear();
    for (final q in selected) {
      _drafts[q.id] = q.initialAnswer;
    }
    _navigationPaused = true;
    _remaining = timeLimit;
    notifyListeners();
  }

  void updateAnswer(List<String> answer) {
    if (!hasSession || submitted) return;
    final q = current;
    final validIds =
        (q.type == QuestionType.matching || q.type == QuestionType.categorize
                ? q.targets
                : q.items)
            .map((i) => i.id)
            .toSet();
    if (answer.any((id) => id.isNotEmpty && !validIds.contains(id)) ||
        answer.length > max(q.items.length, q.answerKey.length)) {
      throw ArgumentError('Jawaban memakai ID atau panjang yang tidak valid.');
    }
    _drafts[q.id] = List.of(answer);
    notifyListeners();
  }

  void useHint() {
    if (!hasSession || submitted || usedHint) return;
    _hints.add(current.id);
    _streak = 0;
    notifyListeners();
  }

  bool submit({bool timedOut = false}) {
    if (!hasSession || submitted) return false;
    if (_mode == GameMode.challenge && remainingSeconds == 0) timedOut = true;
    if (!timedOut && !canSubmit) return false;
    final correct = !timedOut && current.evaluate(answer);
    final seconds = remainingSeconds;
    _stopClock();
    if (correct && !usedHint) {
      _streak++;
    } else {
      _streak = 0;
    }
    _bestStreak = max(_bestStreak, _streak);
    final comboBonus = correct && !usedHint && _streak >= 3
        ? min(30, (_streak - 2) * 10)
        : 0;
    final timeBonus = correct && _mode == GameMode.challenge
        ? min(20, (seconds / timeLimit.inSeconds * 20).floor())
        : 0;
    final earned = correct ? (usedHint ? 70 : 100) + comboBonus + timeBonus : 0;
    _attempts[current.id] = PuzzleAttempt(
      answer: answer,
      correct: correct,
      usedHint: usedHint,
      timedOut: timedOut,
      points: earned,
      comboBonus: comboBonus,
      timeBonus: timeBonus,
    );
    notifyListeners();
    return true;
  }

  bool next() {
    if (!hasSession || !submitted) return false;
    if (isLast) {
      _completed = true;
      _stopClock();
      notifyListeners();
      return true;
    }
    _index++;
    _remaining = timeLimit;
    _syncClock();
    notifyListeners();
    return false;
  }

  bool startPractice() {
    if (!_completed || incorrect.isEmpty) return false;
    final selected = incorrect;
    _begin(selected, 'Latihan yang belum tepat', practice: true);
    return true;
  }

  void setLifecyclePaused(bool paused) {
    _lifecyclePaused = paused;
    _syncClock();
  }

  void setNavigationPaused(bool paused) {
    _navigationPaused = paused;
    _syncClock();
  }

  void _stopClock() {
    if (_deadline != null) {
      _remaining = _deadline!.difference(_now());
      if (_remaining.isNegative) _remaining = Duration.zero;
    }
    _deadline = null;
    _timer?.cancel();
    _timer = null;
  }

  void _syncClock() {
    if (_mode != GameMode.challenge ||
        !hasSession ||
        submitted ||
        _navigationPaused ||
        _lifecyclePaused) {
      _stopClock();
      return;
    }
    if (_timer != null) return;
    _deadline = _now().add(_remaining);
    _lastSeconds = remainingSeconds;
    _timer = Timer.periodic(
      const Duration(milliseconds: 250),
      (_) => checkClock(),
    );
  }

  void checkClock() {
    if (_deadline == null) return;
    if (remainingSeconds == 0) {
      submit(timedOut: true);
    } else if (_lastSeconds != remainingSeconds) {
      _lastSeconds = remainingSeconds;
      notifyListeners();
    }
  }

  void toggleSound() {
    soundEnabled = !soundEnabled;
    notifyListeners();
  }

  void reset() {
    _stopClock();
    _name = '';
    _index = 0;
    _completed = false;
    _questions = bank;
    _drafts.clear();
    _attempts.clear();
    _hints.clear();
    _streak = 0;
    _bestStreak = 0;
    _practice = false;
    _bonus = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _stopClock();
    super.dispose();
  }
}
