import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';
import 'package:medical_application/bloc/auth/auth_bloc.dart';
import 'package:medical_application/bloc/medical_bloc.dart';
import 'package:medical_application/repositories/firestore/auth_repository.dart';
import 'package:medical_application/repositories/rest/medical_repository.dart';
import 'package:medical_application/screens/main_page.dart';
import 'package:medical_application/screens/web/add_doctor_screen.dart';
import 'package:medical_application/screens/web/appointments_screen.dart';
import 'package:medical_application/screens/web/category_screen.dart';
import 'package:medical_application/screens/web/dashboard_screen.dart';
import 'package:medical_application/screens/web/doctors_screen.dart';
import 'package:medical_application/screens/web/users_screen.dart';
import 'package:provider/provider.dart';

import 'controllers/controller.dart';
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

    //FirebaseAuth.instance.signOut();
    var medicalRepository = MedicalRestRepository();
    _medicalBloc = MedicalBloc(medicalRepository: medicalRepository);
    getIt.registerSingleton(_medicalBloc);

    _medicalBloc.add(const FetchDoctors());
    _medicalBloc.add(const FetchCategories());
    _medicalBloc.add(const FetchAllAppointments());
    _medicalBloc.add(const FetchUsers());

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
    return MaterialApp(
      title: 'Medical App Diana',
      debugShowCheckedModeBanner: false,
      home: kIsWeb
          ? MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (context) => Controller(),
                )
              ],
              child: const AddDoctorScreen(),
            )
          : const MainPage(),
    );
  }
}
