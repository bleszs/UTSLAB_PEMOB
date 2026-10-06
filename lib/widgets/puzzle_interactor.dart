import 'package:flutter/material.dart';
import '../controllers/quiz_controller.dart';
import '../models/question.dart';

/// Seven puzzle renderers sharing controller-owned answers and accessible taps.
class PuzzleInteractor extends StatelessWidget {
  const PuzzleInteractor({super.key, required this.quiz});
  final QuizController quiz;
  void _assign(int index, String value, {bool unique = false}) {
    final answer = quiz.answer.toList();
    if (unique) {
      for (var i = 0; i < answer.length; i++) {
        if (i != index && answer[i] == value) answer[i] = '';
      }
    }
    answer[index] = value;
    quiz.updateAnswer(answer);
  }

  @override
  Widget build(BuildContext context) => switch (quiz.current.type) {
    QuestionType.sequence => _sequence(context),
    QuestionType.hotspot => _document(context),
    QuestionType.matching => _matching(context),
    QuestionType.categorize => _categorize(context),
    QuestionType.multiSelect || QuestionType.scenario => _choices(context),
    QuestionType.codeBuilder => _code(context),
  };
  Widget _sequence(BuildContext context) {
    final answer = quiz.answer;
    void move(int from, int to) {
      final next = answer.toList();
      final item = next.removeAt(from);
      next.insert(to, item);
      quiz.updateAnswer(next);
    }

    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      buildDefaultDragHandles: false,
      itemCount: answer.length,
      onReorder: (from, to) {
        if (!quiz.submitted) move(from, to > from ? to - 1 : to);
      },
      itemBuilder: (context, index) {
        final item = quiz.current.items.firstWhere(
          (item) => item.id == answer[index],
        );
        return Padding(
          key: ValueKey(item.id),
          padding: const EdgeInsets.only(bottom: 10),
          child: Material(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
              child: Row(
                children: [
                  ReorderableDragStartListener(
                    index: index,
                    enabled: !quiz.submitted,
                    child: Semantics(
                      label: 'Geser ${item.label}',
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.drag_indicator_rounded),
                      ),
                    ),
                  ),
                  Text(
                    '${index + 1}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.label,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        if (item.detail.isNotEmpty)
                          Text(
                            item.detail,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      IconButton(
                        tooltip: 'Naikkan ${item.label}',
                        onPressed: quiz.submitted || index == 0
                            ? null
                            : () => move(index, index - 1),
                        icon: const Icon(Icons.keyboard_arrow_up_rounded),
                      ),
                      IconButton(
                        tooltip: 'Turunkan ${item.label}',
                        onPressed: quiz.submitted || index == answer.length - 1
                            ? null
                            : () => move(index, index + 1),
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _document(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Icon(Icons.description_outlined, color: scheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    quiz.current.id == 'q02'
                        ? 'Rincian biaya tim'
                        : 'Daftar reservasi',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
          ),
          for (final item in quiz.current.items) ...[
            const Divider(),
            Semantics(
              button: true,
              selected: quiz.answer.contains(item.id),
              enabled: !quiz.submitted,
              onTap: quiz.submitted ? null : () => quiz.updateAnswer([item.id]),
              label: 'Pilih ${item.label}: ${item.detail}',
              child: ExcludeSemantics(
                child: InkWell(
                  onTap: quiz.submitted
                      ? null
                      : () => quiz.updateAnswer([item.id]),
                  child: Container(
                    color: quiz.answer.contains(item.id)
                        ? scheme.primaryContainer
                        : null,
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.label,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                item.detail,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          quiz.answer.contains(item.id)
                              ? Icons.check_circle_rounded
                              : Icons.touch_app_outlined,
                          color: scheme.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _choices(BuildContext context) {
    final multi = quiz.current.type == QuestionType.multiSelect;
    final answer = quiz.answer;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (multi)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              '${answer.length} dari ${quiz.current.answerKey.length} dipilih',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        for (final item in quiz.current.items)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: PuzzleChoice(
              item: item,
              selected: answer.contains(item.id),
              multi: multi,
              onTap: quiz.submitted
                  ? null
                  : () {
                      if (!multi) {
                        quiz.updateAnswer([item.id]);
                        return;
                      }
                      final next = answer.toList();
                      if (next.contains(item.id)) {
                        next.remove(item.id);
                      } else if (next.length < quiz.current.answerKey.length) {
                        next.add(item.id);
                      }
                      quiz.updateAnswer(next);
                    },
            ),
          ),
      ],
    );
  }

  Widget _token(BuildContext context, PuzzleItem item, VoidCallback? onTap) {
    final chip = ActionChip(
      label: Text(item.label),
      onPressed: quiz.submitted ? null : onTap,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
    );
    if (quiz.submitted) return chip;
    return LongPressDraggable<String>(
      data: item.id,
      feedback: Material(
        color: Colors.transparent,
        child: Chip(label: Text(item.label)),
      ),
      child: chip,
    );
  }

  Widget _matching(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final target in quiz.current.targets)
            _token(context, target, () {
              final empty = quiz.answer.indexOf('');
              if (empty >= 0) _assign(empty, target.id, unique: true);
            }),
        ],
      ),
      const SizedBox(height: 20),
      for (var i = 0; i < quiz.current.items.length; i++)
        DragTarget<String>(
          onWillAcceptWithDetails: (data) =>
              !quiz.submitted &&
              quiz.current.targets.any((t) => t.id == data.data),
          onAcceptWithDetails: (data) => _assign(i, data.data, unique: true),
          builder: (context, candidate, rejected) => Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quiz.current.items[i].label,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final target in quiz.current.targets)
                      ChoiceChip(
                        label: Text(target.label),
                        selected: quiz.answer[i] == target.id,
                        onSelected: quiz.submitted
                            ? null
                            : (_) => _assign(
                                i,
                                quiz.answer[i] == target.id ? '' : target.id,
                                unique: true,
                              ),
                        padding: const EdgeInsets.all(8),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
    ],
  );
  Widget _categorize(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          for (final group in quiz.current.targets)
            DragTarget<String>(
              onWillAcceptWithDetails: (data) =>
                  !quiz.submitted &&
                  quiz.current.items.any((i) => i.id == data.data),
              onAcceptWithDetails: (data) => _assign(
                quiz.current.items.indexWhere((i) => i.id == data.data),
                group.id,
              ),
              builder: (context, candidate, rejected) => Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withValues(alpha: .5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      group.label,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    for (var i = 0; i < quiz.current.items.length; i++)
                      if (quiz.answer[i] == group.id)
                        Text('• ${quiz.current.items[i].label}'),
                    if (!quiz.answer.contains(group.id))
                      const Text('Tarik catatan ke sini'),
                  ],
                ),
              ),
            ),
        ],
      ),
      const SizedBox(height: 20),
      for (var i = 0; i < quiz.current.items.length; i++)
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _token(
                context,
                quiz.current.items[i],
                quiz.submitted
                    ? null
                    : () {
                        final next =
                            quiz.current.targets[(quiz.current.targets
                                        .indexWhere(
                                          (t) => t.id == quiz.answer[i],
                                        ) +
                                    1) %
                                quiz.current.targets.length];
                        _assign(i, next.id);
                      },
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final group in quiz.current.targets)
                    ChoiceChip(
                      label: Text(group.label),
                      selected: quiz.answer[i] == group.id,
                      onSelected: quiz.submitted
                          ? null
                          : (_) => _assign(i, group.id),
                      padding: const EdgeInsets.all(8),
                    ),
                ],
              ),
            ],
          ),
        ),
    ],
  );
  Widget _code(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(Icons.lock_outline_rounded, color: scheme.primary, size: 48),
        const SizedBox(height: 20),
        Row(
          children: [
            for (var i = 0; i < quiz.answer.length; i++)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: DragTarget<String>(
                    onWillAcceptWithDetails: (data) =>
                        !quiz.submitted &&
                        quiz.current.items.any((item) => item.id == data.data),
                    onAcceptWithDetails: (data) =>
                        _assign(i, data.data, unique: true),
                    builder: (context, candidate, rejected) => OutlinedButton(
                      onPressed: quiz.submitted ? null : () => _assign(i, ''),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                      ),
                      child: Semantics(
                        label:
                            'Slot ${i + 1}: ${quiz.answer[i].isEmpty ? 'kosong' : quiz.answer[i]}',
                        child: Text(
                          quiz.answer[i].isEmpty ? '–' : quiz.answer[i],
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 20),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final item in quiz.current.items)
              _token(
                context,
                item,
                quiz.submitted || quiz.answer.contains(item.id)
                    ? null
                    : () {
                        final empty = quiz.answer.indexOf('');
                        if (empty >= 0) _assign(empty, item.id, unique: true);
                      },
              ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          'Ketuk token untuk mengisi slot kosong. Ketuk slot untuk menghapus isinya.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class PuzzleChoice extends StatelessWidget {
  const PuzzleChoice({
    super.key,
    required this.item,
    required this.selected,
    required this.onTap,
    this.multi = false,
  });
  final PuzzleItem item;
  final bool selected;
  final VoidCallback? onTap;
  final bool multi;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final foreground = selected ? scheme.onPrimary : scheme.onSurface;
    return Semantics(
      button: true,
      selected: selected,
      enabled: onTap != null,
      onTap: onTap,
      label:
          'Pilih ${item.label}${item.detail.isEmpty ? '' : ': ${item.detail}'}',
      child: ExcludeSemantics(
        child: Material(
          color: selected ? scheme.primary : scheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: selected ? scheme.primary : scheme.outlineVariant,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.label,
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(color: foreground),
                        ),
                        if (item.detail.isNotEmpty)
                          Text(
                            item.detail,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(color: foreground),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    selected
                        ? Icons.check_circle_rounded
                        : (multi
                              ? Icons.check_box_outline_blank_rounded
                              : Icons.radio_button_unchecked),
                    color: foreground,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
