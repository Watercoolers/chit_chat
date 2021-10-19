import 'package:at_contact/at_contact.dart';
import 'package:chit_chat/widgets/molecules/contact_block_action.dart';
import 'package:chit_chat/widgets/molecules/contact_delete_action.dart';
import 'package:chit_chat/widgets/molecules/contact_content.dart';
import 'package:chit_chat/widgets/molecules/contact_fav_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ContactBar extends StatefulWidget {
  ContactBar(this.contact, {this.action, Key? key}) : super(key: key);
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
        actionPane: SlidableDrawerActionPane(),
        child: InkWell(
          onTap: widget.action,
          child: ContactContent(widget.contact, setState),
        ),
        actions: [FavAction(widget.contact)],
        secondaryActions: [
          BlockAction(widget.contact),
          DeleteAction(widget.contact)
        ],
      ),
    );
  }
}
