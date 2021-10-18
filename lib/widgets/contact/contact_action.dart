import 'package:at_contact/at_contact.dart';
import 'package:chit_chat/providers/contact_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../confirmation_dialog.dart';

abstract class ContactAction extends StatelessWidget {
  const ContactAction(this.contact, {Key? key, bool withConfirmation = true})
      : this.withConfirmation = withConfirmation,
        super(key: key);
  final AtContact contact;
  final bool withConfirmation;
  abstract final IconData iconData;
  abstract final Color color;
  abstract final Color foregroundColor;
  abstract final void Function(ContactProvider) action;

  @override
  Widget build(BuildContext context) {
    return IconSlideAction(
      icon: iconData,
      foregroundColor: foregroundColor,
      color: color,
      closeOnTap: true,
      onTap: () => action(ContactProvider.of(context)!),
    );
  }
}

abstract class ContactConfirmationAction extends StatelessWidget {
  const ContactConfirmationAction(this.contact, {Key? key}) : super(key: key);
  final AtContact contact;
  abstract final IconData iconData;
  abstract final Color color;
  abstract final Color foregroundColor;
  abstract final String confirmationTitle;
  abstract final String confirmationMessage;
  abstract final void Function(ContactProvider) confirmationAction;

  @override
  Widget build(BuildContext context) {
    return IconSlideAction(
      icon: iconData,
      color: color,
      foregroundColor: foregroundColor,
      closeOnTap: true,
      onTap: () => showDialog(
        context: context,
        builder: (context) => ConfirmationDialog(
          confirmationTitle,
          confirmationMessage,
          () => confirmationAction(ContactProvider.of(context)!),
        ),
      ),
    );
  }
}
