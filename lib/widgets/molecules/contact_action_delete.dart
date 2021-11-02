import 'package:chit_chat/providers/contact_provider.dart';
import 'package:chit_chat/widgets/atoms/contact_action.dart';
import 'package:flutter/material.dart';

class ContactActionDelete extends ContactConfirmationAction {
  const ContactActionDelete(contact, {Key? key}) : super(contact, key: key);

  @override
  final IconData iconData = Icons.delete;

  @override
  final Color color = Colors.red;

  @override
  final Color foregroundColor = Colors.white;

  @override
  final String confirmationTitle = 'Please Confirm';

  @override
  String get confirmationMessage =>
      'Are you sure you want to delete ${contact.atSign!}?';

  @override
  void Function(ContactProvider) get confirmationAction => (cp) => cp.setState(
        () {
          cp.contacts.deleteContact(contact);
        },
      );
}
