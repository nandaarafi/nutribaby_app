import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/colors.dart';

class CustomDatePicker extends StatelessWidget {
  final String title;
  final String hintText;
  final TextEditingController controller;
  VoidCallback OnPressed;

  CustomDatePicker({
    super.key,
    required this.title,
    required this.hintText,
    required this.controller,
    required this.OnPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(
            height: 6,
          ),
          GestureDetector(
            onTap: OnPressed,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 17,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: NColors.primary),
                borderRadius: BorderRadius.circular(17),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Text(
                        controller.text.isEmpty ? hintText : controller.text,
                      
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),

                  ),
                  Icon(Icons.calendar_today),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}