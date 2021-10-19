import 'package:chit_chat/providers/contact_provider.dart';
import 'package:chit_chat/widgets/atoms/contact_action.dart';
import 'package:flutter/material.dart';

class DeleteAction extends ContactConfirmationAction {
  const DeleteAction(contact, {Key? key}) : super(contact, key: key);

  final IconData iconData = Icons.delete;

  final Color color = Colors.red;
  final Color foregroundColor = Colors.white;

  final String confirmationTitle = 'Please Confirm';

  String get confirmationMessage =>
      'Are you sure you want to delete ${contact.atSign!}?';

  void Function(ContactProvider) get confirmationAction => (cp) => cp.setState(
        () {
          cp.contacts.deleteContact(contact);
        },
      );
}
