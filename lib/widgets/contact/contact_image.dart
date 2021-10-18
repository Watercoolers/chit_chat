import 'dart:typed_data';

import 'package:at_contact/at_contact.dart';
import 'package:flutter/material.dart';
import 'package:chit_chat/util/string_extension.dart';

class ContactImage extends StatefulWidget {
  ContactImage(this.contact, {Key? key}) : super(key: key);
  final AtContact contact;

  @override
  State<ContactImage> createState() => _ContactImageState();
}

class _ContactImageState extends State<ContactImage> {
  Widget? avatar;
  String? text;
  @override
  void initState() {
    super.initState();

    if (widget.contact.tags?['image'] != null) {
      List<int> intList = widget.contact.tags!['image'].cast<int>();
      var bytes = Uint8List.fromList(intList);
      setState(() {
        avatar = CircleAvatar(backgroundImage: Image.memory(bytes).image);
      });
    } else if (widget.contact.tags?['name'] ?? false) {
      text = (widget.contact.tags!['name'] as String).initials();
    } else {
      setState(() {
        text = widget.contact.atSign!.initials();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return avatar ?? CircleAvatar(child: Text(text ?? ''));
  }
}
