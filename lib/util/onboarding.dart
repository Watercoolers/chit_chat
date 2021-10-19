import 'package:at_app_flutter/at_app_flutter.dart';
import 'package:at_chat_flutter/utils/init_chat_service.dart';
import 'package:at_client/at_client.dart';
import 'package:at_contacts_flutter/utils/init_contacts_service.dart';
import 'package:at_onboarding_flutter/screens/onboarding_widget.dart';
import 'package:flutter/material.dart';

import 'package:chit_chat/screens/contact_screen.dart';

void instantOnboard(
  BuildContext context,
  String? atsign,
  AtClientPreference preference,
) {
  Onboarding(
    atsign: atsign,
    context: context,
    atClientPreference: preference,
    domain: AtEnv.rootDomain,
    rootEnvironment: AtEnv.rootEnvironment,
    appAPIKey: AtEnv.appApiKey,
    onboard: (value, atsign) {
      initializeContactsService(rootDomain: AtEnv.rootDomain);
      initializeChatService(AtClientManager.getInstance(), atsign!);
      Navigator.of(context).pushReplacementNamed(ContactScreen.id);
    },
    onError: (error) {},
  );
}
