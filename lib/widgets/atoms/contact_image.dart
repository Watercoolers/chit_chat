import 'dart:typed_data';

import 'package:at_contact/at_contact.dart';
import 'package:flutter/material.dart';
import 'package:chit_chat/util/string_extension.dart';

class ContactImage extends StatefulWidget {
  const ContactImage(this.contact, {Key? key, this.radius}) : super(key: key);
  final AtContact contact;
  final double? radius;

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
        avatar = CircleAvatar(
          backgroundImage: Image.memory(bytes).image,
          radius: widget.radius,
        );
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
    return avatar ??
        CircleAvatar(
          child: Text(text ?? ''),
          radius: widget.radius,
        );
  }
}
