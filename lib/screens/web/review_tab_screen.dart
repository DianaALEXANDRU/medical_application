import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rating_summary/rating_summary.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/medical_bloc.dart';
import '../../components/review_box.dart';
import '../../main.dart';
import '../../models/doctor.dart';
import '../../models/review.dart';
import '../../utill/helpers.dart';
import '../../utill/utillity.dart';

class ReviewTabScreen extends StatefulWidget {
  final String doctorId;

  const ReviewTabScreen({
    Key? key,
    required this.doctorId,
  }) : super(key: key);

  @override
  State<ReviewTabScreen> createState() => _ReviewTabScreenState();
}

class _ReviewTabScreenState extends State<ReviewTabScreen> {

  Doctor doctor = const Doctor(
      id: '',
      firstName: '',
      lastName: '',
      phoneNo: '',
      role: '',
      email: '',
      description: '',
      experience: '',
      imageUrl: '',
      category: '',
      available: true);


  @override
  Widget build(BuildContext context) {

    List<Review> reviews = [];
    Map<int, int> starList = {};
    int? star1; //!
    int? star2;
    int? star3;
    int? star4;
    int? star5;
    double? media;
    int? total;
    double? sum;
    return BlocBuilder<AuthBloc, AuthState>(
      bloc: getIt<AuthBloc>(),
      builder: (context, authState) {
        return BlocBuilder<MedicalBloc, MedicalState>(
          bloc: getIt<MedicalBloc>(),
          builder: (context, medicalState) {
            reviews =
                findReviewsByDoctorId(medicalState.reviews, widget.doctorId);
            doctor = findDoctor(medicalState.doctors, widget.doctorId)!;
            starList = Utility.createStarsList(reviews);
            star1 = starList[1];
            star2 = starList[2];
            star3 = starList[3];
            star4 = starList[4];
            star5 = starList[5];
            total = (star1! + star2! + star3! + star4! + star5!);
            sum =
                (star1! * 1 + star2! * 2 + star3! * 3 + star4! * 4 + star5! * 5)
                    .toDouble();
            media = sum!.toDouble() / total!;

            return Column(
              children: [
                const SizedBox(
                  height: 32,
                ),
                if (reviews.isNotEmpty)
                  Column(
                    children: [
                      RatingSummary(
                        counter: total!,
                        average: media!,
                        showAverage: true,
                        counterFiveStars: star5!,
                        counterFourStars: star4!,
                        counterThreeStars: star3!,
                        counterTwoStars: star2!,
                        counterOneStars: star1!,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Divider(
                        height: 48,
                        thickness: 3,
                      ),
                    ],
                  ),
                ListView.builder(
                  itemCount: reviews.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) =>
                      ReviewWidget(review: reviews[index]),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
