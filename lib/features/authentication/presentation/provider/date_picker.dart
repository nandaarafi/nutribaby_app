import 'package:flutter/material.dart';

class DateProvider with ChangeNotifier {
  DateTime? _selectedDate;

  DateTime? get selectedDate => _selectedDate;

  void updateSelectedDate(DateTime newDate) {
    if (newDate != _selectedDate) {
      _selectedDate = newDate;
      notifyListeners();
    }
  }
}