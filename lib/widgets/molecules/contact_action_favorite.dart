import 'package:chit_chat/providers/contact_provider.dart';
import 'package:chit_chat/widgets/atoms/contact_action.dart';
import 'package:flutter/material.dart';

class ContactActionFavorite extends ContactAction {
  const ContactActionFavorite(contact, {Key? key}) : super(contact, key: key);

  bool get isFav => contact.favourite ?? false;

  @override
  IconData get iconData => (isFav) ? Icons.favorite : Icons.favorite_border;

  @override
  final Color color = Colors.white;

  @override
  final Color foregroundColor = Colors.red;

  @override
  void Function(ContactProvider) get action => (cp) => cp.setState(
        () {
          contact.favourite = !isFav;
          cp.contacts.update(contact);
        },
      );
}
