//
//
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutribaby_app/core/constants/colors.dart';
import 'package:nutribaby_app/features/home/presentation/provider/chart_controller.dart';
import 'package:provider/provider.dart';
import '../../domain/health_data_model.dart';

class CustomLineChart extends StatefulWidget {
  final List<LineData> dataList;
  final String xViewInterval;

  CustomLineChart({Key? key, required this.dataList, required this.xViewInterval}) : super(key: key);

  @override
  State<CustomLineChart> createState() => _CustomLineChartState();
}

class _CustomLineChartState extends State<CustomLineChart> {
  @override
  Widget build(BuildContext context) {
     List<LineData> dataListReversed = widget.dataList.reversed.toList();

    return Scaffold(
      // body: Center(
        body: Consumer<ChartDataProvider>(
            builder: (context, provider, _) {
        return LineChartSample2(dataList: provider.fetchInitial
                                ? dataListReversed : widget.dataList,
                                xViewInterval: widget.xViewInterval);
  },
  ),
      // ),
    );
  }
}

class LineChartSample2 extends StatelessWidget {
  LineChartSample2({
    required this.dataList,
    required this.xViewInterval,
    Key? key,
  }) : super(key: key);

  final List<LineData> dataList;
  final String xViewInterval;

  final List<Color> gradientColors = [
    NColors.Pprimary,
    NColors.primary,
  ];

  @override
  Widget build(BuildContext context) {
    bool timeIntervalState = true;
    if (dataList.length < 20){
      timeIntervalState = true;
    }else{
      timeIntervalState = false;
    }

    double? maxSideValue = getMaxSideValue(dataList);
    double adjustedMaxY = (maxSideValue ?? 0) * 1.2;
    double screenHeight = MediaQuery.of(context).size.height;

    double yAxisInterval = calculateYAxisInterval(adjustedMaxY, screenHeight);
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        reverse: true,
        itemCount: 1,
        itemBuilder: (context, index) {
          List<FlSpot> spots = [];
          for (final entry in dataList
              .asMap()
              .entries) {
            spots.add(FlSpot(entry.key.toDouble(), entry.value.sideValue));
            // spots.add(FlSpot(20, 30));
          }

          return SizedBox(
            width: timeIntervalState ? (dataList.length * 60) : (dataList
                .length * 10),
            height: 400,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: LineChart(mainData(spots, yAxisInterval, adjustedMaxY, timeIntervalState)),
              ),
            ),
          );
        },
      );
    // }
    // );
  }

  LineChartData mainData(List<FlSpot> spots, double yAxisInterval, double adjustedMaxY, bool timeIntervalState) {

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
              interval:timeIntervalState ? 1.0 : 30.0,
              getTitlesWidget: (value, titleMeta) {
                // print(value);
                final index = value.toInt();
                if (index >= 0 && index < dataList.length) {
                  final date = dataList[index].date;

                  // final dayOfWeek = DateFormat('EEE').format(date);
                  final dayOfWeek = DateFormat('d').format(date);
                  final monthOfYear = DateFormat('MMM').format(date);
                  final monthOfYearNum = DateFormat('M').format(date);
                  // final monthOfYear = DateFormat('m').format(  `     dat                   Ae);
                  final yearToYear = DateFormat('yy').format(date);// Get the day of the week


                  if (timeIntervalState) {
                    return Text(
                      '${dayOfWeek}/$monthOfYear',
                      // '$dayOfWeek/$monthOfYear/$yearToYear',
                      style: TextStyle(fontSize: 12),
                    );
                  }else {
                    return Text(
                      '$monthOfYear/$yearToYear',
                      style: TextStyle(fontSize: 12),
                    );
                  }
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
      maxX:dataList.length - 1,
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
            colors: gradientColors,
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

double? getMaxSideValue(List<LineData> dataList) {
  if (dataList.isEmpty) {
    return null; // Return null or a default value if the list is empty
  }

  return dataList.map((data) => data.sideValue).reduce((max, value) => max > value ? max : value);
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
