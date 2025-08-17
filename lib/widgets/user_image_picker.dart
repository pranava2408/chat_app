import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onPickedImage});
  final void Function(File image) onPickedImage;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );

    if (pickedFile == null) {
      return; // user canceled
    }

    setState(() {
      _pickedImage = File(pickedFile.path);
    });

    // Debug print file path
    print("Picked image path: ${pickedFile.path}");

    // Pass image back to parent
    widget.onPickedImage(_pickedImage!);
  }

  @override
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
          onPressed: _pickImage,
          icon: const Icon(Icons.image),
          label: const Text(
            'Pick Image',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
