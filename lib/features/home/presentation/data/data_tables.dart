import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/health_data_model.dart';


class DataTables{
  List<LineData> generateBoysExpectedWeight2(DateTime birthDate) {
      List<LineData> lineDataList = [];
      int currentMonth = birthDate.month;
      int currentYear = birthDate.year;
      for (double sideValue in [
        4.4,
        5.8,
        7.1,
        8.0,
        8.7,
        9.3,
        9.8,
        10.3,
        10.7,
        11.0,
        11.4,
        11.7,
        12.0,
        12.3,
        12.6,
        12.8,
        13.1,
        13.4,
        13.7,
        13.9,
        14.2,
        14.5,
        14.7,
        15.0,
        15.3,
        15.5,
        15.8,
        16.1,
        16.3,
        16.6,
        16.9,
        17.1,
        17.4,
        17.6,
        17.8,
        18.1,
        18.3
      ]) {
        lineDataList.add(LineData(
          sideValue: sideValue,
          date: DateTime(currentYear, currentMonth, 1),
        ));

        // Increment month for the next data point
        currentMonth++;

        // Handle month overflow (December to January)
        if (currentMonth > 12) {
          currentMonth = 1;
          currentYear++;
        }
      }

      return lineDataList;
}

List<LineData> generateBoysExpectedWeight3(DateTime birthDate) {
      List<LineData> lineDataList = [];
      int currentMonth = birthDate.month;
      int currentYear = birthDate.year;

      for (double sideValue in [
        5.0,
        6.6,
        8.0,
        9.0,
        9.7,
        10.4,
        10.9,
        11.4,
        11.9,
        12.3,
        12.7,
        13.0,
        13.3,
        13.7,
        14.0,
        14.3,
        14.6,
        14.9,
        15.3,
        15.6,
        15.9,
        16.2,
        16.5,
        16.8,
        17.1,
        17.5,
        17.8,
        18.1,
        18.4,
        18.7,
        19.0,
        19.3,
        19.6,
        19.9,
        20.2,
        20.4,
        20.7
      ]) {
        lineDataList.add(LineData(
          sideValue: sideValue,
          date: DateTime(currentYear, currentMonth, 1),
        ));

        // Increment month for the next data point
        currentMonth++;

        // Handle month overflow (December to January)
        if (currentMonth > 12) {
          currentMonth = 1;
          currentYear++;
        }
      }

      return lineDataList;
}

List<LineData> generateBoysExpectedWeightMinus2(DateTime birthDate) {
      List<LineData> lineDataList = [];
      int currentMonth = birthDate.month;
      int currentYear = birthDate.year;

      for (double sideValue in [
        2.5,
        3.4,
        4.3,
        5.0,
        5.6,
        6.0,
        6.4,
        6.7,
        6.9,
        7.1,
        7.4,
        7.6,
        7.7,
        7.9,
        8.1,
        8.3,
        8.4,
        8.6,
        8.8,
        8.9,
        9.1,
        9.2,
        9.4,
        9.5,
        9.7,
        9.8,
        10.0,
        10.1,
        10.2,
        10.4,
        10.5,
        10.7,
        10.8,
        10.9,
        11.0,
        11.2,
        11.3
      ]) {
        lineDataList.add(LineData(
          sideValue: sideValue,
          date: DateTime(currentYear, currentMonth, 1),
        ));

        // Increment month for the next data point
        currentMonth++;

        // Handle month overflow (December to January)
        if (currentMonth > 12) {
          currentMonth = 1;
          currentYear++;
        }
      }

      return lineDataList;
}

List<LineData> generateBoysExpectedWeightMinus3(DateTime birthDate) {
      List<LineData> lineDataList = [];
      int currentMonth = birthDate.month;
      int currentYear = birthDate.year;

      for (double sideValue in [
        2.1,
        2.9,
        3.8,
        4.4,
        4.9,
        5.3,
        5.7,
        5.9,
        6.2,
        6.4,
        6.6,
        6.8,
        6.9,
        7.1,
        7.2,
        7.4,
        7.5,
        7.7,
        7.8,
        8.0,
        8.1,
        8.2,
        8.4,
        8.5,
        8.6,
        8.8,
        8.9,
        9.0,
        9.1,
        9.2,
        9.4,
        9.5,
        9.6,
        9.7,
        9.8,
        9.9,
        10.0

      ]) {
        lineDataList.add(LineData(
          sideValue: sideValue,
          date: DateTime(currentYear, currentMonth, 1),
        ));

        // Increment month for the next data point
        currentMonth++;

        // Handle month overflow (December to January)
        if (currentMonth > 12) {
          currentMonth = 1;
          currentYear++;
        }
      }

      return lineDataList;
}

List<LineData> generateGirlExpectedWeight2(DateTime birthDate) {
      List<LineData> lineDataList = [];
      int currentMonth = birthDate.month;
      int currentYear = birthDate.year;

      for (double sideValue in [
        4.2,
        5.5,
        6.6,
        7.5,
        8.2,
        8.8,
        9.3,
        9.8,
        10.2,
        10.5,
        10.9,
        11.2,
        11.5,
        11.8,
        12.1,
        12.4,
        12.6,
        12.9,
        13.2,
        13.5,
        13.7,
        14.0,
        14.3,
        14.6,
        14.8,
        15.1,
        15.4,
        15.7,
        16.0,
        16.2,
        16.5,
        16.8,
        17.1,
        17.3,
        17.6,
        17.9,
        18.1,


      ]) {
        lineDataList.add(LineData(
          sideValue: sideValue,
          date: DateTime(currentYear, currentMonth, 1),
        ));

        // Increment month for the next data point
        currentMonth++;

        // Handle month overflow (December to January)
        if (currentMonth > 12) {
          currentMonth = 1;
          currentYear++;
        }
      }

      return lineDataList;
}

List<LineData> generateGirlExpectedWeight3(DateTime birthDate) {
      List<LineData> lineDataList = [];
      int currentMonth = birthDate.month;
      int currentYear = birthDate.year;

      for (double sideValue in [
        4.8,
        6.2,
        7.5,
        8.5,
        9.3,
        10.0,
        10.6,
        11.1,
        11.6,
        12.0,
        12.4,
        12.8,
        13.1,
        13.5,
        13.8,
        14.1,
        14.5,
        14.8,
        15.1,
        15.4,
        15.7,
        16.0,
        16.4,
        16.7,
        17.0,
        17.3,
        17.7,
        18.0,
        18.3,
        18.7,
        19.0,
        19.3,
        19.6,
        20.0,
        20.3,
        20.6,
        20.9,

      ]) {
        lineDataList.add(LineData(
          sideValue: sideValue,
          date: DateTime(currentYear, currentMonth, 1),
        ));

        // Increment month for the next data point
        currentMonth++;

        // Handle month overflow (December to January)
        if (currentMonth > 12) {
          currentMonth = 1;
          currentYear++;
        }
      }

      return lineDataList;
}

List<LineData> generateGirlExpectedWeightMinus2(DateTime birthDate) {
      List<LineData> lineDataList = [];
      int currentMonth = birthDate.month;
      int currentYear = birthDate.year;

      for (double sideValue in [
        2.4,
        3.2,
        3.9,
        4.5,
        5.0,
        5.4,
        5.7,
        6.0,
        6.3,
        6.5,
        6.7,
        6.9,
        7.0,
        7.2,
        7.4,
        7.6,
        7.7,
        7.9,
        8.1,
        8.2,
        8.4,
        8.6,
        8.7,
        8.9,
        9.0,
        9.2,
        9.4,
        9.5,
        9.7,
        9.8,
        10.0,
        10.1,
        10.3,
        10.4,
        10.5,
        10.7,
        10.8,

      ]) {
        lineDataList.add(LineData(
          sideValue: sideValue,
          date: DateTime(currentYear, currentMonth, 1),
        ));

        // Increment month for the next data point
        currentMonth++;

        // Handle month overflow (December to January)
        if (currentMonth > 12) {
          currentMonth = 1;
          currentYear++;
        }
      }

      return lineDataList;
}

List<LineData> generateGirlExpectedWeightMinus3(DateTime birthDate) {
      List<LineData> lineDataList = [];
      int currentMonth = birthDate.month;
      int currentYear = birthDate.year;

      for (double sideValue in [
        2.0,
        2.7,
        3.4,
        4.0,
        4.4,
        4.8,
        5.1,
        5.3,
        5.6,
        5.8,
        5.9,
        6.1,
        6.3,
        6.4,
        6.6,
        6.7,
        6.9,
        7.0,
        7.2,
        7.3,
        7.5,
        7.6,
        7.8,
        7.9,
        8.1,
        8.2,
        8.4,
        8.5,
        8.6,
        8.8,
        8.9,
        9.0,
        9.1,
        9.3,
        9.4,
        9.5,
        9.6,
      ]) {
        lineDataList.add(LineData(
          sideValue: sideValue,
          date: DateTime(currentYear, currentMonth, 1),
        ));

        // Increment month for the next data point
        currentMonth++;

        // Handle month overflow (December to January)
        if (currentMonth > 12) {
          currentMonth = 1;
          currentYear++;
        }
      }

      return lineDataList;
}

