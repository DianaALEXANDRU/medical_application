import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_application/bloc/auth/auth_bloc.dart';
import 'package:medical_application/bloc/medical_bloc.dart';
import 'package:medical_application/components/review_box.dart';
import 'package:medical_application/main.dart';
import 'package:medical_application/models/constants.dart';
import 'package:medical_application/models/doctor.dart';
import 'package:medical_application/models/review.dart';
import 'package:medical_application/utill/helpers.dart';
import 'package:medical_application/utill/utillity.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:rating_summary/rating_summary.dart';

class DoctorDetailsScreen extends StatefulWidget {
  final String doctorId;

  const DoctorDetailsScreen({
    Key? key,
    required this.doctorId,
  }) : super(key: key);

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
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
    Size size = MediaQuery.of(context).size;
    Constants myConstants = Constants();
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

            return SizedBox(
              height: size.height,
              width: size.width,
              child: DefaultTabController(
                length: 2,
                child: Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    elevation: 0.0,
                    backgroundColor: Colors.white,
                    centerTitle: true,
                    leading: IconButton(
                      onPressed: () {
                        context.pop("/doctorDetails/${widget.doctorId}");
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),
                    title: Text(
                      '${doctor.firstName} ${doctor.lastName}',
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    bottom: const TabBar(
                      indicatorColor: Color(0xff38B6FF),
                      indicatorWeight: 5,
                      labelColor: Colors.black,
                      tabs: [
                        Tab(
                          text: 'About',
                        ),
                        Tab(
                          text: 'Reviews',
                        )
                      ],
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            width: size.width,
                            // height: size.height * 0.50,
                            child: Stack(
                              children: <Widget>[
                                SizedBox(
                                  width: size.width,
                                  height: size.height * 0.16,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: myConstants.linearGradientBlue,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 55,
                                      ),
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                        child: CachedNetworkImage(
                                          width: size.width / 2.5,
                                          height: size.height / 5,
                                          imageUrl: doctor.imageUrl,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 60,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(
                                  '${doctor.category} Specialist',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 50,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(
                                  'About ${doctor.firstName} ${doctor.lastName}',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                width: size.width,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                  ),
                                  child: Text(
                                    doctor.description,
                                    softWrap: true,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Text(
                                      'Experience',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black45,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                    Text(
                                      '${doctor.experience} Years',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          SizedBox(
                            width: size.width,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 20,
                                left: 20,
                                right: 20,
                                bottom: 16,
                              ),
                              child: InkWell(
                                onTap: () {
                                  context.go(
                                      '${GoRouter.of(context).location}/bookAppointment');
                                },
                                child: Ink(
                                  decoration: BoxDecoration(
                                    color: myConstants.primaryColor,
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Container(
                                    width: size.width * 0.9,
                                    height: 50,
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'Book an appointment',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const SizedBox(
                            height: 24,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: size.width,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    //top: 20,
                                    left: 20,
                                    right: 20,
                                    // bottom: 20
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      if (hasAppointmentConfirmedBefore(
                                          medicalState.appointments,
                                          doctor.id)) {
                                        final dialog = RatingDialog(
                                          initialRating: 5.0,
                                          title: Text(
                                            'Evaluates the services of Dr.${doctor.firstName}${doctor.lastName}',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          message: const Text(
                                            'Tap a star to set your rating. Add more description here if you want.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          submitButtonText: 'Submit',
                                          commentHint:
                                              'Write something about your experience',
                                          onSubmitted: (response) {
                                            if (authState.user?.id != null) {
                                              getIt<MedicalBloc>().add(
                                                  AddReview(
                                                      stars: response.rating.toInt(),
                                                      comment: response.comment,
                                                      doctorId: doctor.id,
                                                      userId:authState.user!.id ));
                                            }
                                          },
                                        );

                                        showDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (context) => dialog,
                                        );
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return const AlertDialog(
                                              content: Text(
                                                  "If you don't have a confirmed appointment for this doctor in the past you can't add a review."),
                                            );
                                          },
                                        );
                                      }
                                    },
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        color: myConstants.primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      child: Container(
                                        width: size.width * 0.9,
                                        height: 50,
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'Add a review',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (reviews.isNotEmpty)
                            Column(
                              children: [
                                const Divider(
                                  height: 48,
                                  thickness: 3,
                                ),
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
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
