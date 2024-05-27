import '../health_data_model.dart';

class UsecaseModel{
  double calculateTrend(List<LineData> dataList) {
    if (dataList.isEmpty) {
      return 0;
    }

    double summedSideValues =
    dataList.map((data) => data.sideValue).reduce((a, b) => a + b);
    double multipliedData = 0;
    int summedIndex = 0;
    int squaredIndex = 0;

    for (int index = 0; index < dataList.length; index++) {
      int currentIndex = index + 1; // Adjust index for 1-based counting
      multipliedData += currentIndex * dataList[index].sideValue;
      summedIndex += currentIndex;
      squaredIndex += currentIndex * currentIndex;
    }

    double numerator =
        (dataList.length * multipliedData) - (summedSideValues * summedIndex);
    int denominator =
    ((dataList.length * squaredIndex) - (summedIndex * summedIndex));
    denominator.toDouble();

    return denominator != 0 ? numerator / denominator : 0;
  }

  double calculateTrendReversed(List<LineData> dataList) {
    if (dataList.isEmpty) {
      return 0;
    }
    List<LineData> dataListReversed = dataList.reversed.toList();

    double summedSideValues =
    dataListReversed.map((data) => data.sideValue).reduce((a, b) => a + b);
    double multipliedData = 0;

    int summedIndex = 0;
    int squaredIndex = 0;

    for (int index = 0; index < dataListReversed.length; index++) {
      int currentIndex = index + 1;
      multipliedData += currentIndex * dataListReversed[index].sideValue;
      summedIndex += currentIndex;
      squaredIndex += currentIndex * currentIndex;
    }

    double numerator =
        (dataList.length * multipliedData) - (summedSideValues * summedIndex);
    int denominator =
    ((dataList.length * squaredIndex) - (summedIndex * summedIndex));
    denominator.toDouble();

    double result =  denominator != 0 ? numerator / denominator : 0;
    double roundedResult = double.parse(result.toStringAsFixed(2));

    return roundedResult;
  }

  double calculateTrendPercentage(List<LineData> dataList) {
    if (dataList.isEmpty || dataList.length < 2) {
      return 0.0; // Return 0 if there are fewer than two data points
    }

    LineData firstData = dataList.first;
    LineData lastData = dataList.last;

    double initialData = firstData.sideValue;
    double finalData = lastData.sideValue;

    double percentageChange = ((finalData - initialData));
    // double percentageChange = ((finalData - initialData) / initialData) * 100;
    double roundedResult = double.parse(percentageChange.toStringAsFixed(2));

    return roundedResult;
  }

  double calculateTrendPercentageReversed(List<LineData> dataList) {
    if (dataList.isEmpty || dataList.length < 2) {
      return 0.0; // Return 0 if there are fewer than two data points
    }
    List<LineData> dataListReversed = dataList.reversed.toList();


    // Get the first and last data points
    LineData firstData = dataListReversed.first;
    LineData lastData = dataListReversed.last;

    // Calculate the percentage change
    double initialData = firstData.sideValue;
    double finalData = lastData.sideValue;

    double percentageChange = ((finalData - initialData));
    double roundedResult = double.parse(percentageChange.toStringAsFixed(2));

    return roundedResult;
  }
}