  List<LineData> generateBoysExpectedHeight2(DateTime birthDate) {
    List<LineData> lineDataList = [];
    int currentMonth = birthDate.month;
    int currentYear = birthDate.year;

    for (double sideValue in [
      53.7,
      58.6,
      62.4,
      65.5,
      68.0,
      70.1,
      71.9,
      73.5,
      75.0,
      76.5,
      77.9,
      79.2,
      80.5,
      81.8,
      83.0,
      84.2,
      85.4,
      86.5,
      87.7,
      88.8,
      89.8,
      90.9,
      91.9,
      92.9,
      93.2,
      94.2,
      95.2,
      96.1,
      97.0,
      97.9,
      98.7,
      99.6,
      100.4,
      101.2,
      102.0,
      102.7,
      103.5,
    ]) {
      lineDataList.add(LineData(
        sideValue: sideValue,
        date: DateTime(currentYear, currentMonth, 1),
      ));

      // Increment month for the next data point
      currentMonth++;

      // Handle month overflow (December to January)
      if (currentMonth > 12) {
        currentMonth = 1;
        currentYear++;
      }
    }

    return lineDataList;
  }



  List<LineData> generateBoysExpectedHeight3(DateTime birthDate) {
    List<LineData> lineDataList = [];
    int currentMonth = birthDate.month;
    int currentYear = birthDate.year;

    for (double sideValue in [
      55.6,
      60.6,
      64.4,
      67.6,
      70.1,
      72.2,
      74.0,
      75.7,
      77.2,
      78.7,
      80.1,
      81.5,
      82.9,
      84.2,
      85.5,
      86.7,
      88.0,
      89.2,
      90.4,
      91.5,
      92.6,
      93.8,
      94.9,
      95.9,
      96.3,
      97.3,
      98.3,
      99.3,
      100.3,
      101.2,
      102.1,
      103.0,
      103.9,
      104.8,
      105.6,
      106.4,
      107.2,

    ]) {
      lineDataList.add(LineData(
        sideValue: sideValue,
        date: DateTime(currentYear, currentMonth, 1),
      ));

      // Increment month for the next data point
      currentMonth++;

      // Handle month overflow (December to January)
      if (currentMonth > 12) {
        currentMonth = 1;
        currentYear++;
      }
    }

    return lineDataList;
  }

