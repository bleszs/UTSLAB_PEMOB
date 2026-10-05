import 'package:flutter/foundation.dart';
import '../models/question.dart';

/// State sesi berada di atas route; rotasi hanya mengubah layout.
class QuizController extends ChangeNotifier {
  QuizController({required List<Question> questions}) : questions = List.unmodifiable(questions) {
    if (questions.isEmpty) throw ArgumentError('Kuis harus memiliki soal.');
    _answers = List<int?>.filled(questions.length, null);
  }
  final List<Question> questions;
  late List<int?> _answers;
  String _name = '';
  int _index = 0;
  bool _completed = false;
  String get name => _name;
  int get index => _index;
  int get total => questions.length;
  bool get completed => _completed;
  bool get hasSession => _name.isNotEmpty && !_completed;
  bool get isLast => _index == total - 1;
  Question get current => questions[_index];
  int? get selected => _answers[_index];
  List<int?> get answers => List.unmodifiable(_answers);
  int get answered => _answers.whereType<int>().length;
  double get progress => answered / total;
  int get correct => List.generate(total, (i) => _answers[i] == questions[i].correctIndex).where((v) => v).length;
  int get score => (correct / total * 100).round();

  void start(String name) {
    final cleaned = name.trim();
    if (cleaned.isEmpty || cleaned.runes.length > 30) throw ArgumentError('Nama harus berisi 1–30 karakter.');
    _name = cleaned;
    _index = 0;
    _completed = false;
    _answers = List<int?>.filled(total, null);
    notifyListeners();
  }
  void select(int option) {
    if (!hasSession) return;
    if (option < 0 || option >= current.options.length) throw RangeError.index(option, current.options);
    _answers[_index] = option;
    notifyListeners();
  }
  bool next() {
    if (!hasSession || selected == null) return false;
    if (isLast) {
      _completed = true;
      notifyListeners();
      return true;
    }
    _index++;
    notifyListeners();
    return false;
  }
  void previous() {
    if (_index == 0 || _completed) return;
    _index--;
    notifyListeners();
  }
  void reset() {
    _name = '';
    _index = 0;
    _completed = false;
    _answers = List<int?>.filled(total, null);
    notifyListeners();
  }
}
