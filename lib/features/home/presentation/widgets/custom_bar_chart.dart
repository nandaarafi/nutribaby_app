import 'dart:math' as math;

// import 'package:fl_chart_app/presentation/resources/app_resources.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:nutribaby_app/core/constants/colors.dart';

class BarChartSample7 extends StatefulWidget {
  BarChartSample7({super.key});

  final shadowColor = const Color(0xFFCCCCCC);
  final dataList = [
    _BarData(Colors.yellow, DateTime(2022, 1, 1), 18, 10, 8),
    _BarData(Colors.yellow, DateTime(2022, 1, 1), 18, 10, 8),
    _BarData(Colors.yellow, DateTime(2022, 1, 1), 18, 10, 8),
    _BarData(Colors.yellow, DateTime(2022, 1, 1), 18, 10, 8),
    _BarData(Colors.yellow, DateTime(2022, 1, 1), 18, 10, 8),
    _BarData(Colors.yellow, DateTime(2022, 1, 1), 18, 10, 8),
    _BarData(Colors.yellow, DateTime(2022, 1, 1), 18, 10, 8),
    _BarData(Colors.yellow, DateTime(2022, 1, 1), 18, 10, 8),
    _BarData(Colors.yellow, DateTime(2022, 1, 1), 18, 10, 8),
    _BarData(Colors.yellow, DateTime(2022, 1, 1), 18, 10, 8),
    _BarData(Colors.yellow, DateTime(2022, 1, 1), 18, 10, 8),
    _BarData(Colors.green, DateTime(2022, 1, 2), 17, 8, 10),
    _BarData(Colors.orange, DateTime(2022, 1, 3), 10, 15, 7),
    _BarData(Colors.pink, DateTime(2022, 1, 4), 2.5, 5, 2),
    _BarData(Colors.blue, DateTime(2022, 1, 5), 2, 2.5, 1),
    _BarData(Colors.red, DateTime(2022, 1, 6), 2, 2, 2),
  ];

  @override
  State<BarChartSample7> createState() => _BarChartSample7State();
}

class _BarChartSample7State extends State<BarChartSample7> {
  BarChartGroupData generateBarGroup(
      int x,
      Color color,
      double value,
      double shadowValue,
      double lingkar_kepala,
      ) {
    final DateTime date = widget.dataList[x].date;


  return BarChartGroupData(
      x: date.millisecondsSinceEpoch,
      barRods: [
        BarChartRodData(
          toY: value,
          color: Colors.red,
          width: 6,
        ),
        BarChartRodData(
          toY: shadowValue,
          color: Colors.green,
          width: 6,
        ),
        BarChartRodData(
          toY: lingkar_kepala,
          color: Colors.yellow,
          width: 6,
        ),
      ],
      showingTooltipIndicators: touchedGroupIndex == x ? [0] : [],
    );
  }
  double getMaxYValue(List<_BarData> dataList) {
    double maxValue = double.minPositive;

    for (var data in dataList) {
      if (data.value > maxValue) {
        maxValue = data.value;
      }
      if (data.shadowValue > maxValue) {
        maxValue = data.shadowValue;
      }
      if (data.lingkar_kepala > maxValue) {
        maxValue = data.lingkar_kepala;
      }
    }

    return maxValue;
  }

  int touchedGroupIndex = -1;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: AspectRatio(
          aspectRatio: widget.dataList.length / 4.0,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceBetween,
              borderData: FlBorderData(
                show: true,
                border: Border.symmetric(
                  horizontal: BorderSide(
                    color: NColors.grey,
                  ),
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                leftTitles: AxisTitles(
                  drawBelowEverything: true,
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        textAlign: TextAlign.left,
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 36,
                      getTitlesWidget: (value, titleMeta) {
                        final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                        return Text(
                          '${date.day}/${date.month}',
                          style: TextStyle(fontSize: 12),
                        );
                      }
                    // getTitlesWidget: (value, meta) {
                    //   final index = value.toInt();
                    //   return SideTitleWidget(
                    //     axisSide: meta.axisSide,
                    //     // child: _IconWidget(
                    //     //   color: widget.dataList[index].color,
                    //     //   isSelected: touchedGroupIndex == index,
                    //     // ),
                    //   );
                    // },
                  ),
                ),
                rightTitles: const AxisTitles(),
                topTitles: const AxisTitles(),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true  ,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: NColors.black,
                  strokeWidth: 1,
                ),
              ),
              barGroups: widget.dataList.asMap().entries.map((e) {
                final index = e.key;
                final data = e.value;
                return generateBarGroup(
                  index,
                  data.color,
                  data.value,
                  data.shadowValue,
                  data.lingkar_kepala,
                );
              }).toList(),
              maxY: getMaxYValue(widget.dataList) + 5,
              barTouchData: BarTouchData(
                enabled: true,
                handleBuiltInTouches: true,
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: Colors.transparent,
                  tooltipMargin: 0,
                  getTooltipItem: (
                      BarChartGroupData group,
                      int groupIndex,
                      BarChartRodData rod,
                      int rodIndex,
                      ) {
                    return BarTooltipItem(
                      rod.toY.toString(),
                      TextStyle(
                        fontWeight: FontWeight.bold,
                        color: rod.color,
                        fontSize: 18,
                        shadows: const [
                          Shadow(
                            color: Colors.black26,
                            blurRadius: 12,
                          )
                        ],
                      ),
                    );
                  },
                ),
                touchCallback: (event, response) {
                  if (event.isInterestedForInteractions &&
                      response != null &&
                      response.spot != null) {
                    setState(() {
                      touchedGroupIndex = response.spot!.touchedBarGroupIndex;
                    });
                  } else {
                    setState(() {
                      touchedGroupIndex = -1;
                    });
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BarData {
  const _BarData(this.color, this.date,this.value, this.shadowValue, this.lingkar_kepala);
  final Color color;
  final double value;
  final double shadowValue;
  final double lingkar_kepala;
  final DateTime date;

}
