import 'package:flutter/material.dart';

class TrendStateProvider extends ChangeNotifier {
  bool _weightTrendState = true;
  bool _heightTrendState = true;
  bool _headCircumferenceTrendState = true;

  bool get weightTrendState => _weightTrendState;
  bool get heightTrendState => _heightTrendState;
  bool get headCircumferenceTrendState => _headCircumferenceTrendState;

  void updateTrendStates({
    required double weightPercentageChange,
    required double heightPercentageChange,
    required double headCircumferencePercentageChange,
  }) {
    _weightTrendState = weightPercentageChange >= 0;
    _heightTrendState = heightPercentageChange >= 0;
    _headCircumferenceTrendState = headCircumferencePercentageChange >= 0;

    notifyListeners();
  }
}