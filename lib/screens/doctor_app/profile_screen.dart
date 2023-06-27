import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_application/bloc/auth/auth_bloc.dart';
import 'package:medical_application/bloc/medical_bloc.dart';
import 'package:medical_application/main.dart';
import 'package:medical_application/models/constants.dart';

class ProfileForDoctorScreen extends StatefulWidget {
  const ProfileForDoctorScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileForDoctorScreen> createState() => _ProfileForDoctorScreenState();
}

class _ProfileForDoctorScreenState extends State<ProfileForDoctorScreen> {

  var editDetailsMode = false;


  var errorMessageForLastName = '';
  var errorMessageForFirstName = '';
  var errorMessageForPhoneNo = '';

  bool isValid() {
    bool isValid = true;

    if (firstNameIntermediarController.text.trim().length < 2 ||
        firstNameIntermediarController.text.trim().length > 30) {

      setState((){
        errorMessageForFirstName =
        'First Name must be between 2 and 30 characters!';
      });

      isValid= false;

    }

    if (lastNameIntermediarController.text.trim().length < 2 ||
        lastNameIntermediarController.text.trim().length > 30) {
      setState((){
        errorMessageForLastName =
        'Last Name must be between 2 and 30 characters!';
      });

      isValid= false;

    }

    if (phoneNoIntermediarController.text.trim().length < 8 ||
        phoneNoIntermediarController.text.trim().length > 30) {
      setState((){
        errorMessageForPhoneNo = 'Phone No must be between 8 and 30 characters!';
      });

      isValid= false;

    }

    return isValid;
  }

  void resetErrorMessages(){
    setState(() {
      errorMessageForLastName = '';
      errorMessageForFirstName = '';
      errorMessageForPhoneNo = '';

    });
  }

  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var phoneNoController = TextEditingController();

  var firstNameIntermediarController = TextEditingController();
  var lastNameIntermediarController = TextEditingController();
  var phoneNoIntermediarController = TextEditingController();


  var firstName='';
  var lastName='';
  var phoneNo='';

  @override
  void dispose() {
     firstNameController.dispose();
     lastNameController.dispose();
     phoneNoController.dispose();
     firstNameIntermediarController.dispose();
     lastNameIntermediarController.dispose();
     phoneNoIntermediarController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Constants myConstants = Constants();

    return BlocBuilder<AuthBloc, AuthState>(
      bloc: getIt<AuthBloc>(),
      builder: (context, authState) {

        firstNameController =
            TextEditingController(text: authState.user!.firstName);
        lastNameController =
            TextEditingController(text: authState.user!.lastName);
        phoneNoController =
            TextEditingController(text: authState.user!.phoneNo);

        firstNameIntermediarController =
            TextEditingController(text: firstName);
        lastNameIntermediarController =
            TextEditingController(text: lastName);
        phoneNoIntermediarController =
            TextEditingController(text: phoneNo);

        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: myConstants.contrastColor,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                context.go("/doctorHome");

              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    if(editDetailsMode==false){
                      editDetailsMode = true;
                    }else{
                      editDetailsMode = false;
                      resetErrorMessages();
                    }

                    firstName= authState.user!.firstName;
                    lastName=authState.user!.lastName;
                    phoneNo= authState.user!.phoneNo;
                  });
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
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
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
                              imageUrl: authState.doctor!.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          if (editDetailsMode==true)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: size.width * 0.9,
                                  margin: const EdgeInsets.only(top: 10),
                                  child: const Text(
                                    'Edit the details that you want and then press "save details".',
                                    style: TextStyle(
                                      color: Color(0xff363636),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'First Name',
                                style: TextStyle(
                                  color: Color(0xff363636),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Container(
                                height: 60,
                                width: size.width * 0.9,
                                margin: const EdgeInsets.only(top: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                // child:
                                child: TextField(
                                  enabled:  editDetailsMode ? true : false,
                                  controller: editDetailsMode ? firstNameIntermediarController : firstNameController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Enter your first name',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if(errorMessageForFirstName!='')
                            Column(
                              children: [
                                Text(
                                  errorMessageForFirstName,
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Last Name',
                                style: TextStyle(
                                  color: Color(0xff363636),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Container(
                                height: 60,
                                width: size.width * 0.9,
                                margin: const EdgeInsets.only(top: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                // child:
                                child: TextField(
                                  enabled:  editDetailsMode ? true : false,
                                  controller:editDetailsMode ? lastNameIntermediarController: lastNameController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Enter your last name',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if(errorMessageForLastName!='')
                            Column(
                              children: [
                                Text(
                                  errorMessageForLastName,
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Phone Number',
                                style: TextStyle(
                                  color: Color(0xff363636),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Container(
                                height: 60,
                                width: size.width * 0.9,
                                margin: const EdgeInsets.only(top: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                // child:
                                child: TextField(
                                  enabled:  editDetailsMode ? true : false,
                                  controller: editDetailsMode ? phoneNoIntermediarController: phoneNoController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Enter your phone number',
                                  ),

                                ),
                              ),
                            ],
                          ),
                          if(errorMessageForPhoneNo!='')
                            Column(
                              children: [
                                Text(
                                  errorMessageForPhoneNo,
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(
                            height: 40,
                          ),

                          if (editDetailsMode == true)
                            InkWell(
                              onTap: () {
                                setState(() {
                                  firstName= firstNameIntermediarController.text.trim();
                                  lastName= lastNameIntermediarController.text.trim();
                                  phoneNo= phoneNoIntermediarController.text.trim();
                                });
                                if(isValid()){
                                  getIt<MedicalBloc>().add(
                                    EditUserDetails(
                                      userId: authState.user!.id,
                                      firstName: firstNameIntermediarController.text.trim(),
                                      lastName: lastNameIntermediarController.text.trim(),
                                      phoneNo: phoneNoIntermediarController.text.trim(),
                                    ),
                                  );
                                  getIt<AuthBloc>().add(const FetchUser());
                                  setState(() {
                                    editDetailsMode = false;
                                  });
                                  resetErrorMessages();
                                }

                              },
                              child: Ink(
                                decoration: BoxDecoration(
                                  color: myConstants.primaryColor,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Container(
                                  width: size.width * 0.9,
                                  height: 60,
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Save details',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
