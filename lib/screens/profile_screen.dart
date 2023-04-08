import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_application/bloc/auth/auth_bloc.dart';
import 'package:medical_application/components/profile_box.dart';
import 'package:medical_application/main.dart';
import 'package:medical_application/models/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Constants myConstants = Constants();

    return BlocBuilder<AuthBloc, AuthState>(
      bloc: getIt<AuthBloc>(),
      builder: (context, authState) {
        return SizedBox(
          height: size.height,
          width: size.width,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: myConstants.contrastColor,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
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
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                ),
              ],
              title: const Text(
                'My Profile',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            body: Column(
              children: [
                SizedBox(
                  width: size.width,
                  child: Stack(
                    children: <Widget>[
                      SizedBox(
                        width: size.width,
                        height: size.height * 0.25,
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
                              height: 110,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6.0),
                              child: CachedNetworkImage(
                                width: size.width / 3,
                                height: size.height / 6,
                                imageUrl:
                                    'https://img.freepik.com/free-photo/portrait-disappointed-doctor-woman-medical-worker-pointing-fingers-right-looking-sad-regret-g_1258-86069.jpg?w=1380&t=st=1675766288~exp=1675766888~hmac=56d510a843bbda5123f82acc8069425a60d8b42283b78755150d0fae4cb0ba11',
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            ProfileDetailsWidget(
                              size: size,
                              field: 'First Name:',
                              details: authState.user!.firstName,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ProfileDetailsWidget(
                              size: size,
                              field: 'Last Name:',
                              details: authState.user!.lastName,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ProfileDetailsWidget(
                              size: size,
                              field: 'Mobile Number',
                              details: authState.user!.phoneNo,
                            ),
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
      },
    );
  }
}
