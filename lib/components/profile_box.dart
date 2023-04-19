import 'package:flutter/material.dart';

class ProfileDetailsWidget extends StatelessWidget {
  final Size size;
  final String field;
  final String details;

  const ProfileDetailsWidget({
    Key? key,
    required this.size,
    required this.field,
    required this.details,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final detailsController = TextEditingController(text: details);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field,
          style: const TextStyle(
            color: Color(0xff363636),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        Container(
          height: 60,
          width: size.width * 0.9,
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          // child:
          child: TextField(
            enabled: false,
            controller: detailsController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter a search term',
            ),
          ),
        ),
      ],
    );
  }
}
