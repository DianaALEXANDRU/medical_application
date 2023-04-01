import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';
import 'package:medical_application/bloc/auth/auth_bloc.dart';
import 'package:medical_application/bloc/medical_bloc.dart';
import 'package:medical_application/repositories/firestore/auth_repository.dart';
import 'package:medical_application/repositories/rest/medical_repository.dart';
import 'package:medical_application/screens/main_page.dart';

import 'firebase_options.dart';

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
    return const MaterialApp(
      title: 'Medical App Diana',
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}
