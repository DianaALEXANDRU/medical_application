import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:medical_application/models/category.dart';
import 'package:medical_application/models/constants.dart';
import 'package:medical_application/screens/doctors_screen.dart';

class CategoryWidget extends StatelessWidget {
  final Category category;

  const CategoryWidget({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DoctorScreen(
                    category: category.name,
                  )),
        );
      },
      child: Container(
        width: 100,
        height: 100,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          color: myConstants.primaryColor,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CachedNetworkImage(
              width: 50,
              height: 50,
              imageUrl: category.url,
              fit: BoxFit.cover,
            ),
            Container(
              margin: const EdgeInsets.only(top: 8),
              child: Text(
                category.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
