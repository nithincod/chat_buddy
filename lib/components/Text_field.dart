import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({super.key, required this.hinttext, required this.unknowntext,required this.controller});

  final TextEditingController controller;
  final String hinttext;
  final bool unknowntext;



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(

        controller: controller,

        obscureText: unknowntext,

        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.circular(10)
          ),

          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue)
          ),

          fillColor:  Colors.white54,
          filled: true,
          hintText: hinttext,
          hintStyle: TextStyle(color: Colors.black87,
          fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
