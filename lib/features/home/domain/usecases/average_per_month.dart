import 'package:intl/intl.dart';

import '../health_data_model.dart';

class DataProcessor {
  List<LineData> calculateMonthlyAverages(List<LineData> dataList) {
    // Group data by month
    Map<String, List<LineData>> groupedByMonth = {};
    for (var data in dataList) {
      String monthKey = DateFormat('yyyy-MM').format(data.date);
      if (!groupedByMonth.containsKey(monthKey)) {
        groupedByMonth[monthKey] = [];
      }
      groupedByMonth[monthKey]!.add(data);
    }

    // Calculate average for each month
    List<LineData> monthlyAverages = [];
    groupedByMonth.forEach((monthKey, dataList) {
      double totalSideValue = 0;
      for (var data in dataList) {
        totalSideValue += data.sideValue;
      }
      double averageSideValue = totalSideValue / dataList.length;
      double roundedAverageSideValue = double.parse(averageSideValue.toStringAsFixed(2));
      DateTime monthDate = DateFormat('yyyy-MM').parse(monthKey);
      monthlyAverages.add(LineData(sideValue: roundedAverageSideValue, date: monthDate));
    });

    return monthlyAverages;
  }
}