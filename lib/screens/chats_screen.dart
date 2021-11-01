import 'package:at_chat_flutter/at_chat_flutter.dart';
import 'package:at_chat_flutter/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class ChatsScreen extends StatelessWidget {
  static const String id = '/chat';

  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
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
