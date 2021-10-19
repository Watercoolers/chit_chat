import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:chit_chat/widgets/onboarding_dialog.dart';

class HomeScreen extends StatelessWidget {
  static const String id = '/home';
  const HomeScreen(this.atsign, {Key? key}) : super(key: key);
  final String? atsign;
  @override
  Widget build(BuildContext context) {
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
          OnboardingDialog()
        ],
      )),
    );
  }
}
