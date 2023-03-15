import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:medical_application/models/constants.dart';
import 'package:medical_application/models/doctor.dart';
import 'package:medical_application/screens/doctor_details_screen.dart';

class DoctorWidget extends StatelessWidget {
  final Size size;
  final Doctor doctor;

  const DoctorWidget({
    Key? key,
    required this.size,
    required this.doctor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DoctorDetailsScreen(doctor: doctor)),
        );
      },
      child: Container(
        height: 90,
        width: size.width * 0.9,
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: myConstants.primaryColor.withOpacity(.4),
              spreadRadius: 3,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: CachedNetworkImage(
                  width: 80,
                  height: 80,
                  imageUrl: doctor.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Text(
                      'Dr. ' + doctor.name,
                      style: const TextStyle(
                        color: Color(0xff363636),
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Text(
                          doctor.category,
                          style: const TextStyle(
                            color: Color(0xffababab),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 3,
                            left: size.width * 0.25,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              Text(
                                doctor.rating,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
