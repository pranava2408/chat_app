import 'package:chat_app/widgets/custom_buttom.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/widgets/user_image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:chat_app/screens/chat_screen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignupScreen extends StatefulWidget {
  SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  File? _pickedImage;
  bool _isLoading = false;

  // Function to handle the signup logic
  void _submit() async {
    // Validate all form fields
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return; // If validation fails, do nothing
    }

    // Check if an image was picked
    if (_pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please pick an image.'),
          backgroundColor: Colors.red,
        ),
      );
      return; // Stop if no image is selected
    }

    // Save the form state
    _formKey.currentState!.save();

    try {
      setState(() {
        _isLoading = true; // Show loading indicator
      });

      // 1. Create user with email and password
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = userCredential.user;
      if (user == null) {
        // This should not happen if creation is successful, but it's good practice to check
        throw Exception('User creation failed, please try again.');
      }

      // 2. Upload the profile image to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('${user.uid}.jpg'); // Use user's UID for the image name

// currently commenting out the upload to Firebase Storage
//       await storageRef.putFile(_pickedImage!);

      // 3. Get the download URL of the uploaded image
      // final imageUrl = await storageRef.getDownloadURL();

      // 4. Save user data to Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'email': emailController.text.trim(),
        // we need the firebase storage upload to work
        // 'image_url': imageUrl,
        'username': usernameController.text.trim(),
        // 'created_at': Timestamp.now(),
        // You can add more user data here, like a username
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(), // Navigate to chat screen
        ),
      );

      // Optionally, navigate to another screen after successful signup
      // if (mounted) Navigator.of(context).pushReplacement(...);
    } on FirebaseAuthException catch (e) {
      // Handle authentication errors
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Authentication failed.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } catch (error) {
      // Handle other errors (like storage or firestore)
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: const Color.fromARGB(255, 90, 199, 219),
      ),
      backgroundColor: const Color.fromARGB(255, 159, 134, 228),
      body: Center(
        child: SingleChildScrollView(
          // Added to prevent overflow on small screens
          child: Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    UserImagePicker(
                      onPickedImage: (image) {
                        _pickedImage = image;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            !value.contains('@')) {
                          return 'Please enter a valid email address.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: usernameController,
                      decoration: const InputDecoration(labelText: 'Username'),
                      enableSuggestions: false,
                      validator: (value) {
                        if (value == null || value.trim().length < 4) {
                          return 'Please enter a username having a length greater than 3.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.trim().length < 8) {
                          return 'Password must be at least 8 characters long.';
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
                        if (value != passwordController.text) {
                          return 'Passwords do not match.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    if (_isLoading)
                      const CircularProgressIndicator()
                    else
                      CustomButtom(
                        text: 'Sign Up',
                        onPressed: _submit, // Call the submit function
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
