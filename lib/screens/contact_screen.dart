import 'package:at_chat_flutter/utils/init_chat_service.dart' as chats;
import 'package:at_client/at_client.dart';
import 'package:at_contact/at_contact.dart';
import 'package:chit_chat/providers/contact_provider.dart';
import 'package:chit_chat/widgets/organisms/contact_bar.dart';
import 'package:chit_chat/widgets/molecules/contact_menu_button.dart';
import 'package:flutter/material.dart';

import 'package:chit_chat/screens/chats_screen.dart';

class ContactScreen extends StatefulWidget {
  static const String id = '/contact';
  const ContactScreen({Key? key}) : super(key: key);

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  AtContactsImpl atContactsImpl = AtContactsImpl(
    AtClientManager.getInstance().atClient,
    AtClientManager.getInstance().atClient.getCurrentAtSign()!,
  );

  List<AtContact> contacts = [];

  @override
  void initState() {
    atContactsImpl.listActiveContacts().then((contacts) {
      var c = [
        ...contacts.where((c) => c.favourite ?? false),
        ...contacts.where((c) => !(c.favourite ?? false))
      ];
      setState(() {
        this.contacts = c;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ContactProvider(
      contacts: atContactsImpl,
      setState: setState,
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Messages')),
          centerTitle: true,
          actions: [ContactMenuButton()],
          toolbarHeight: 100,
        ),
        body: ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (BuildContext context, int index) {
            if (contacts[index].blocked ?? false) return Container();
            return ContactBar(
              contacts[index],
              action: () => _goToChat(context, contacts[index].atSign!),
            );
          },
        ),
      ),
    );
  }

  void _goToChat(BuildContext context, String atsign) {
    chats.setChatWithAtSign(atsign);
    Navigator.of(context).pushNamed(ChatsScreen.id, arguments: atsign);
  }
}
