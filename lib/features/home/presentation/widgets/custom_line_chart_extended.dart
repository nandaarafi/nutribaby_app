//
//
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutribaby_app/core/constants/colors.dart';
import 'package:nutribaby_app/features/home/presentation/provider/chart_controller.dart';
import 'package:nutribaby_app/features/home/presentation/widgets/legend_widget.dart';
import 'package:provider/provider.dart';
import '../../domain/health_data_model.dart';

class CustomLineChartExtended extends StatefulWidget {
  final List<LineData> dataList;
  final List<LineData> expectedList2;
  final List<LineData> expectedList3;
  final List<LineData> expectedListMinus2;
  final List<LineData> expectedListMinus3;
  final String xViewInterval;

  CustomLineChartExtended({Key? key,
    required this.dataList,
    required this.xViewInterval,
    required this.expectedList2,
    required this.expectedList3,
    required this.expectedListMinus2,
    required this.expectedListMinus3

  }) : super(key: key);

  @override
  State<CustomLineChartExtended> createState() => _CustomLineChart2State();
}

class _CustomLineChart2State extends State<CustomLineChartExtended> {
  @override
  Widget build(BuildContext context) {
    List<LineData> dataListReversed = widget.dataList.reversed.toList();
    // List<LineData> dataListReversed = widget.dataList.reversed.toList();

    return Scaffold(
      body: Consumer<ChartDataProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              Legend(items: [
                LegendItem(color: NColors.Pprimary, label: 'Data Sesungguhnya'),
                LegendItem(color: Colors.red, label: '2'),
              ],
              ),

              Legend(items: [
                LegendItem(color: Colors.blue, label: '3'),
                LegendItem(color: Colors.yellow, label: '-2'),
                LegendItem(color: Colors.green, label: '-3'),
              ],
              ),

              Expanded(
                child: LineChartSample2(dataList: provider.fetchInitial
                      ? dataListReversed : widget.dataList,
                    xViewInterval: widget.xViewInterval,
                    expectedList2: widget.expectedList2,
                    expectedList3: widget.expectedList3,
                    expectedMinus2: widget.expectedListMinus2,
                    expectedMinus3: widget.expectedListMinus3,
                ),
              ),
            ],
          );
        },
      ),
      // ),
    );
  }
}

class LineChartSample2 extends StatelessWidget {
  LineChartSample2({
    required this.dataList,
    required this.expectedList2,
    required this.expectedList3,
    required this.expectedMinus2,
    required this.expectedMinus3,
    required this.xViewInterval,
    Key? key,
  }) : super(key: key);

  final List<LineData> dataList;
  final List<LineData> expectedList2;
  final List<LineData> expectedList3;
  final List<LineData> expectedMinus2;
  final List<LineData> expectedMinus3;
  final String xViewInterval;

  final List<Color> gradientColorsSideValue = [
    NColors.Pprimary,
    NColors.primary,
  ];
  final List<Color> gradientColorsList2 = [
    Colors.red,
    Colors.red,
  ];
  final List<Color> gradientColorsList3 = [
    Colors.blue,
    Colors.blue,
  ];
  final List<Color> gradientColorsMinus2 = [
    Colors.green,
    Colors.green,
  ];
  final List<Color> gradientColorsMinus3 = [
    Colors.yellow,
    Colors.yellow,
  ];

