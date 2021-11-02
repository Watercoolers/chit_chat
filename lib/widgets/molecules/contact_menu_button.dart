import 'package:at_contacts_flutter/widgets/add_contacts_dialog.dart';
import 'package:chit_chat/screens/block_screen.dart';
import 'package:flutter/material.dart';

class ContactMenuButton extends StatelessWidget {
  const ContactMenuButton({Key? key}) : super(key: key);

  void openProfileDialog() {}

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuOption>(
      icon: const Icon(Icons.menu),
      itemBuilder: (ctx) {
        return [
          const PopupMenuItem(
            child: Text('My Profile'),
            value: MenuOption.profile,
          ),
          const PopupMenuItem(
            child: Text('Add Contact'),
            value: MenuOption.add,
          ),
          const PopupMenuItem(
            child: Text('Blocked Contacts'),
            value: MenuOption.blocked,
          ),
          const PopupMenuItem(
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
    );
  }
}

enum MenuOption {
  profile,
  add,
  blocked,
  atsign,
}
