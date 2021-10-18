import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog(this.title, this.message, this.confirm, {Key? key})
      : super(key: key);
  final String title;
  final String message;
  final void Function() confirm;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            confirm();
            Navigator.of(context).pop();
          },
          child: Text('Confirm'),
        ),
      ],
    );
  }
}
