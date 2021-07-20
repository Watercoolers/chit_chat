import 'package:flutter/material.dart';
import 'package:chit_chat/utils/constants.dart';
import 'package:at_utils/at_logger.dart';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:chit_chat/services/client_service.dart';
import 'package:at_onboarding_flutter/screens/onboarding_widget.dart';
import 'package:chit_chat/screens/contact_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatefulWidget {
  static final String id = 'onboard';
  OnboardingScreen({Key? key}) : super(key: key);
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  var _logger = AtSignLogger('chit_ch@t');
  KeyChainManager _keyChainManager = KeyChainManager.getInstance();
  List<String>? _atSignsList = [];
  String? _atsign;

  bool get _isNotEmpty => _atSignsList?.isNotEmpty ?? false;
  @override
  void initState() {
    initKeyChain();
    super.initState();
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
    return Scaffold(
      body: Builder(
        builder: (context) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _spacer(height: 100),
              Text(
                "Chit Ch@t",
                style: GoogleFonts.playfairDisplay(
                    fontSize: 48,
                    textStyle: TextStyle(fontWeight: FontWeight.bold)),
              ),
              _spacer(height: 100),
              if (_isNotEmpty) _previousOnboard(),
              _newOnboard(),
              if (_isNotEmpty) _resetButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _spacer({double? height}) => SizedBox(
        height: height ?? 10,
      );

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

  Widget _onboard(String? atsign, String text) {
    ClientService clientService = ClientService.getInstance();
    clientService.resetInstance();
    return ElevatedButton(
      onPressed: () async {
        var atClientPreference = await clientService.getAtClientPreference();
        Onboarding(
          atsign: atsign,
          appAPIKey: '400b-806u-bzez-z42z-6a3p',
          context: context,
          atClientPreference: atClientPreference,
          domain: AtConstants.ROOT_DOMAIN,
          onboard: (value, atsign) {
            clientService.postOnboard(value, atsign);
            print('atsign $atsign');
            if (atsign != null) {
              if (_atSignsList == null) _atSignsList = [];
              if (!_atSignsList!.contains(atsign)) {
                setState(() {
                  _atSignsList!.add(atsign);
                  _atsign = atsign;
                });
              }
            }
          },
          nextScreen: ContactScreen(),
          appColor: Colors.blue,
          onError: (error) {
            _logger.severe('Onboarding throws $error error');
          },
        );
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.blue),
      ),
      child: Text(text),
    );
  }

  Widget _resetButton() {
    return Column(
      children: [
        _spacer(height: 60),
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
