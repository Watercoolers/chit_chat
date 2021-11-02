import 'package:at_client/at_client.dart';
import 'package:chit_chat/util/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  static const String id = '/home';
  const HomeScreen(this.futurePreference, {Key? key}) : super(key: key);
  final Future<AtClientPreference> futurePreference;

  void onboard(BuildContext context, String? atsign) {
    futurePreference.then(
      (preference) {
        instantOnboard(context, atsign, preference);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final atsign = ModalRoute.of(context)?.settings.arguments as String?;
    onboard(context, atsign);
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Chit Ch@t",
            style: GoogleFonts.playfairDisplay(
              fontSize: 48,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () => onboard(context, atsign),
            child: const Text("Let's Go!"),
          )
        ],
      )),
    );
  }
}
