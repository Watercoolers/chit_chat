import 'package:chit_chat/providers/contact_provider.dart';
import 'package:chit_chat/widgets/atoms/contact_action.dart';
import 'package:flutter/material.dart';

class ContactActionBlock extends ContactConfirmationAction {
  const ContactActionBlock(contact, {Key? key}) : super(contact, key: key);

  @override
  final IconData iconData = Icons.block;

  @override
  final Color color = const Color(0xFFEEEEEE);

  @override
  final Color foregroundColor = Colors.red;

  @override
  final String confirmationTitle = 'Please Confirm';

  @override
  String get confirmationMessage =>
      'Are you sure you want to block ${contact.atSign!}?';

  @override
  void Function(ContactProvider) get confirmationAction => (cp) => cp.setState(
        () {
          contact.blocked = true;
          cp.contacts.update(contact);
        },
      );
}
