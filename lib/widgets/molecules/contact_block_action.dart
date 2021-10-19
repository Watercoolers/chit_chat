import 'package:chit_chat/providers/contact_provider.dart';
import 'package:chit_chat/widgets/atoms/contact_action.dart';
import 'package:flutter/material.dart';

class BlockAction extends ContactConfirmationAction {
  const BlockAction(contact, {Key? key}) : super(contact, key: key);

  final IconData iconData = Icons.block;

  final Color color = const Color(0xFFEEEEEE);
  final Color foregroundColor = Colors.red;

  final String confirmationTitle = 'Please Confirm';

  String get confirmationMessage =>
      'Are you sure you want to block ${contact.atSign!}?';

  void Function(ContactProvider) get confirmationAction => (cp) => cp.setState(
        () {
          contact.blocked = true;
          cp.contacts.update(contact);
        },
      );
}
