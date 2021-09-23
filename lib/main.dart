import 'dart:async';

import 'package:at_app_flutter/at_app_flutter.dart';
import 'package:at_chat_flutter/services/chat_service.dart';
import 'package:at_chat_flutter/utils/init_chat_service.dart';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_contacts_flutter/utils/init_contacts_service.dart';
import 'package:at_onboarding_flutter/at_onboarding_flutter.dart';
import 'package:at_utils/at_logger.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'contact_screen.dart';
import 'onboarding_button.dart';

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
        ..isLocalStoreRequired = true
        ..syncStrategy = SyncStrategy.IMMEDIATE
      // TODO set the rest of your AtClientPreference here
      ;
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // * load the AtClientPreference in the background
  Future<AtClientPreference> futurePreference = loadAtClientPreference();

  AtClientService? atClientService;
  AtClientPreference? atClientPreference;

  Map<String, bool> _clientIsInitialized = {};

  final AtSignLogger _logger = AtSignLogger(AtEnv.appNamespace);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // * The onboarding screen (first screen)
      home: Scaffold(
        appBar: AppBar(
          title: const Text('MyApp'),
        ),
        body: Builder(
          builder: (context) => Center(
            child: Column(
              children: [
                const Text('Chit Ch@t', style: TextStyle(fontSize: 36)),
                const SizedBox(height: 100),
                OnboardingButton((String? _atsign) async {
                  atClientPreference = await futurePreference;
                  Onboarding(
                    atsign: _atsign,
                    context: context,
                    atClientPreference: atClientPreference!,
                    domain: AtEnv.rootDomain,
                    onboard: (value, atsign) {
                      setState(() {
                        atClientService = value[atsign]!;
                      });
                      var instance = atClientService!.atClient!;
                      initializeContactsService(
                        instance,
                        atsign!,
                        rootDomain: AtEnv.rootDomain,
                      );

                      if (_clientIsInitialized[atsign] ?? false) {
                        var chatService = ChatService();
                        chatService.currentAtSign = atsign;
                        chatService.atClientInstance = instance;
                      } else {
                        initializeChatService(
                          instance,
                          atsign,
                          rootDomain: AtEnv.rootDomain,
                        );
                        _clientIsInitialized[atsign] = true;
                      }
                      _logger.finer('Successfully onboarded $atsign');
                    },
                    onError: (error) {
                      _logger.severe('Onboarding throws $error error');
                    },
                    nextScreen: const ContactScreen(),
                    appAPIKey: AtEnv.appApiKey,
                  );
                })
              ],
            ),
          ),
        ),
      ),

      // * The context provider for the app
      builder: (BuildContext context, Widget? child) {
        if (atClientService != null && atClientPreference != null) {
          return AtContext(
            atClientService: atClientService!,
            atClientPreference: atClientPreference!,
            child: child ?? Container(),
          );
        }
        return child ?? Container();
      },
    );
  }
}

//* The next screen after onboarding (second screen)
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // * Get the AtContext from build context
    // ! NOTE: Only use this after successfully onboarding the @sign
    AtContext atContext = AtContext.of(context);

    // * Example Uses
    /// AtClientService atClientService = atContext.atClientService;
    /// AtClientImpl? atClientInstance = atContext.atClient;
    /// String? currentAtSign = atContext.currentAtSign;
    /// AtClientPreference atClientPreference = atContext.atClientPreference;
    /// atContext.switchAtsign("@example");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text(
                'Successfully onboarded and navigated to FirstAppScreen'),
            Text('Current @sign: ${atContext.currentAtSign}'),
          ],
        ),
      ),
    );
  }
}
