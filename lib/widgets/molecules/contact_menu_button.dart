import 'package:at_contacts_flutter/widgets/add_contacts_dialog.dart';
import 'package:chit_chat/screens/block_screen.dart';
import 'package:flutter/material.dart';

class ContactMenuButton extends StatelessWidget {
  ContactMenuButton({Key? key}) : super(key: key);

  void openProfileDialog() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PopupMenuButton<MenuOption>(
        icon: Icon(Icons.menu),
        itemBuilder: (ctx) {
          return [
            PopupMenuItem(
              child: Text('My Profile'),
              value: MenuOption.profile,
            ),
            PopupMenuItem(
              child: Text('Add Contact'),
              value: MenuOption.add,
            ),
            PopupMenuItem(
              child: Text('Blocked Contacts'),
              value: MenuOption.blocked,
            ),
            PopupMenuItem(
              child: Text('Switch @sign'),
              value: MenuOption.atsign,
            )
          ];
        },
        onSelected: (option) {
          switch (option) {
            case MenuOption.profile:
              break;
            case MenuOption.add:
              showDialog(context: context, builder: (_) => AddContactDialog());
              break;
            case MenuOption.blocked:
              Navigator.of(context).pushNamed(BlockScreen.id);
              break;
            case MenuOption.atsign:
              break;
            default:
              break;
          }
        },
      ),
    );
  }
}

enum MenuOption {
  profile,
  add,
  blocked,
  atsign,
}
