import 'package:flutter/material.dart';

class BirthdateInputWidget extends StatefulWidget {
  @override
  _BirthdateInputWidgetState createState() => _BirthdateInputWidgetState();
}

class _BirthdateInputWidgetState extends State<BirthdateInputWidget> {
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Birthdate:'),
        Row(
          children: [
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text('Pick a date'),
            ),
            SizedBox(width: 16),
            selectedDate != null
                ? Text('Selected date: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}')
                : Container(),
          ],
        ),
      ],
    );
  }
}