  List<LineData> generateBoysExpectedHeightMinus2(DateTime birthDate) {
    List<LineData> lineDataList = [];
    int currentMonth = birthDate.month;
    int currentYear = birthDate.year;

    for (double sideValue in [
      46.1,
      50.8,
      54.4,
      57.3,
      59.7,
      61.7,
      63.3,
      64.8,
      66.2,
      67.5,
      68.7,
      69.9,
      71.0,
      72.1,
      73.1,
      74.1,
      75.0,
      76.0,
      76.9,
      77.7,
      78.6,
      79.4,
      80.2,
      81.0,
      81.0,
      81.7,
      82.5,
      83.1,
      83.8,
      84.5,
      85.1,
      85.7,
      86.4,
      86.9,
      87.5,
      88.1,
      88.7,

    ]) {
      lineDataList.add(LineData(
        sideValue: sideValue,
        date: DateTime(currentYear, currentMonth, 1),
      ));

      // Increment month for the next data point
      currentMonth++;

      // Handle month overflow (December to January)
      if (currentMonth > 12) {
        currentMonth = 1;
        currentYear++;
      }
    }

    return lineDataList;
  }

  List<LineData> generateBoysExpectedHeightMinus3(DateTime birthDate) {
    List<LineData> lineDataList = [];
    int currentMonth = birthDate.month;
    int currentYear = birthDate.year;

    for (double sideValue in [
      44.2,
      48.9,
      52.4,
      55.3,
      57.6,
      59.6,
      61.2,
      62.7,
      64.0,
      65.2,
      66.4,
      67.6,
      68.6,
      69.6,
      70.6,
      71.6,
      72.5,
      73.3,
      74.2,
      75.0,
      75.8,
      76.5,
      77.2,
      78.0,
      78.0,
      78.6,
      79.3,
      79.9,
      80.5,
      81.1,
      81.7,
      82.3,
      82.8,
      83.4,
      83.9,
      84.4,
      85.0,

    ]) {
      lineDataList.add(LineData(
        sideValue: sideValue,
        date: DateTime(currentYear, currentMonth, 1),
      ));

      // Increment month for the next data point
      currentMonth++;

      // Handle month overflow (December to January)
      if (currentMonth > 12) {
        currentMonth = 1;
        currentYear++;
      }
    }

    return lineDataList;
  }

