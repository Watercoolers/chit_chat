import 'dart:async';

import 'package:chit_chat/screens/contact_screen.dart';
import 'package:flutter/material.dart';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_onboarding_flutter/at_onboarding_flutter.dart';
import 'package:at_utils/at_logger.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:at_app_flutter/at_app_flutter.dart';

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

  final AtSignLogger _logger = AtSignLogger(AtEnv.appNamespace);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // * The onboarding screen (first screen)
      home: Scaffold(
        body: FutureBuilder(
          future: futurePreference,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              // TODO
            }
            if (snapshot.hasData) {
              onboard(context, snapshot.data);
            }
            //TODO;
            return Container();
          },
        ),
      ),
    );
  }

  void onboard(BuildContext context, AtClientPreference atClientPreference) {
    Onboarding(
      context: context,
      atClientPreference: atClientPreference,
      domain: AtEnv.rootDomain,
      rootEnvironment: AtEnv.rootEnvironment,
      appAPIKey: AtEnv.appApiKey,
      onboard: (value, atsign) {
        _logger.finer('Successfully onboarded $atsign');
      },
      onError: (error) {
        _logger.severe('Onboarding throws $error error');
      },
      nextScreen: const ContactScreen(),
    );
  }
}
