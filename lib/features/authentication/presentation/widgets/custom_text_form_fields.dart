// import 'package:airplane/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:nutribaby_app/core/constants/colors.dart';
import 'package:nutribaby_app/core/helper/helper_functions.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class CustomTextFormField extends StatefulWidget {
  final String title;
  final String hintText;
  final Widget? icon;
  final bool obsecureText;
  final VoidCallback? onTap;
  final TextEditingController controller;

  const CustomTextFormField({
    Key? key,
    required this.title,
    required this.hintText,
    this.onTap,
    this.icon,
    this.obsecureText = false,
    required this.controller,
  }) : super(key: key);

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {


  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(
            height: 6,
          ),
                  TextFormField(
                    textAlign: TextAlign.start,
                    autofocus: false,
                    onTap: widget.onTap,
                    controller: widget.controller,
                    cursorColor: Colors.black,
                    obscureText: widget.obsecureText,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 17,
                      ),
                      hintText: widget.hintText,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(17),
                        borderSide: BorderSide(color: NColors.primary),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(17),
                        borderSide: BorderSide(color: NColors.primary),
                      ),
                      suffixIcon: widget.icon,
                    ),
                  ),
          // SizedBox(height: 20),
        // ],
          // );

          // TextField(
          //   autofocus: false,
          //   onTap: widget.onTap,
          //   controller: widget.controller,
          //   // onSubmitted: (_) => FocusScope.of(context).unfocus(),
          //   cursorColor: Colors.black,
          //   obscureText: widget.obsecureText,
          //   style: Theme.of(context).textTheme.bodyMedium,
          //   textInputAction: TextInputAction.next,
          //   decoration: InputDecoration(
          //     contentPadding: const EdgeInsets.symmetric(
          //       horizontal: 20,
          //       vertical: 17,
          //     ),
          //     hintText: widget.hintText,
          //     border: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(17),
          //     ),
          //     focusedBorder: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(17),
          //       borderSide: BorderSide(color: NColors.primary),
          //     ),
          //     enabledBorder: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(17),
          //       borderSide: BorderSide(color: NColors.primary),
          //     ),
          //     suffixIcon: widget.icon,
          //   ),
          // ),
      ],
      ),
    );
  }
}