  List<LineData> generateGirlExpectedHeight2(DateTime birthDate) {
    List<LineData> lineDataList = [];
    int currentMonth = birthDate.month;
    int currentYear = birthDate.year;

    for (double sideValue in [
      52.9,
      57.6,
      61.1,
      64.0,
      66.4,
      68.5,
      70.3,
      71.9,
      73.5,
      75.0,
      76.4,
      77.8,
      79.2,
      80.5,
      81.7,
      83.0,
      84.2,
      85.4,
      86.5,
      87.6,
      88.7,
      89.8,
      90.8,
      91.9,
      92.2,
      93.1,
      94.1,
      95.0,
      96.0,
      96.9,
      97.7,
      98.6,
      99.4,
      100.3,
      101.1,
      101.9,
      102.7

    ]) {
      lineDataList.add(LineData(
        sideValue: sideValue,
        date: DateTime(currentYear, currentMonth, 1),
      ));

      // Increment month for the next data point
      currentMonth++;

      // Handle month overflow (December to January)
      if (currentMonth > 12) {
        currentMonth = 1;
        currentYear++;
      }
    }

    return lineDataList;
  }

  List<LineData> generateGirlExpectedHeight3(DateTime birthDate) {
    List<LineData> lineDataList = [];
    int currentMonth = birthDate.month;
    int currentYear = birthDate.year;

    for (double sideValue in [
      54.7,
      59.5,
      63.2,
      66.1,
      68.6,
      70.7,
      72.5,
      74.2,
      75.8,
      77.4,
      78.9,
      80.3,
      81.7,
      83.1,
      84.4,
      85.7,
      87.0,
      88.2,
      89.4,
      90.6,
      91.7,
      92.9,
      94.0,
      95.0,
      95.4,
      96.4,
      97.4,
      98.4,
      99.4,
      100.3,
      101.3,
      102.2,
      103.1,
      103.9,
      104.8,
      105.6,
      106.5,
    ]) {
      lineDataList.add(LineData(
        sideValue: sideValue,
        date: DateTime(currentYear, currentMonth, 1),
      ));

      // Increment month for the next data point
      currentMonth++;

      // Handle month overflow (December to January)
      if (currentMonth > 12) {
        currentMonth = 1;
        currentYear++;
      }
    }

    return lineDataList;
  }

  List<LineData> generateGirlExpectedHeightMinus2(DateTime birthDate) {
    List<LineData> lineDataList = [];
    int currentMonth = birthDate.month;
    int currentYear = birthDate.year;

    for (double sideValue in [
      45.4,
      49.8,
      53.0,
      55.6,
      57.8,
      59.6,
      61.2,
      62.7,
      64.0,
      65.3,
      66.5,
      67.7,
      68.9,
      70.0,
      71.0,
      72.0,
      73.0,
      74.0,
      74.9,
      75.8,
      76.7,
      77.5,
      78.4,
      79.2,
      79.3,
      80.0,
      80.8,
      81.5,
      82.2,
      82.9,
      83.6,
      84.3,
      84.9,
      85.6,
      86.2,
      86.8,
      87.4,
    ]) {
      lineDataList.add(LineData(
        sideValue: sideValue,
        date: DateTime(currentYear, currentMonth, 1),
      ));

      // Increment month for the next data point
      currentMonth++;

      // Handle month overflow (December to January)
      if (currentMonth > 12) {
        currentMonth = 1;
        currentYear++;
      }
    }

    return lineDataList;
  }

  List<LineData> generateGirlExpectedHeightMinus3(DateTime birthDate) {
    List<LineData> lineDataList = [];
    int currentMonth = birthDate.month;
    int currentYear = birthDate.year;

    for (double sideValue in [
      43.6,
      47.8,
      51.0,
      53.5,
      55.6,
      57.4,
      58.9,
      60.3,
      61.7,
      62.9,
      64.1,
      65.2,
      66.3,
      67.3,
      68.3,
      69.3,
      70.2,
      71.1,
      72.0,
      72.8,
      73.7,
      74.5,
      75.2,
      76.0,
      76.0,
      76.8,
      77.5,
      78.1,
      78.8,
      79.5,
      80.1,
      80.7,
      81.3,
      81.9,
      82.5,
      83.1,
      83.6,

    ]) {
      lineDataList.add(LineData(
        sideValue: sideValue,
        date: DateTime(currentYear, currentMonth, 1),
      ));

      // Increment month for the next data point
      currentMonth++;

      // Handle month overflow (December to January)
      if (currentMonth > 12) {
        currentMonth = 1;
        currentYear++;
      }
    }

    return lineDataList;
  }


  //Question 
  //How if the expected Date passed

}

