import 'package:at_contact/at_contact.dart';
import 'package:flutter/material.dart';

import '../atoms/contact_image.dart';

class ContactContent extends StatelessWidget {
  const ContactContent(this.contact, this.setState, {Key? key})
      : super(key: key);
  final AtContact contact;
  final void Function(void Function()) setState;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //* Start section
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: ContactImage(contact),
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (contact.tags?['name'].isNotEmpty ?? false)
                    Text(contact.tags!['name']),
                  Text(contact.atSign ?? ''),
                ],
              )
            ],
          ),
          //* End section
          Row(
            children: const [Icon(Icons.chevron_right_sharp)],
          ),
        ],
      ),
    );
  }
}
