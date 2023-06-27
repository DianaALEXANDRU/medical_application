import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medical_application/bloc/medical_bloc.dart';
import 'package:medical_application/main.dart';
import 'package:medical_application/models/category.dart';

class EditCategoryWidget extends StatefulWidget {
  final void Function() onPressedCancel;
  final Category category;

  const EditCategoryWidget(
      {Key? key, required this.onPressedCancel, required this.category})
      : super(key: key);

  @override
  State<EditCategoryWidget> createState() => _EditCategoryWidgetState();
}

class _EditCategoryWidgetState extends State<EditCategoryWidget> {
  String defaultImageUrl =
      'https://firebasestorage.googleapis.com/v0/b/fluttermedicalapp-ab48a.appspot.com/o/CATEGORY%2Fdefault_category.png?alt=media&token=69d75b49-e6c5-4e83-96c1-1bf3003f9560';
  String selctFile = '';
  late XFile file;
  Uint8List? selectedImageInBytes;
  List<Uint8List> pickedImagesInBytes = [];
  List<String> imageUrls = [];
  int imageCounts = 0;

  _selectFile(bool imageFrom) async {
    FilePickerResult? fileResult = await FilePicker.platform.pickFiles();

    if (fileResult != null) {
      setState(() {
        selctFile = fileResult.files.first.name;
      });

      selectedImageInBytes = fileResult.files.first.bytes;
    }
  }

  late TextEditingController nameController = TextEditingController();
  var errorMessageForNameField='';
  bool isValid(){
    if(nameController.text.trim().length>=3 && nameController.text.trim().length<=25){
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    nameController.dispose();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    nameController = TextEditingController(text: widget.category.name);
    defaultImageUrl = widget.category.url;
    double width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: 24.0,
        ),
        const Text(
          'Edit category',
          style: TextStyle(
            fontSize: 20,
            color: Color(0xff252B5C),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 24),
          child: Row(
            children: const [
              Icon(
                Icons.drive_file_rename_outline,
                color: Colors.blue,
              ),
              Text(
                ' Name',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Color(0xff252B5C),
                ),
              ),
            ],
          ),
        ),
        Column(
          children: [
            const SizedBox(height: 8,),
            Text(
              errorMessageForNameField,
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.redAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
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
            controller: nameController,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.black,
              fontSize: 16.0,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: 16.0),
              hintText: ' Enter the name of category',
              hintStyle: TextStyle(
                fontWeight: FontWeight.w400,
                color: const Color(0xff252B5C).withOpacity(0.5),
                fontSize: 16.0,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 24),
          child: Row(
            children: const [
              Icon(
                Icons.image,
                color: Colors.blue,
              ),
              Text(
                ' Image',
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
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              15,
            ),
          ),
          child: selctFile.isEmpty
              ? Image.network(
                  defaultImageUrl,
                  fit: BoxFit.cover,
                )
              : Image.memory(
                  selectedImageInBytes!,
                  fit: BoxFit.fill,
                ),
        ),
        const SizedBox(
          height: 24.0,
        ),
        ElevatedButton(
          onPressed: () {
            _selectFile(true);
          },
          child: const Text('Select Image'),
        ),
        const SizedBox(
          height: 48,
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                if(isValid()){
                  getIt<MedicalBloc>().add(
                    EditCategory(
                      name: nameController.text.trim(),
                      selctFile: selctFile,
                      selectedImageInBytes: selectedImageInBytes,
                      category: widget.category,
                    ),
                  );
                }else{
                  setState(() {
                    errorMessageForNameField='The entered name must contain between 3 and 25 characters!';
                  });
                }

              },
              child: const Text('Edit Category'),
            ),
            const SizedBox(
              width: 8,
            ),
            ElevatedButton(
              onPressed: () {
                widget.onPressedCancel.call();
              },
              child: const Text('Cancel'),
            ),
          ],
        ),
      ],
    );
  }
}
