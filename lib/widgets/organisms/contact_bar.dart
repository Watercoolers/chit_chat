import 'package:at_contact/at_contact.dart';
import 'package:chit_chat/widgets/molecules/contact_action_block.dart';
import 'package:chit_chat/widgets/molecules/contact_action_delete.dart';
import 'package:chit_chat/widgets/molecules/contact_content.dart';
import 'package:chit_chat/widgets/molecules/contact_action_favorite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ContactBar extends StatefulWidget {
  const ContactBar(this.contact, {this.action, Key? key}) : super(key: key);
  final AtContact contact;
  final void Function()? action;

  @override
  State<ContactBar> createState() => _ContactBarState();
}

class _ContactBarState extends State<ContactBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[300]!))),
      child: Slidable(
        actionPane: const SlidableDrawerActionPane(),
        child: InkWell(
          onTap: widget.action,
          child: ContactContent(widget.contact, setState),
        ),
        actions: [ContactActionFavorite(widget.contact)],
        secondaryActions: [
          ContactActionBlock(widget.contact),
          ContactActionDelete(widget.contact)
        ],
      ),
    );
  }
}
