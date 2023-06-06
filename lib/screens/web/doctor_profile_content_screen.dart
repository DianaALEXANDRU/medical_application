import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_application/bloc/medical_bloc.dart';
import 'package:medical_application/main.dart';
import 'package:medical_application/models/constants.dart';
import 'package:medical_application/screens/web/components/edit_image_widget.dart';

import '../../models/category.dart';
import '../../models/doctor.dart';
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
  Category? dropdownValueCategory;
  String? dropdownValueAvailable = 'Available';
  var dropDownItemsTime = [
    'Available',
    'Not available',
  ];
  Category? findCategory(List<Category> allCat, String name){
    for(var cat in allCat){
      if(cat.name==name){
        return cat;
      }
    }

    return null;
  }

  var editProfilePictureMode=false;
  var editDoctorDetailsMode=false;
  var editDoctorAvailabilityMode=false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    Constants myConstants = Constants();
    return BlocBuilder<MedicalBloc, MedicalState>(
      bloc: getIt<MedicalBloc>(),
      builder: (context, medicalState) {
        nameController =
            TextEditingController(text: widget.doctor.firstName+' '+widget.doctor.lastName);
        phoneNoController=
            TextEditingController(text: widget.doctor.phoneNo);
        emailController=
            TextEditingController(text: widget.doctor.email);
        experienceController=
        TextEditingController(text: widget.doctor.experience);
        descriptionController=
        TextEditingController(text: widget.doctor.description);
        categoryController=TextEditingController(text: widget.doctor.category);
        //dropdownValueCategory=findCategory(medicalState.categories, widget.doctor.category);

        return SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomAppbar(),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Dr. ${widget.doctor.firstName} ${widget.doctor.lastName}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
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
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
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
                                          editProfilePictureMode=true;
                                        });
                                      },
                                      child: const Text(
                                        'Edit',
                                        style:
                                        TextStyle(fontSize: 16.0),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                                if(!editProfilePictureMode)
                                Container(
                                  height: 200,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      15,
                                    ),
                                  ),
                                  child: Image.network(
                                    widget.doctor.imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                if(editProfilePictureMode)
                                  EditImageWidget(
                                      onPressedCancel: (){
                                        setState(() {
                                          editProfilePictureMode=false;
                                        });
                                      },
                                      doctor: widget.doctor),
                                const SizedBox(
                                  height: 24,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'Personal info',
                                      style: TextStyle(
                                        fontSize: 22,
                                        //fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 24,
                                    ),
                                    const Text(
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
                                        color: const Color(0xff252B5C).withOpacity(0.5),
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
                                        color: const Color(0xff252B5C).withOpacity(0.5),
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
                                        color: const Color(0xff252B5C).withOpacity(0.5),
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 48,),
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
                                         // editDoctorDetailsMode=true;
                                        });
                                      },
                                      child: const Text(
                                        'Edit',
                                        style:
                                        TextStyle(fontSize: 16.0),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24.0),
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
                                    hint: Text(
                                      ' Choose a Category',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xff252B5C)
                                            .withOpacity(0.5),
                                        fontSize: 16.0,
                                      ),
                                    ),
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
                                            editDoctorDetailsMode=true;
                                          });
                                        },
                                      child: const Text(
                                        'Edit',
                                        style:
                                        TextStyle(fontSize: 16.0),
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
                                    enabled: editDoctorDetailsMode? true: false,
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
                                      hintText: ' Enter your years of experience',
                                      hintStyle: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xff252B5C).withOpacity(0.5),
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
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
                                if(editDoctorDetailsMode==true)
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
                                        color: const Color(0xff252B5C).withOpacity(0.5),
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
                                if(editDoctorDetailsMode==false)
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
                                      contentPadding: const EdgeInsets.only(top: 16.0),
                                      hintText: ' Enter a category',
                                      hintStyle: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xff252B5C).withOpacity(0.5),
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
                                    enabled: editDoctorDetailsMode? true: false,
                                    controller: descriptionController,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      fontSize: 16.0,
                                    ),
                                    maxLines: 10,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.only(top: 16.0),
                                      hintText: ' Enter a short description',
                                      hintStyle: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xff252B5C).withOpacity(0.5),
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 30.0,
                                ),
                                if(editDoctorDetailsMode==true)
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        getIt<MedicalBloc>().add(
                                          EditDoctorDetails(
                                            doctor: widget.doctor,
                                            category: dropdownValueCategory!.name,
                                            experience: experienceController.text.trim(),
                                            description: descriptionController.text.trim(),
                                          ),
                                        );
                                        setState(() {
                                          editDoctorDetailsMode=false;
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
                                          editDoctorDetailsMode=false;
                                        });
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
                    SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(24.0),
                        child: const Center(
                          child: Text(
                            'Reviews',
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(24.0),
                        child: Center(
                          child: Text(
                            'Program',
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
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
