import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../bloc/medical_bloc.dart';
import '../../../main.dart';
import '../../../models/doctor.dart';

class EditImageWidget extends StatefulWidget {
  final void Function() onPressedCancel;
  final Doctor doctor;

  const EditImageWidget(
      {Key? key, required this.onPressedCancel, required this.doctor})
      : super(key: key);



  @override
  State<EditImageWidget> createState() => _EditImageWidgetState();
}

class _EditImageWidgetState extends State<EditImageWidget> {

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


  @override
  Widget build(BuildContext context) {
    defaultImageUrl=widget.doctor.imageUrl;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 8.0),
        Container(
          height: 200,
          width: 200,
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
                getIt<MedicalBloc>().add(
                  EditProfilePicture(
                    doctorId: widget.doctor.id,
                    selctFile: selctFile,
                    selectedImageInBytes: selectedImageInBytes,
                  ),
                );
              },
              child: const Text('Save image'),
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
