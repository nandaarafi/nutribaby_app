// import 'package:airplane/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:nutribaby_app/core/constants/colors.dart';
import 'package:nutribaby_app/core/helper/helper_functions.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class CustomTextFormFieldSuffix extends StatefulWidget {
  final String title;
  final String hintText;
  final double widthSuffix;
  final Icon? icon;
  final bool obsecureText;
  final VoidCallback? onTap;
  final TextEditingController controller;
  final String suffixText;

  const CustomTextFormFieldSuffix({
    Key? key,
    required this.title,
    required this.hintText,
    required this.widthSuffix,
    this.onTap,
    this.icon,
    required this.suffixText,
    this.obsecureText = false,
    required this.controller,
  }) : super(key: key);

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormFieldSuffix> {


  @override
  Widget build(BuildContext context) {
    // return Container(
    //   margin: const EdgeInsets.only(bottom: 20),
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(
          height: 6,
          // width: 5,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          // width: 100,
          decoration: BoxDecoration(
              border: Border.all(color: NColors.primary),
              borderRadius: BorderRadius.circular(17)
          ),
          child: Row(
            children: [
              Container(
                width:widget.widthSuffix,
                child: TextField(
                  // maxLines: null,
                  textAlign: TextAlign.start,
                  autofocus: false,
                  onTap: widget.onTap,
                  controller: widget.controller,
                  // onSubmitted: (_) => FocusScope.of(context).unfocus(),
                  cursorColor: Colors.black,
                  obscureText: widget.obsecureText,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      suffixText: widget.suffixText
                  ),
                  // decoration: InputDecoration(
                  //   contentPadding: const EdgeInsets.symmetric(
                  //     horizontal: 20,
                  //     vertical: 17,
                  //   ),
                  //   hintText: widget.hintText,
                  //   border: OutlineInputBorder(
                  //     borderRadius: BorderRadius.circular(17),
                  //   ),
                  //   focusedBorder: OutlineInputBorder(
                  //     borderRadius: BorderRadius.circular(17),
                  //     borderSide: BorderSide(color: NColors.primary),
                  //   ),
                  //   enabledBorder: OutlineInputBorder(
                  //     borderRadius: BorderRadius.circular(17),
                  //     borderSide: BorderSide(color: NColors.primary),
                  //   ),
                  //   suffixIcon: widget.icon,
                  //   suffixText: "tes"
                  //   // suffix: SizedBox(
                  //   //   width: 30.0, // Adjust the width according to your needs
                  //   //   child: Center(child: Text('cm')),
                  //   // ),
                  // ),
                ),
              ),
              // Text(
              //   'Additional Text',
              //   style: TextStyle(fontSize: 16), // Adjust font size as needed
              // ),
            ],
          ),
        ),
        SizedBox(height: 20),

      ],
    );
    // );
  }
}
