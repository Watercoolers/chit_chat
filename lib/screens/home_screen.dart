import 'package:at_client/at_client.dart';
import 'package:chit_chat/main.dart';
import 'package:chit_chat/util/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  static const String id = '/home';
  const HomeScreen(this.futurePreference, {Key? key}) : super(key: key);
  final Future<AtClientPreference> futurePreference;
  @override
  Widget build(BuildContext context) {
    final atsign = ModalRoute.of(context)?.settings.arguments as String?;
    futurePreference.then(
      (preference) {
        instantOnboard(context, atsign, preference);
      },
    );

    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Chit Ch@t",
            style: GoogleFonts.playfairDisplay(
              fontSize: 48,
              textStyle: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      )),
    );
  }
}
