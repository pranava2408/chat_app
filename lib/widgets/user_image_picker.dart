import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onPickedImage});
  final void Function(File image) onPickedImage;
  State<UserImagePicker> createState() {
    return _UserImagePickerState();
  }
}

class _UserImagePickerState extends State<UserImagePicker> {
  @override
  File? _pickedImage;
  void _pickImage() async {
    // Implement image picking logic here
    // For example, using image_picker package
    final pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 150);
    setState(() {
      _pickedImage = File(pickedFile!.path);
    });
    widget.onPickedImage(
        _pickedImage!); // Notify parent widget with the picked image
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage:
              _pickedImage == null ? null : FileImage(_pickedImage!),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () {
            _pickImage(); // Call the method to pick an image
            // Implement image picking logic here
          },
          icon: const Icon(Icons.image),
          label: const Text(
            'Pick Image',
            style: TextStyle(
              fontSize: 16, // Use the primary color from the current theme
            ),
          ),
          // style: ElevatedButton.styleFrom(
          //   primary: Colors.deepPurple, // Button color
          // ),
        ),
      ],
    );
  }
}
