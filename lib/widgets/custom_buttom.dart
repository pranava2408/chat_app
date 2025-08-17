import 'package:flutter/material.dart';

class CustomButtom extends StatelessWidget{
  final String text;
  final VoidCallback onPressed;

  const CustomButtom({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 92, 238, 138),
        shape: RoundedRectangleBorder(
          // borderRadius: BorderRadius.(20),
        ),
      ),
      child: Text(text,
      style: TextStyle(
        fontSize: 18,
        color: Colors.white,
        // fontWeight: FontWeight.bold,  
      ),),
    );
  }
}