import 'package:flutter/material.dart';
import 'package:chit_chat/utils/constants.dart';
import 'package:at_contacts_flutter/at_contacts_flutter.dart';
import 'package:chit_chat/services/client_service.dart';
import 'package:at_chat_flutter/utils/init_chat_service.dart';
import 'package:chit_chat/screens/chats_screen.dart';

class ContactScreen extends StatefulWidget {
  static final String id = 'contact';
  const ContactScreen({Key? key}) : super(key: key);

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  ClientService service = ClientService.getInstance();

  @override
  Widget build(BuildContext context) {
    return ContactsScreen(
      onSendIconPressed: (String atsign) => _goToChat(context, atsign),
    );
  }

  void _goToChat(BuildContext context, String atsign) {
    initializeChatService(
      service.atClientInstance,
      service.atsign,
      rootDomain: AtConstants.ROOT_DOMAIN,
    );
    setChatWithAtSign(atsign);
    Navigator.of(context).pushNamed(ChatsScreen.id, arguments: atsign);
  }
}
