
import 'package:flutter/cupertino.dart';

class ChartProvider extends ChangeNotifier {
  String _selectedValue = 'weeks';

  String get selectedValue => _selectedValue;

  void setSelectedValue(String value) {
    _selectedValue = value;
    notifyListeners();
  }
}


class ChartDataProvider extends ChangeNotifier {
  bool _showingChart = false;
  bool _emptyError = false;
  bool _LoadingState = true;
  bool _fetchInitial = true;
  DateTime? _startDate;
  DateTime? _endDate;

  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  bool get showingChart => _showingChart;

  bool get fetchInitial => _fetchInitial;

  bool get LoadingState => _LoadingState;

  bool get emptyError => _emptyError;

  void setShowingChart(bool value) {
    _showingChart = value;
    notifyListeners();
  }
  void setEmptyError(bool value) {
    _emptyError = value;
    notifyListeners();
  }

  void setLoadingState(bool value) {
    _LoadingState = value;
    notifyListeners();
  }
  void setFetchInitial(bool value) {
    _fetchInitial = value;
    notifyListeners();
  }

  void setDates(DateTime? startDate, DateTime? endDate) {
    _startDate = startDate;
    _endDate = endDate;
    notifyListeners();
  }
}

class ChartBottomTitlesProvider extends ChangeNotifier{

}

// class DateRangeProvider extends ChangeNotifier {
//   DateTime? _startDate;
//   DateTime? _endDate;
//
//   DateTime? get startDate => _startDate;
//   DateTime? get endDate => _endDate;
//
//   void setDates(DateTime? startDate, DateTime? endDate) {
//     _startDate = startDate;
//     _endDate = endDate;
//     notifyListeners();
//   }
// }
//
// class FetchInitialProvider extends ChangeNotifier {
//   bool _fetchInitial = true;
//
//   bool get fetchInitial => _fetchInitial;
//
//   void setFetchInitial(bool value) {
//     _fetchInitial = value;
//     notifyListeners();
//   }
// }