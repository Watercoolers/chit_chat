import 'package:flutter/material.dart';

import 'package:chit_chat/screens/chats_screen.dart';
import 'package:chit_chat/screens/contact_screen.dart';
import 'package:chit_chat/screens/onboarding_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chit Ch@t',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: OnboardingScreen.id,
      routes: {
        OnboardingScreen.id: (_) => OnboardingScreen(),
        ContactScreen.id: (_) => ContactScreen(),
        ChatsScreen.id: (_) => ChatsScreen(),
      },
    );
  }
}
