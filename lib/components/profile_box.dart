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
          height: 70,
          width: size.width * 0.9,
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      details,
                      style: const TextStyle(
                        color: Color(0xff363636),
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
