import 'package:flutter/material.dart';
import 'package:chit_chat/utils/constants.dart';
import 'package:at_utils/at_logger.dart';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:chit_chat/services/client_service.dart';
import 'package:at_onboarding_flutter/screens/onboarding_widget.dart';
import 'package:chit_chat/screens/contact_screen.dart';

class OnboardingScreen extends StatefulWidget {
  static final String id = 'onboard';
  OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  String? atSign;
  var _logger = AtSignLogger('chit_ch@t');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //! Title
              Text(
                "Chit Ch@t",
                style: TextStyle(fontSize: 20),
              ),

              //! Spacer
              SizedBox(
                height: 10,
              ),

              //! Let's Go Button
              ElevatedButton(
                onPressed: () async {
                  ClientService clientService = ClientService.getInstance();
                  var atClientPreference =
                      await clientService.getAtClientPreference();
                  if (clientService.isOnboarded) {
                    Navigator.of(context).pushNamed(ContactScreen.id);
                  } else {
                    Onboarding(
                      appAPIKey: '',
                      context: context,
                      atClientPreference: atClientPreference,
                      domain: AtConstants.ROOT_DOMAIN,
                      onboard: clientService.postOnboard,
                      appColor: Colors.blue,
                      onError: (error) {
                        _logger.severe('Onboarding throws $error error');
                      },
                      nextScreen: ContactScreen(),
                    );
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                child: Text("Let's Go!"),
              ),
              //! Spacer
              SizedBox(
                height: 10,
              ),

              //! Reset Button
              ElevatedButton(
                onPressed: () async {
                  KeyChainManager _keyChainManager =
                      KeyChainManager.getInstance();
                  var _atSignsList =
                      await _keyChainManager.getAtSignListFromKeychain();
                  _atSignsList?.forEach(
                    (element) {
                      _keyChainManager.deleteAtSignFromKeychain(element);
                    },
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Keychain cleaned',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue)),
                child: Text(
                  "Reset Keychain",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
