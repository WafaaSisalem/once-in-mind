import 'package:flutter/material.dart';

class DialogTextFieldWidget extends StatelessWidget {
  const DialogTextFieldWidget({
    super.key,
    required this.onChanged,
    required this.hintText,
    required this.isObscured,
    this.content,
  });

  final Function(String) onChanged;
  final String hintText;
  final bool isObscured;
  final String? content;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return TextField(
      style: theme.textTheme.titleSmall,
      cursorColor: Colors.grey, //
      onChanged: onChanged,
      maxLines: isObscured ? 1 : 3,
      minLines: 1,
      autofocus: true,
      controller: TextEditingController(text: content),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: theme.textTheme.headlineMedium!.copyWith(
          color: Colors.grey,
        ), //
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: theme.primaryColor),
        ),
      ),
      obscureText: isObscured ? true : false,
    );
  }
}

enum DialogType { discard, delete, password, addTask, editTask, quit }

class DialogWidget extends StatefulWidget {
  DialogWidget({
    super.key,
    required this.dialogType,
    required this.entryType,
    required this.onOkPressed,
    this.content,
    this.onNextPressed,
  });

  final String entryType;
  final DialogType dialogType;
  final Function(String) onOkPressed;
  Function(String)? onNextPressed;
  final String? content;
  @override
  State<DialogWidget> createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {
  String? dialogTitle;
  Widget? dialogContent;
  String value = '';
  bool nextButton = false;
  initValues() {
    switch (widget.dialogType) {
      case DialogType.delete:
        dialogTitle = 'Delete';
        dialogContent = Text(
          'Do you want to delete this ${widget.entryType} entry?',
        );
        break;
      case DialogType.discard:
        dialogTitle = 'Discard';
        dialogContent = const Text('Do you want to discard the changes?');
        break;
      case DialogType.password:
        dialogTitle = 'Password';
        dialogContent = DialogTextFieldWidget(
          isObscured: true,
          hintText: '',
          onChanged: (value) {
            this.value = value;
          },
        );
        break;

      case DialogType.addTask:
        dialogTitle = 'Add Task';
        dialogContent = DialogTextFieldWidget(
          isObscured: false,
          hintText: 'write a task',
          onChanged: (value) {
            this.value = value;
          },
        );
        nextButton = true;
        break;
      case DialogType.editTask:
        dialogTitle = 'Edit Task';
        dialogContent = DialogTextFieldWidget(
          isObscured: false,
          content: widget.content,
          hintText: 'write a task',
          onChanged: (value) {
            this.value = value;
          },
        );
        break;
      case DialogType.quit:
        dialogTitle = 'Quit';
        dialogContent = const Text('Do you want to quit?');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initValues();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return AlertDialog(
      backgroundColor: Colors.white, //
      contentPadding: EdgeInsets.only(top: 10, bottom: 0, left: 20, right: 20),
      titlePadding: EdgeInsets.only(top: 20, bottom: 0, left: 20),
      title: Text(dialogTitle!, style: theme.textTheme.titleLarge),
      content: dialogContent,
      actions: [
        if (nextButton) ...[
          TextButton(
            onPressed: () {
              widget.onNextPressed!(value);
            },
            child: Text(
              'Next',
              style: theme.textTheme.titleLarge,
              // color
            ),
          ),
          TextButton(onPressed: null, child: SizedBox()),
        ],
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'CANCEL',
            style: theme.textTheme.titleLarge!.copyWith(
              color: const Color(0xFFE0BFEA),
            ), // color
          ),
        ),
        TextButton(
          onPressed: () {
            widget.onOkPressed(value);
          },
          child: Text('OK', style: theme.textTheme.titleLarge),
        ),
      ],
    );
  }
}
