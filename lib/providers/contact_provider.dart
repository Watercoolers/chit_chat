import 'package:at_contact/at_contact.dart';
import 'package:flutter/material.dart';

class ContactProvider extends InheritedWidget {
  ContactProvider({
    Key? key,
    required this.child,
    required this.contacts,
    required this.setState,
  }) : super(key: key, child: child);

  final Widget child;
  final AtContactsImpl contacts;
  final void Function(void Function()) setState;

  static ContactProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ContactProvider>();
  }

  @override
  bool updateShouldNotify(ContactProvider oldWidget) {
    return true;
  }
}
