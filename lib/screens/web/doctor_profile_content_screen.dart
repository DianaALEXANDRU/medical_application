import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_application/bloc/medical_bloc.dart';
import 'package:medical_application/main.dart';
import 'package:medical_application/screens/web/components/edit_image_widget.dart';
import 'package:medical_application/screens/web/program_tab_screen.dart';
import 'package:rating_summary/rating_summary.dart';

import '../../components/review_box.dart';
import '../../models/category.dart';
import '../../models/doctor.dart';
import '../../models/review.dart';
import '../../utill/helpers.dart';
import '../../utill/utillity.dart';
import 'components/custom_app_bar.dart';

class DoctorProfileContentScreen extends StatefulWidget {
  final Doctor doctor;

  const DoctorProfileContentScreen({Key? key, required this.doctor})
      : super(key: key);

  @override
  State<DoctorProfileContentScreen> createState() =>
      _DoctorProfileContentScreenState();
}

class _DoctorProfileContentScreenState extends State<DoctorProfileContentScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  var nameController = TextEditingController();
  var phoneNoController = TextEditingController();
  var emailController = TextEditingController();
  var experienceController = TextEditingController();
  var descriptionController = TextEditingController();
  var categoryController = TextEditingController();
  var availableController = TextEditingController();

  Category? dropdownValueCategory;
  String? dropdownValueAvailable = 'Available';
  var dropDownItemsTime = [
    'Available',
    'Not available',
  ];

  Category? findCategory(List<Category> allCat, String name) {
    for (var cat in allCat) {
      if (cat.name == name) {
        return cat;
      }
    }

    return null;
  }

  var editProfilePictureMode = false;
  var editDoctorDetailsMode = false;
  var editDoctorAvailabilityMode = false;

  var errorMessageExperience = '';
  var errorMessageCategory = '';
  var errorMessageDescription = '';

  bool isValidDoctorDetails() {
    bool isValid = true;

    if (dropdownValueCategory == null) {
      setState(() {
        errorMessageCategory = 'You should select a category';
      });
      isValid = false;
    }

    if (isNumberWithMaxTwoCharacters(experienceController.text.trim()) ==
        false) {
      setState(() {
        errorMessageExperience = 'It must be a number with max 2 characters!';
      });
      isValid = false;
    }
    if (descriptionController.text.trim().isEmpty ||
        descriptionController.text.trim().length > 500) {
      setState(() {
        errorMessageDescription =
            'You must enter a description with max. 500 characters!';
      });

      isValid = false;
    }

    return isValid;
  }

  void resetErrorMessages() {
    setState(() {
      errorMessageExperience = '';
      errorMessageCategory = '';
      errorMessageDescription = '';
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    nameController.dispose();
    phoneNoController.dispose();
    emailController.dispose();
    experienceController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    availableController.dispose();

    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return BlocBuilder<MedicalBloc, MedicalState>(
      bloc: getIt<MedicalBloc>(),
      builder: (context, medicalState) {
        nameController = TextEditingController(
            text: '${widget.doctor.firstName} ${widget.doctor.lastName}');
        phoneNoController = TextEditingController(text: widget.doctor.phoneNo);
        emailController = TextEditingController(text: widget.doctor.email);
        experienceController =
            TextEditingController(text: widget.doctor.experience);
        descriptionController =
            TextEditingController(text: widget.doctor.description);
        categoryController =
            TextEditingController(text: widget.doctor.category);
        availableController = widget.doctor.available == true
            ? TextEditingController(text: 'available')
            : TextEditingController(text: 'not available');
        reviews = findReviewsByDoctorId(medicalState.reviews, widget.doctor.id);

        starList = Utility.createStarsList(reviews);
        star1 = starList[1];
        star2 = starList[2];
        star3 = starList[3];
        star4 = starList[4];
        star5 = starList[5];

        total = (star1! + star2! + star3! + star4! + star5!);
        sum = (star1! * 1 + star2! * 2 + star3! * 3 + star4! * 4 + star5! * 5)
            .toDouble();
        media = sum!.toDouble() / total!;

        return SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        context.pop("/doctorDetails/${widget.doctor.id}");
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '     Dr. ${widget.doctor.firstName} ${widget.doctor.lastName}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: const Color.fromRGBO(247, 251, 254, 1),
                margin: const EdgeInsets.only(left: 16),
                child: TabBar(
                  controller: _tabController,
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.black,
                  tabs: const [
                    Tab(
                      text: 'Doctor Details',
                    ),
                    Tab(text: 'Reviews'),
                    Tab(text: 'Program'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(24.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'Profile picture',
                                      style: TextStyle(
                                        fontSize: 22,
                                        //fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 24,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          editProfilePictureMode = true;
                                        });
                                      },
                                      child: const Text(
                                        'Edit',
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                                if (!editProfilePictureMode)
                                  Container(
                                    height: 200,
                                    width: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        15,
                                      ),
                                    ),
                                    child: widget.doctor.imageUrl.isEmpty
                                        ? const SizedBox(
                                            height: 150,
                                            width: 150,
                                          )
                                        : Image.network(
                                            widget.doctor.imageUrl,
                                            fit: BoxFit.cover,
                                          ),
                                    ////adaug sized box
                                  ),
                                if (editProfilePictureMode)
                                  EditImageWidget(
                                      onPressedCancel: () {
                                        setState(() {
                                          editProfilePictureMode = false;
                                        });
                                      },
                                      doctor: widget.doctor),
                                const SizedBox(
                                  height: 24,
                                ),
                                Row(
                                  children: const [
                                    Text(
                                      'Personal info',
                                      style: TextStyle(
                                        fontSize: 22,
                                        //fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 24,
                                    ),
                                    Text(
                                      'Those fileds can`t be edited',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.black54,
                                        //fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24.0),
                                //name
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8.0,
                                  ),
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.person,
                                        color: Colors.blue,
                                      ),
                                      Text(
                                        ' Full name',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Color(0xff252B5C),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Container(
                                  height: 50.0,
                                  width: width * 0.30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Colors.white,
                                  ),
                                  child: TextField(
                                    enabled: false,
                                    controller: nameController,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      fontSize: 16.0,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.only(
                                        top: 16.0,
                                      ),
                                      //hintText: ' Enter your years of experience',
                                      hintStyle: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xff252B5C)
                                            .withOpacity(0.5),
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                ),
                                //email
                                const SizedBox(height: 24.0),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8.0,
                                  ),
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.email_outlined,
                                        color: Colors.blue,
                                      ),
                                      Text(
                                        ' Email',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Color(0xff252B5C),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Container(
                                  height: 50.0,
                                  width: width * 0.30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Colors.white,
                                  ),
                                  child: TextField(
                                    enabled: false,
                                    controller: emailController,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      fontSize: 16.0,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.only(
                                        top: 16.0,
                                      ),
                                      //hintText: ' Enter your years of experience',
                                      hintStyle: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xff252B5C)
                                            .withOpacity(0.5),
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                ),
                                //phone number
                                const SizedBox(height: 24.0),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8.0,
                                  ),
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.phone,
                                        color: Colors.blue,
                                      ),
                                      Text(
                                        ' Phone number',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Color(0xff252B5C),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Container(
                                  height: 50.0,
                                  width: width * 0.30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Colors.white,
                                  ),
                                  child: TextField(
                                    enabled: false,
                                    controller: phoneNoController,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      fontSize: 16.0,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.only(
                                        top: 16.0,
                                      ),
                                      //hintText: ' Enter your years of experience',
                                      hintStyle: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xff252B5C)
                                            .withOpacity(0.5),
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 48,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'Doctor availability',
                                      style: TextStyle(
                                        fontSize: 22,
                                        //fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 24,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          editDoctorAvailabilityMode = true;
                                        });
                                      },
                                      child: const Text(
                                        'Edit',
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24.0),
                                if (editDoctorAvailabilityMode == false)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Row(
                                      children: const [
                                        Icon(
                                          Icons.event_available_outlined,
                                          color: Colors.blue,
                                        ),
                                        Text(
                                          ' Availability',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: Color(0xff252B5C),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                const SizedBox(height: 6.0),
                                if (editDoctorAvailabilityMode == false)
                                  Container(
                                    height: 50.0,
                                    width: width * 0.35,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: Colors.white,
                                    ),
                                    child: TextField(
                                      enabled: false,
                                      controller: availableController,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        fontSize: 16.0,
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.only(
                                          top: 16.0,
                                        ),
                                        hintStyle: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xff252B5C)
                                              .withOpacity(0.5),
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                if (editDoctorAvailabilityMode == true)
                                  Container(
                                    height: 50.0,
                                    width: width * 0.10,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: DropdownButton<String>(
                                      value: dropdownValueAvailable,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          dropdownValueAvailable = newValue;
                                        });
                                      },
                                      iconEnabledColor: Colors.blue,
                                      isExpanded: true,
                                      items: dropDownItemsTime
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                if (editDoctorAvailabilityMode == true)
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          getIt<MedicalBloc>().add(
                                              EditDoctorAvailability(
                                                  doctorId: widget.doctor.id,
                                                  availability:
                                                      dropdownValueAvailable!));
                                          setState(() {
                                            editDoctorAvailabilityMode = false;
                                          });
                                        },
                                        child: const Text('Save'),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            editDoctorAvailabilityMode = false;
                                          });
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                    ],
                                  ),
                                const SizedBox(
                                  height: 24,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'Doctor details',
                                      style: TextStyle(
                                        fontSize: 22,
                                        //fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 24,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          editDoctorDetailsMode = true;
                                        });
                                      },
                                      child: const Text(
                                        'Edit',
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24.0),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8.0,
                                  ),
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.calendar_today,
                                        color: Colors.blue,
                                      ),
                                      Text(
                                        ' Experience',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Color(0xff252B5C),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Container(
                                  height: 50.0,
                                  width: width * 0.35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Colors.white,
                                  ),
                                  child: TextField(
                                    enabled:
                                        editDoctorDetailsMode ? true : false,
                                    controller: experienceController,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      fontSize: 16.0,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.only(
                                        top: 16.0,
                                      ),
                                      hintText:
                                          ' Enter your years of experience',
                                      hintStyle: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xff252B5C)
                                            .withOpacity(0.5),
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                ),
                                if (errorMessageExperience != '')
                                  Column(
                                    children: [
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        errorMessageExperience,
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.redAccent,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                const SizedBox(height: 30),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.control_point_duplicate,
                                        color: Colors.blue,
                                      ),
                                      Text(
                                        ' Category',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Color(0xff252B5C),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 6.0),
                                if (editDoctorDetailsMode == true)
                                  Container(
                                    height: 50.0,
                                    width: width * 0.35,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: Colors.white,
                                    ),
                                    child: DropdownButton<Category>(
                                      value: dropdownValueCategory,
                                      onChanged: (Category? newValue) {
                                        setState(() {
                                          dropdownValueCategory = newValue;
                                        });
                                      },
                                      iconEnabledColor: Colors.blue,
                                      isExpanded: true,
                                      hint: Text(
                                        ' Choose a Category',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xff252B5C)
                                              .withOpacity(0.5),
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      items: medicalState.categories
                                          .map<DropdownMenuItem<Category>>((
                                        Category value,
                                      ) {
                                        return DropdownMenuItem<Category>(
                                          value: value,
                                          child: Text(
                                            value.name,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                if (errorMessageCategory != '')
                                  Column(
                                    children: [
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        errorMessageCategory,
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.redAccent,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                if (editDoctorDetailsMode == false)
                                  Container(
                                    width: width * 0.35,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        8.0,
                                      ),
                                      color: Colors.white,
                                    ),
                                    child: TextFormField(
                                      enabled: false,
                                      controller: categoryController,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        fontSize: 16.0,
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.only(top: 16.0),
                                        hintText: ' Enter a category',
                                        hintStyle: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xff252B5C)
                                              .withOpacity(0.5),
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8.0,
                                  ),
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.short_text_sharp,
                                        color: Colors.blue,
                                      ),
                                      Text(
                                        ' Description',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Color(0xff252B5C),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 6.0),
                                Container(
                                  width: width * 0.35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      8.0,
                                    ),
                                    color: Colors.white,
                                  ),
                                  child: TextFormField(
                                    enabled:
                                        editDoctorDetailsMode ? true : false,
                                    controller: descriptionController,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      fontSize: 16.0,
                                    ),
                                    maxLines: 10,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.only(top: 16.0),
                                      hintText: ' Enter a short description',
                                      hintStyle: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xff252B5C)
                                            .withOpacity(0.5),
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                ),
                                if (errorMessageDescription != '')
                                  Column(
                                    children: [
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        errorMessageDescription,
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.redAccent,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                const SizedBox(
                                  height: 30.0,
                                ),
                                if (editDoctorDetailsMode == true)
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          if (isValidDoctorDetails() == true) {
                                            getIt<MedicalBloc>().add(
                                              EditDoctorDetails(
                                                doctor: widget.doctor,
                                                category:
                                                    dropdownValueCategory!.name,
                                                experience: experienceController
                                                    .text
                                                    .trim(),
                                                description:
                                                    descriptionController.text
                                                        .trim(),
                                              ),
                                            );
                                            setState(() {
                                              editDoctorDetailsMode = false;
                                            });
                                            resetErrorMessages();
                                          }
                                        },
                                        child: const Text('Save'),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            editDoctorDetailsMode = false;
                                          });
                                          resetErrorMessages();
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (reviews.isEmpty)
                      Center(
                          child: Text(
                              'Dr. ${widget.doctor.firstName} ${widget.doctor.lastName} has no reviews yet.')),
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
                    SingleChildScrollView(
                      child: Container(
                          padding: const EdgeInsets.all(24.0),
                          child: ProgramTabScreen(
                            doctor: widget.doctor,
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
