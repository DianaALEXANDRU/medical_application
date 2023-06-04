import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_application/bloc/medical_bloc.dart';
import 'package:medical_application/main.dart';
import 'doctors_ratings_chart_widget.dart';

class DoctorRatingWidget extends StatefulWidget {
  const DoctorRatingWidget({Key? key}) : super(key: key);

  @override
  State<DoctorRatingWidget> createState() => _DoctorRatingWidgetState();
}

class _DoctorRatingWidgetState extends State<DoctorRatingWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicalBloc, MedicalState>(
      bloc: getIt<MedicalBloc>(),
      builder: (context, medicalState) {
        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Container(
            height: 370,
            width: 600,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Text(
                      'Doctor`s ratings ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                    )
                  ],
                ),
                Container(
                  height: 300,
                  child: const Center(
                    child: DoctorRatingsChartWidget(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
