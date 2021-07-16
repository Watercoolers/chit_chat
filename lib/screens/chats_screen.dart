import 'package:at_chat_flutter/at_chat_flutter.dart';
import 'package:flutter/material.dart';
import 'package:at_chat_flutter/screens/chat_screen.dart';

class ChatsScreen extends StatelessWidget {
  static final String id = 'chat';

  @override
  Widget build(BuildContext context) {
    final title = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(title: Text('Chat')),
      body: ChatScreen(
        height: MediaQuery.of(context).size.height,
        incomingMessageColor: Colors.green[100]!,
        outgoingMessageColor: Colors.blue[100]!,
        title: title,
        isScreen: true,
      ),
    );
  }
}
