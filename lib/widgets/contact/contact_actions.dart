import 'package:chit_chat/providers/contact_provider.dart';
import 'package:chit_chat/widgets/contact/contact_action.dart';
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

class FavAction extends ContactAction {
  const FavAction(contact, {Key? key}) : super(contact, key: key);

  bool get isFav => contact.favourite ?? false;

  IconData get iconData => (isFav) ? Icons.favorite : Icons.favorite_border;

  final Color color = Colors.white;
  final Color foregroundColor = Colors.red;

  void Function(ContactProvider) get action => (cp) => cp.setState(
        () {
          contact.favourite = !isFav;
          cp.contacts.update(contact);
        },
      );
}
