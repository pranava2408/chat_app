import 'package:chat_app/widgets/custom_buttom.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/widgets/user_image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart'; // Add this

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignupScreen extends StatefulWidget { // Changed to StatefulWidget
  SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  File? _pickedImage;
  bool _isLoading = false; // Added loading state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: const Color.fromARGB(255, 90, 199, 219),
      ),
      backgroundColor: const Color.fromARGB(255, 159, 134, 228),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  UserImagePicker(
                    onPickedImage: (image) => _pickedImage = image,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email';
                      }
                      final emailRegExp = RegExp(
                        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                      );
                      if (!emailRegExp.hasMatch(value.trim())) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.trim().length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: confirmPasswordController,
                    decoration:
                        const InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value.trim() != passwordController.text.trim()) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : CustomButtom(
                            text: 'Sign Up',
                            onPressed: () async {
                              if (_formKey.currentState!.validate() && !_isLoading) {
                                setState(() => _isLoading = true);
                                
                                try {
                                  // Create user
                                  final userCredential = await _auth.createUserWithEmailAndPassword(
                                    email: emailController.text.trim(),
                                    password: passwordController.text,
                                  );
                                  
                                  // Upload image if exists
                                  if (_pickedImage != null) {
                                    try {
                                      print('Picked image: ${_pickedImage!.path}');
                                      
                                      // FIXED: Use the correct reference format
                                      final storageRef = FirebaseStorage.instance
                                          .ref('user_images/${userCredential.user!.uid}.jpg');
                                      
                                      // Upload with proper error handling
                                      final uploadTask = storageRef.putFile(_pickedImage!);
                                      final snapshot = await uploadTask;
                                      
                                      // Verify upload completed
                                      if (snapshot.state == TaskState.success) {
                                        final imageUrl = await storageRef.getDownloadURL();
                                        print('Image uploaded: $imageUrl');
                                      } else {
                                        print('Upload failed: ${snapshot.state}');
                                        throw FirebaseException(
                                          plugin: 'storage',
                                          code: 'upload-failed',
                                          message: 'Upload did not complete'
                                        );
                                      }
                                    } catch (storageError) {
                                      print('Image upload error: $storageError');
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Failed to upload profile image'),
                                        ),
                                      );
                                    }
                                  }
                                  
                                  // Navigate to home screen
                                  // Navigator.pushReplacement(context, MaterialPageRoute(...));
                                  
                                } on FirebaseAuthException catch (e) {
                                  print('Auth error: ${e.code} - ${e.message}');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(e.message ?? 'Authentication failed'),
                                    ),
                                  );
                                } catch (e) {
                                  print('General error: $e');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('An unexpected error occurred'),
                                    ),
                                  );
                                } finally {
                                  setState(() => _isLoading = false);
                                }
                              }
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}