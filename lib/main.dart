import 'dart:async';

import 'package:at_app_flutter/at_app_flutter.dart';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'package:chit_chat/screens/chats_screen.dart';
import 'package:chit_chat/screens/contact_screen.dart';
import 'package:chit_chat/screens/home_screen.dart';

void main() {
  AtEnv.load();
  runApp(const MyApp());
}

Future<AtClientPreference> loadAtClientPreference() async {
  var dir = await path_provider.getApplicationSupportDirectory();
  return AtClientPreference()
    ..rootDomain = AtEnv.rootDomain
    ..namespace = AtEnv.appNamespace
    ..hiveStoragePath = dir.path
    ..commitLogPath = dir.path
    ..isLocalStoreRequired = true;
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // * load the AtClientPreference in the background
  Future<AtClientPreference> futurePreference = loadAtClientPreference();
  bool isFirstLoad = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chit Ch@t',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // * The onboarding screen (first screen)
      routes: {
        HomeScreen.id: (_) => HomeScreen(),
        ContactScreen.id: (_) => ContactScreen(),
        ChatsScreen.id: (_) => ChatsScreen()
      },

      initialRoute: HomeScreen.id,
    );
  }
}
