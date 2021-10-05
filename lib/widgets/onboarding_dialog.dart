import 'package:at_app_flutter/at_app_flutter.dart';
import 'package:at_chat_flutter/utils/init_chat_service.dart';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_contacts_flutter/utils/init_contacts_service.dart';
import 'package:at_onboarding_flutter/screens/onboarding_widget.dart';
import 'package:flutter/material.dart';

import 'package:chit_chat/main.dart';
import 'package:chit_chat/screens/contact_screen.dart';
import 'package:chit_chat/screens/home_screen.dart';
import 'package:chit_chat/widgets/error_dialog.dart';

class OnboardingDialog extends StatefulWidget {
  OnboardingDialog({Key? key}) : super(key: key);

  @override
  _OnboardingDialogState createState() => _OnboardingDialogState();
}

class _OnboardingDialogState extends State<OnboardingDialog> {
  KeyChainManager _keyChainManager = KeyChainManager.getInstance();
  List<String>? _atSignsList = [];
  String? _atsign;

  @override
  void initState() {
    super.initState();
    initKeyChain();
  }

  Future<void> initKeyChain() async {
    var atSignsList = await _keyChainManager.getAtSignListFromKeychain();
    if (atSignsList?.isNotEmpty ?? false) {
      setState(() {
        _atSignsList = atSignsList;
        _atsign = atSignsList![0];
      });
    } else {
      setState(() {
        _atSignsList = atSignsList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (_atSignsList?.isNotEmpty ?? false) _previousOnboard(),
        _newOnboard(),
        if (_atSignsList?.isNotEmpty ?? false) _resetButton(),
      ],
    );
  }

  Widget _previousOnboard() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton(
              value: _atsign,
              items: _atSignsList!
                  .map((atsign) =>
                      DropdownMenuItem(child: Text(atsign), value: atsign))
                  .toList(),
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    _atsign = value;
                  });
                }
              },
            ),
            SizedBox(
              width: 10,
            ),
            _onboard(_atsign, "Go!")
          ],
        ),
      ],
    );
  }

  Widget _newOnboard() {
    return _onboard("", "Setup a new @sign");
  }

  Widget _onboard(String? atSign, String text) {
    return ElevatedButton(
      onPressed: () async {
        var preference = await loadAtClientPreference();
        Onboarding(
          atsign: atSign,
          context: context,
          atClientPreference: preference,
          domain: AtEnv.rootDomain,
          rootEnvironment: AtEnv.rootEnvironment,
          appAPIKey: AtEnv.appApiKey,
          onboard: (value, atsign) {
            initializeContactsService(rootDomain: AtEnv.rootDomain);
            initializeChatService(AtClientManager.getInstance(), atsign!);
            if ((atsign != null) &&
                !(_atSignsList?.contains(atsign) ?? false)) {
              setState(() {
                if (_atSignsList == null) _atSignsList = [];
                _atSignsList!.add(atsign);
                _atsign = atsign;
              });
            }
            Navigator.of(context).pushNamed(ContactScreen.id);
          },
          onError: (error) {
            _handleError(context);
          },
        );
      },
      child: Text(text),
    );
  }

  void _handleError(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => ErrorDialog(
        'Unable to Onboard',
        'Please try again later!',
        [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(HomeScreen.id);
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _resetButton() {
    return Column(
      children: [
        SizedBox(height: 60),
        ElevatedButton(
          onPressed: () {
            _showResetDialog(context, false);
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red)),
          child: Text(
            "Reset @signs",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  _showResetDialog(BuildContext context, bool shouldPop) {
    if (shouldPop) Navigator.pop(context);
    showDialog(context: context, builder: _resetAtsignDialog);
  }

  Widget _resetAtsignDialog(BuildContext context) {
    return AlertDialog(
      title: Text("Reset your atsigns"),
      content: Container(
        height: 360,
        width: 240,
        child: SingleChildScrollView(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _atSignsList!.length,
            itemBuilder: (BuildContext context, int index) {
              return Row(
                children: [
                  Text(_atSignsList![index]),
                  Expanded(
                    child: Container(),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                    ),
                    child: Text("Reset", style: TextStyle(color: Colors.white)),
                    onPressed: () => _resetAtSign(_atSignsList![index]),
                  )
                ],
              );
            },
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }

  void _resetAtSign(String atsign) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Reset Confirmation"),
          content: Text("Are you sure you want to reset $atsign?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                _showResetDialog(context, true);
              },
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
              child: Text("Reset", style: TextStyle(color: Colors.white)),
              onPressed: () {
                _showResetDialog(context, true);
                _keyChainManager.deleteAtSignFromKeychain(atsign);
                setState(() {
                  if (_atSignsList!.length == 1) {
                    _atsign = null;
                  }
                  if (_atSignsList!.length > 1 && _atsign == atsign) {
                    _atsign = _atSignsList!
                        .firstWhere((element) => element != atsign);
                  }
                  _atSignsList!.remove(atsign);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Reset $atsign',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
