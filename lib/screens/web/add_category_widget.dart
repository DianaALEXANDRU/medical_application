import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medical_application/bloc/medical_bloc.dart';
import 'package:medical_application/main.dart';

class AddCategoryWidget extends StatefulWidget {
  final void Function() onPressed;

  const AddCategoryWidget({Key? key, required this.onPressed})
      : super(key: key);

  @override
  State<AddCategoryWidget> createState() => _AddCategoryWidgetState();
}

class _AddCategoryWidgetState extends State<AddCategoryWidget> {
  String defaultImageUrl =
      'https://firebasestorage.googleapis.com/v0/b/fluttermedicalapp-ab48a.appspot.com/o/CATEGORY%2Fdefault_category.png?alt=media&token=69d75b49-e6c5-4e83-96c1-1bf3003f9560';
  String selctFile = '';
  late XFile file;
  late Uint8List? selectedImageInBytes;
  List<Uint8List> pickedImagesInBytes = [];
  List<String> imageUrls = [];

  _selectFile(bool imageFrom) async {
    FilePickerResult? fileResult = await FilePicker.platform.pickFiles();

    if (fileResult != null) {
      setState(() {
        selctFile = fileResult.files.first.name;
      });

      selectedImageInBytes = fileResult.files.first.bytes;
    }
    print(selctFile);
  }

  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: 24.0,
        ),
        const Text(
          ' Add a new Category',
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
          padding: const EdgeInsets.only(
            left: 8.0,
            top: 24,
          ),
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
        const SizedBox(
          height: 8.0,
        ),
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
          child: const Text(
            'Select Image',
          ),
        ),
        const SizedBox(
          height: 48,
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                getIt<MedicalBloc>().add(
                  AddCategory(
                    name: nameController.text.trim(),
                    selctFile: selctFile,
                    selectedImageInBytes: selectedImageInBytes,
                  ),
                );
              },
              child: const Text(
                'Add Category',
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            ElevatedButton(
              onPressed: () {
                widget.onPressed.call();
              },
              child: const Text(
                'Cancel',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