  @override
  Widget build(BuildContext context) {
    bool timeIntervalState = true;
    if (expectedList2.length < 20){
      timeIntervalState = true;
    }else{
      timeIntervalState = false;
    }

    double? maxSideValue = getMaxSideValue(dataList, expectedList3);
    double adjustedMaxY = (maxSideValue ?? 0) * 1.2;
    double screenHeight = MediaQuery.of(context).size.height;

    double yAxisInterval = calculateYAxisInterval(adjustedMaxY, screenHeight);
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      reverse: true,
      itemCount: 1,
      itemBuilder: (context, index) {
        List<FlSpot> spots = [];
        List<FlSpot> spots2 = [];
        List<FlSpot> spots3 = [];
        List<FlSpot> spots4 = [];
        List<FlSpot> spots5 = [];
        // int countpermonth = 0;
        for (final entry in dataList.asMap().entries) {
          spots.add(FlSpot(entry.key.toDouble(), entry.value.sideValue));
        }

        for (final entry in expectedList2.asMap().entries) {
          spots2.add(FlSpot(entry.key.toDouble(), entry.value.sideValue));
        }
        for (final entry in expectedList3.asMap().entries) {
          spots3.add(FlSpot(entry.key.toDouble(), entry.value.sideValue));
        }
        for (final entry in expectedMinus2.asMap().entries) {
          spots4.add(FlSpot(entry.key.toDouble(), entry.value.sideValue));
        }
        for (final entry in expectedMinus3.asMap().entries) {
          spots5.add(FlSpot(entry.key.toDouble(), entry.value.sideValue));
        }
        /// print(60 % 30);
        // for (int i = 0; i < 1080; i++) {
          // if (i < expectedList2.length) {
          //   if (i % 30 == 0 && i != 0){
          //     countpermonth += 1;
          //   }
          //   print(countpermonth);
          //     spots2.add(FlSpot(i.toDouble(), expectedList2[countpermonth].sideValue));
          // }
        // }

        // print("[INFO] spot2: $spots2");


        return SizedBox(
          width: 2000,
          // width: timeIntervalState ? (dataList.length * 60) : (dataList
          //     .length * 10),
          height: 400,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: LineChart(mainData(
                  spots, spots2, spots3, spots4, spots5, yAxisInterval, adjustedMaxY, timeIntervalState)),
            ),
          ),
        );
      },
    );
    // }
    // );
  }

  LineChartData mainData(
      List<FlSpot> spots,
      List<FlSpot> spots2,
      List<FlSpot> spots3,
      List<FlSpot> spots4,
      List<FlSpot> spots5,
      double yAxisInterval, double adjustedMaxY, bool timeIntervalState) {

    return LineChartData(
      gridData: FlGridData(
        show: false,
        drawVerticalLine: true,
        // horizontalInterval: 10,
        // verticalInterval: 10,
        getDrawingHorizontalLine:  (value) => FlLine(
          color: NColors.black,
          strokeWidth: 1,
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          // axisNameSize: 1,
          // drawBelowEverything: true,
          // drawBelowEverything: true,
          sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 20,
              interval: 1.0,
              // interval:timeIntervalState ? 1.0 : 30.0,
              getTitlesWidget: (value, titleMeta) {
                // print(value);

                final index = value.toInt();
                if (index >= 0 && index < expectedList2.length) {
                  final date = expectedList2[index].date;

                  // final dayOfWeek = DateFormat('EEE').format(date);
                  final dayOfWeek = DateFormat('d').format(date);
                  final monthOfYear = DateFormat('MMM').format(date);
                  final monthOfYearNum = DateFormat('M').format(date);
                  final yearToYear = DateFormat('yy').format(date);// Get the day of the week


                  // if (timeIntervalState) {
                  //   return Text(
                  //     '${dayOfWeek}/$monthOfYear',
                  //     // '$dayOfWeek/$monthOfYear/$yearToYear',
                  //     style: TextStyle(fontSize: 12),
                  //   );
                  // }else {
                    return Text(
                      '$monthOfYear/$yearToYear',
                      style: TextStyle(fontSize: 12),
                    );
                  // }
                  // final date = dataList[value.toInt()].date;
                  // return Text(
                  //   '${date.day}/${date.month}/${date.year}',
                  //   style: TextStyle(fontSize: 12),
                  // );
                }
                return Text('');
              }
          ),
        ),
        leftTitles: AxisTitles(
          drawBelowEverything: false,
          sideTitles: SideTitles(
            showTitles: false,
            interval: 1.0,
            // interval: yAxisInterval,
            getTitlesWidget: (value, meta) {

              // int index = value.toInt();
              // if (index >= 0 && index < dataList.length) {
              //   double sideValue = dataList[index].sideValue;
              return Text(
                value.toInt().toString(),
                textAlign: TextAlign.center,
              );

              // return Text('');
            },
            reservedSize: 42,

          ),
        ),
      ),
      borderData: FlBorderData(
          show: false,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      // minX: minX,
      minX: 0,
      // maxX: maxX - 1,
      maxX: 36,
      // maxX:7.0,
      // maxX:3.0,
      // maxX: dataList.length.toDouble() - 1,
      backgroundColor: Colors.white,
      minY: 0,
      maxY: adjustedMaxY,
      // lineTouchData: LineTouchData(enabled: false),
// Adjust this value according to your data range
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColorsSideValue,
          ),
          color: Colors.white,
          barWidth: 1,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
        ),
        LineChartBarData(
          // lineChartStepData: ,
          spots:spots2,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColorsList2,
          ),
          color: Colors.white,
          barWidth: 1,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
        ),
        LineChartBarData(
          // lineChartStepData: ,
          spots:spots3,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColorsList3,
          ),
          color: Colors.white,
          barWidth: 1,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
        ),
        LineChartBarData(
          // lineChartStepData: ,
          spots:spots4,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColorsMinus2,
          ),
          color: Colors.white,
          barWidth: 1,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
        ),

        LineChartBarData(
          // lineChartStepData: ,
          spots:spots5,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColorsMinus3,
          ),
          color: Colors.white,
          barWidth: 1,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
        ),




      ],
    );
  }
}

double? getMaxSideValue(List<LineData> dataList, List<LineData> expectedMax) {
  if (dataList.isEmpty && expectedMax.isEmpty) {
    return null; // Return null if both lists are empty
  }

  // Combine the two lists
  List<LineData> combinedList = [...dataList, ...expectedMax];

  // Find the maximum sideValue
  double maxSideValue = combinedList.map((data) => data.sideValue).reduce((max, value) => max > value ? max : value);

  return maxSideValue;
}
double calculateYAxisInterval(double maxY, double screenHeight) {
  // Set the desired number of labels on the y-axis
  const int desiredLabels = 5;

  // Calculate a dynamic interval based on the desired number of labels
  double interval = (maxY / desiredLabels).ceilToDouble();

  // Ensure the interval is not too small or too large for the screen
  double maxLabels = screenHeight / 40; // Assuming each label takes up 40 pixels
  return interval < maxY / maxLabels ? maxY / maxLabels : interval;
}
