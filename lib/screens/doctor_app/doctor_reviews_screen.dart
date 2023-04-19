import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_application/bloc/auth/auth_bloc.dart';
import 'package:medical_application/bloc/medical_bloc.dart';
import 'package:medical_application/components/review_box.dart';
import 'package:medical_application/main.dart';
import 'package:medical_application/models/constants.dart';
import 'package:medical_application/models/review.dart';
import 'package:medical_application/utill/helpers.dart';
import 'package:medical_application/utill/utillity.dart';
import 'package:rating_summary/rating_summary.dart';

class DoctorReviewsScreen extends StatefulWidget {
  const DoctorReviewsScreen({Key? key}) : super(key: key);

  @override
  State<DoctorReviewsScreen> createState() => _DoctorReviewsScreenState();
}

class _DoctorReviewsScreenState extends State<DoctorReviewsScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Constants myConstants = Constants();
    List<Review> reviews = [];
    Map<int, int> starList = {};
    int? star1 = 0;
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
            reviews = findReviewsByDoctorId(
                medicalState.reviews, authState.doctor!.id);
            starList = Utility.createStarsList(reviews);
            star1 = starList[1];
            star2 = starList[2];
            star3 = starList[3];
            star4 = starList[4];
            star5 = starList[5];
            //TODO modifica fara ? !
            total = (star1! + star2! + star3! + star4! + star5!);
            sum =
                (star1! * 1 + star2! * 2 + star3! * 3 + star4! * 4 + star5! * 5)
                    .toDouble();
            media = sum!.toDouble() / total!;

            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 0.0,
                backgroundColor: myConstants.primaryColor,
                centerTitle: true,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
                title: const Text(
                  'Reviews',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
              body: Column(
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
                  Expanded(
                    child: ListView.builder(
                      itemCount: reviews.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) =>
                          ReviewWidget(review: reviews[index]),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
