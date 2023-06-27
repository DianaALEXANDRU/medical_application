import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_application/bloc/auth/auth_bloc.dart';
import 'package:medical_application/bloc/medical_bloc.dart';
import 'package:medical_application/models/appointment.dart';
import 'package:medical_application/repositories/firestore/auth_repository.dart';
import 'package:medical_application/repositories/rest/medical_repository.dart';
import 'package:medical_application/screens/book_appointment_screen.dart';
import 'package:medical_application/screens/confirm_ap_screen.dart';
import 'package:medical_application/screens/doctor_app/doctor_profile_screen.dart';
import 'package:medical_application/screens/doctor_app/doctor_reviews_screen.dart';
import 'package:medical_application/screens/doctor_app/home.dart';
import 'package:medical_application/screens/doctor_app/my_appointments_screen.dart';
import 'package:medical_application/screens/doctor_app/profile_screen.dart';
import 'package:medical_application/screens/doctor_app/program.dart';
import 'package:medical_application/screens/doctor_details_screen.dart';
import 'package:medical_application/screens/doctors_screen.dart';
import 'package:medical_application/screens/forgot_password_screen.dart';
import 'package:medical_application/screens/home_screen.dart';
import 'package:medical_application/screens/login_screen.dart';
import 'package:medical_application/screens/main_page.dart';
import 'package:medical_application/screens/my_appointment_screen.dart';
import 'package:medical_application/screens/profile_screen.dart';
import 'package:medical_application/screens/register_screen.dart';
import 'package:medical_application/screens/web/add_doctor_screen.dart';
import 'package:medical_application/screens/web/appointments_screen.dart';
import 'package:medical_application/screens/web/category_screen.dart';
import 'package:medical_application/screens/web/dashboard_screen.dart';
import 'package:medical_application/screens/web/doctor_profile_screen.dart';
import 'package:medical_application/screens/web/doctors_screen.dart';
import 'package:medical_application/screens/web/forgot_password_screen.dart';
import 'package:medical_application/screens/web/login_web_screen.dart';
import 'package:medical_application/screens/web/main_web_screen.dart';
import 'package:medical_application/screens/web/users_screen.dart';

import 'firebase_options.dart';
import 'package:flutter/foundation.dart' show kIsWeb;



final GetIt getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final MedicalBloc _medicalBloc;
  late final AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();

    var medicalRepository = MedicalRestRepository();
    _medicalBloc = MedicalBloc(medicalRepository: medicalRepository);
    getIt.registerSingleton(_medicalBloc);

    _medicalBloc.add(const FetchDoctors());
    _medicalBloc.add(const FetchCategories());
    _medicalBloc.add(const FetchAllAppointments());
    _medicalBloc.add(const FetchUsers());
    _medicalBloc.add(const FetchReviews());

    var authRepository = AuthRepositoryFirestore();
    _authBloc = AuthBloc(authRepository: authRepository);
    getIt.registerSingleton(_authBloc);
  }

  @override
  void dispose() {
    getIt.unregister(instance: _medicalBloc);
    getIt.unregister(instance: _authBloc);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return MaterialApp.router(
      title: 'Medical App Diana',
      debugShowCheckedModeBanner: false,
      routerConfig: kIsWeb ? _routerForWeb : _routerForMobile,
    );
  }
}

final GoRouter _routerForWeb = GoRouter(
  routes: [

    GoRoute(
      path: "/",
      builder: (context, state) => const MainWebScreen(),
    ),
    GoRoute(
      path: "/loginWeb",
      builder: (context, state) => const LoginWebScreen(),
    ),
    GoRoute(
      path: "/resetPasswordWeb",
      builder: (context, state) => const ForgotPasswordWebScreen(),
    ),
    GoRoute(
      path: "/dashboard",
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: "/category",
      builder: (context, state) => const CategoryScreen(),
    ),
    GoRoute(
        path: "/doctors",
        builder: (context, state) => const DoctorsScreen(),
        routes: [
          GoRoute(
            path: "addDoctor",
            builder: (context, state) => const AddDoctorScreen(),
          ),
          GoRoute(
            path: 'doctorDetails/:doctor',
            builder: (context, state) {
              return DoctorProfileWebScreen(
                doctorId: state.pathParameters['doctor']!,
              );
            },
          ),
        ]),
    GoRoute(
      path: "/users",
      builder: (context, state) => const UsersScreen(),
    ),
    GoRoute(
      path: "/appointments",
      builder: (context, state) => const AppointmentsScreen(),
    ),

  ],
);
final GoRouter _routerForMobile = GoRouter(
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const MainPage(),
    ),
    GoRoute(
      path: "/login",
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: "/register",
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: "/resetPassword",
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: "/patientHome",
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: "doctors/:category",
          builder: (context, state) =>
              DoctorScreen(category: state.pathParameters['category']!),
          routes: [
            GoRoute(
              path: "doctorDetails/:doctorId",
              builder: (context, state) => DoctorDetailsScreen(
                  doctorId: state.pathParameters['doctorId']!),
              routes: [
                GoRoute(
                  path: "bookAppointment",
                  builder: (context, state) =>  BookAppointmentScreen(doctorId: state.pathParameters['doctorId']!),
                  routes: [
                    GoRoute(
                      path: "confirmAppointment",
                      builder: (context, confirmState) =>  ConfirmAppScreen(app: confirmState.extra! as Appointment),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: "myAppointments",
          builder: (context, state) => const MyAppointmentsScreen(),
        ),
        GoRoute(
          path: "myProfile",
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
    GoRoute(
        path: "/doctorHome",
        builder: (context, state) => const DoctorHome(),
        routes: [
          GoRoute(
            path: "program",
            builder: (context, state) => const DoctorProgramScreen(),
          ),
          GoRoute(
            path: "appointments",
            builder: (context, state) => const MyAppointmentsDoctor(),
          ),
          GoRoute(
            path: "reviews",
            builder: (context, state) => const DoctorReviewsScreen(),
          ),
          GoRoute(
            path: "myDoctorDetails",
            builder: (context, state) => const DoctorProfileScreen(),
          ),
          GoRoute(
            path: "myProfile",
            builder: (context, state) => const ProfileForDoctorScreen(),
          ),
        ]),
  ],
);
