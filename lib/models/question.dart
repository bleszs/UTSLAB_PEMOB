class Question {
  const Question({required this.id, required this.category, required this.text,
    required this.options, required this.correctIndex, required this.explanation})
    : assert(options.length == 4), assert(correctIndex >= 0 && correctIndex < 4);
  final String id;
  final String category;
  final String text;
  final List<String> options;
  final int correctIndex;
  final String explanation;
}
