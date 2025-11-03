import 'package:flutter/material.dart';

class WritingArea extends StatefulWidget {
  const WritingArea({
    super.key,
    required this.controller,
    this.readOnly = false,
  });

  final TextEditingController controller;
  final bool readOnly;

  @override
  State<WritingArea> createState() => _WritingAreaState();
}

class _WritingAreaState extends State<WritingArea> {
  final UndoHistoryController _undoController = UndoHistoryController();

  @override
  void dispose() {
    _undoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Expanded(
          child: TextField(
            controller: widget.controller,
            undoController: _undoController,
            readOnly: widget.readOnly,
            cursorColor: theme.colorScheme.primary,
            style: theme.textTheme.bodyLarge?.copyWith(
              height: 1.6,
              fontSize: 17,
            ),
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              hintText: 'What happened with you today?',
              hintStyle: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.grey[400],
              ),
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        ),

        if (!widget.readOnly)
          ValueListenableBuilder<UndoHistoryValue>(
            valueListenable: _undoController,
            builder: (context, value, _) {
              final colorActive = theme.colorScheme.primary;
              final colorInactive = Colors.grey[400];

              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.undo,
                      color: value.canUndo ? colorActive : colorInactive,
                    ),
                    tooltip: 'Undo',
                    onPressed: value.canUndo ? _undoController.undo : null,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.redo,
                      color: value.canRedo ? colorActive : colorInactive,
                    ),
                    tooltip: 'Redo',
                    onPressed: value.canRedo ? _undoController.redo : null,
                  ),
                ],
              );
            },
          ),
      ],
    );
  }
}
