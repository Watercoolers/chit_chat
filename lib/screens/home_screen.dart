import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:chit_chat/widgets/onboarding_dialog.dart';

class HomeScreen extends StatelessWidget {
  static final String id = '/home';
  const HomeScreen({Key? key}) : super(key: key);
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
