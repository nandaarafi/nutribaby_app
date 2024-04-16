//
//
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nutribaby_app/core/constants/colors.dart';
import 'package:nutribaby_app/core/helper/helper_functions.dart';
import 'package:nutribaby_app/features/home/presentation/widgets/zoomable_chart.dart';
import 'package:provider/provider.dart';
import '../../domain/health_data_model.dart';
import '../controller/pagination_controller.dart';
import '../controller/pagination_controller.dart';
import '../controller/pagination_controller.dart';

class CustomLineChart2 extends StatefulWidget {
  CustomLineChart2({Key? key/*, required this.dataList*/}) : super(key: key);

  @override
  State<CustomLineChart2> createState() => _CustomLineChart2State();
}

class _CustomLineChart2State extends State<CustomLineChart2> {
  final scrollController = ScrollController();
  final PaginationProvider paginationProvider = PaginationProvider();
  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
    context.read<PaginationProvider>().fetchNextUsers();
  }


  Future<void> scrollListener() async {
    final provider = context.read<PaginationProvider>();
    if (scrollController.offset >=
        scrollController.position.minScrollExtent / 2 &&
        !scrollController.position.outOfRange) {
      await Future.delayed(Duration(milliseconds: 1000));
      print('Fetching more users...');

      if (provider.hasNext) {
        print('Loading next page...');
        provider.fetchNextUsers();
      }
    }
  }
  @override
  void dispose() {
    scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<PaginationProvider>(
          builder: (context, provider, child) {
            return LineChartSample2(
              dataList: provider.lineData,
              controller: scrollController,
            );
          },
        ),
      ),
    );
  }
}

class LineChartSample2 extends StatelessWidget {
  LineChartSample2({
    required this.dataList,
    required this.controller,
  });

  final List<LineData> dataList;
  final ScrollController controller;

  final List<Color> gradientColors = [
    NColors.Pprimary,
    NColors.primary,
  ];

  @override
  Widget build(BuildContext context) {
    double? maxSideValue = getMaxSideValue(dataList);
    double adjustedMaxY = (maxSideValue ?? 0) * 1.2;
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    double yAxisInterval = calculateYAxisInterval(adjustedMaxY, screenHeight);



    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              reverse: true,
              itemCount: 1,
              controller: controller,
              itemBuilder: (context, index) {
                List<FlSpot> spots = [];
                for (final entry in dataList.asMap().entries) {
                  spots.add(FlSpot(entry.key.toDouble(), entry.value.sideValue));
                }

                return Container(
                  height: 200,
                  width: (dataList.length * 60).toDouble(),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 18.0,
                      left: 0,
                      top: 24,
                      bottom: 12,
                    ),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: LineChart(
                        mainData(spots, yAxisInterval, adjustedMaxY),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (context.read<PaginationProvider>().hasNext)
            Center(
              // padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: (){
                  context.read<PaginationProvider>().fetchNextUsers;
                },
                child: Container(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),

        ],
      ),
    );
  }
  Widget getVerticalTitles(value, TitleMeta meta) {
    TextStyle style;
    if ((value - dataList[0].sideValue).abs() <= 0.1) {
      style = const TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      );
    } else {
      style = const TextStyle(
        color: Colors.black,
        fontSize: 14,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(meta.formattedValue, style: style),
    );
  }
  LineChartData mainData(List<FlSpot> spots, double yAxisInterval, double adjustedMaxY/*double minX, double maxX*/) {

    final DateTime startDate = dataList.isNotEmpty ? dataList.first.date : DateTime.now();
    final DateTime endDate = dataList.isNotEmpty ? dataList.last.date : DateTime.now();

    return LineChartData(
      gridData: FlGridData(
        show: false,
        drawVerticalLine: true,
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
          // drawBelowEverything: true,
          sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 20,
              interval:1,
              getTitlesWidget: (value, titleMeta) {
                final index = value.toInt();
                if (index >= 0 && index < dataList.length) {
                  final date = dataList[index].date;
                  // final dayOfWeek = DateFormat('EEE').format(date);
                  final dayOfWeek = DateFormat('d').format(date);
                  final monthOfYear = DateFormat('MMM').format(date);
                  // final monthOfYear = DateFormat('m').format(date);
                  final yearToYear = DateFormat('yyyy').format(date);// Get the day of the week

                  return Text(
                    '$dayOfWeek/$monthOfYear',
                    // '$dayOfWeek/$monthOfYear/$yearToYear',
                    style: TextStyle(fontSize: 12),
                  );
                }
                return Text('');
              }

          ),
        ),
        leftTitles: AxisTitles(
          drawBelowEverything: false,
          sideTitles: SideTitles(
            showTitles: true,
            interval: yAxisInterval,
            getTitlesWidget: getVerticalTitles,
            // getTitlesWidget: (value, meta) {
            //   return Text(
            //     value.toInt().toString(),
            //     textAlign: TextAlign.center,
            //   );
            // },
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
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [NColors.Pprimary, Color(0xffffffff)],
              stops: [0.1, 0.9],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
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

// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:nutribaby_app/core/constants/colors.dart';
// import 'package:nutribaby_app/core/helper/helper_functions.dart';
// import 'package:nutribaby_app/features/home/presentation/widgets/zoomable_chart.dart';
// import '../../domain/health_data_model.dart';
//
// class CustomLineChart2 extends StatefulWidget {
//   final List<LineData> dataList; // The data list to be passed to the chart
//
//   CustomLineChart2({Key? key, required this.dataList}) : super(key: key);
//
//   @override
//   State<CustomLineChart2> createState() => _CustomLineChart2State();
// }
//
// class _CustomLineChart2State extends State<CustomLineChart2> {
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       body: Center(
//         child: LineChartSample2(widget.dataList),
//       ),
//     );
//   }
// }
//
// class LineChartSample2 extends StatelessWidget {
//   LineChartSample2(this.dataList, {Key? key}) : super(key: key);
//
//   final List<LineData> dataList;
//
//   final List<Color> gradientColors = [
//     NColors.chartPrimary,
//     NColors.chartSecondary,
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     double? maxSideValue = getMaxSideValue(dataList);
//     double adjustedMaxY = (maxSideValue ?? 0) * 1.2;
//     double screenHeight = MediaQuery.of(context).size.height;
//
//     double yAxisInterval = calculateYAxisInterval(adjustedMaxY, screenHeight);
//
//     List<FlSpot> spots = [];
//     for (final entry in dataList.asMap().entries) {
//       spots.add(FlSpot(entry.key.toDouble(), entry.value.sideValue));
//     }
//
//     return SingleChildScrollView(
//       child: Container(
//         width: 400, // Make sure the container takes full width
//         height: 400,
//         child: Padding(
//           padding: const EdgeInsets.only(right: 18.0, left: 42.0, top: 24, bottom: 12), // Add padding for the left titles
//           child: Row( // Use a row to align the chart and left titles
//             children: [
//               Expanded( // Use expanded to make sure the chart takes available space
//                 // child: SingleChildScrollView(
//                 //   scrollDirection: Axis.horizontal,
//                   child: AspectRatio(
//                     aspectRatio: 2,
//                     child: LineChart(
//                       mainData(spots, yAxisInterval, adjustedMaxY),
//                     ),
//                   ),
//                 // ),
//               ),
//               // SizedBox( // Add a SizedBox to keep space for left titles
//               //   width: 42.0, // Adjust the width as per your requirement
//               //   child: Column(
//               //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               //     children: _buildLeftTitles(yAxisInterval, adjustedMaxY),
//               //   ),
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   List<Widget> _buildLeftTitles(double yAxisInterval, double adjustedMaxY) {
//     List<Widget> titles = [];
//     for (int i = 0; i <= adjustedMaxY; i += yAxisInterval.toInt()) {
//       titles.add(
//         Text(
//           i.toString(),
//           textAlign: TextAlign.left,
//         ),
//       );
//     }
//     return titles;
//   }
//
//
//
//   LineChartData mainData(List<FlSpot> spots, double yAxisInterval, double adjustedMaxY /*double minX, double maxX*/) {
//
//     final DateTime startDate = dataList.isNotEmpty ? dataList.first.date : DateTime.now();
//     final DateTime endDate = dataList.isNotEmpty ? dataList.last.date : DateTime.now();
//
//     final List<FlSpot> filteredSpots = [];
//     final List<DateTime> xLabels = [];
//
//     // Filter data within a week
//     for (final entry in dataList) {
//       if (entry.date.isAfter(startDate) && entry.date.isBefore(endDate.add(Duration(days: 7)))) {
//         filteredSpots.add(FlSpot(filteredSpots.length.toDouble(), entry.sideValue));
//         xLabels.add(entry.date);
//       }
//     }
//     List<FlSpot> spots = [];
//     for (final entry in dataList.asMap().entries) {
//       spots.add(FlSpot(entry.key.toDouble(), entry.value.sideValue));
//     }
//     return LineChartData(
//       gridData: FlGridData(
//         show: false,
//         drawVerticalLine: true,
//         // horizontalInterval: 10,
//         // verticalInterval: 10,
//         getDrawingHorizontalLine:  (value) => FlLine(
//           color: NColors.black,
//           strokeWidth: 1,
//         ),
//       ),
//       titlesData: FlTitlesData(
//         show: true,
//         rightTitles: AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         topTitles: AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         bottomTitles: AxisTitles(
//           // drawBelowEverything: true,
//           sideTitles: SideTitles(
//             showTitles: true,
//             reservedSize: 20,
//             interval:1,
//             getTitlesWidget: (value, titleMeta) {
//     final index = value.toInt();
//     if (index >= 0 && index < dataList.length) {
//     final date = dataList[index].date;
//     final dayOfWeek = DateFormat('EEE').format(date); // Get the day of the week
//
//     return Text(
//     dayOfWeek,
//     style: TextStyle(fontSize: 12),
//     );
//               // final date = dataList[value.toInt()].date;
//               // return Text(
//               //   '${date.day}/${date.month}/${date.year}',
//               //   style: TextStyle(fontSize: 12),
//               // );
//             }
//     return Text('');
//     }
//
//           ),
//         ),
//         leftTitles: AxisTitles(
//           drawBelowEverything: true,
//           sideTitles: SideTitles(
//             showTitles: true,
//             interval: yAxisInterval,
//             getTitlesWidget: (value, meta) {
//
//               // int index = value.toInt();
//               // if (index >= 0 && index < dataList.length) {
//               //   double sideValue = dataList[index].sideValue;
//                 return Text(
//                   value.toInt().toString(),
//                   textAlign: TextAlign.left,
//                 );
//
//               // return Text('');
//             },
//             reservedSize: 42,
//
//           ),
//         ),
//       ),
//       borderData: FlBorderData(
//           show: false,
//           border: Border.all(color: const Color(0xff37434d), width: 1)),
//       minX: 0,
//       // maxX: maxX,
//       maxX:  7,
//       // maxX: dataList.length.toDouble() - 1,
//       minY: 0,
//       maxY: adjustedMaxY,
//       // lineTouchData: LineTouchData(enabled: false),
// // Adjust this value according to your data range
//       lineBarsData: [
//         LineChartBarData(
//           spots: spots,
//           isCurved: false,
//           gradient: LinearGradient(
//             colors: gradientColors,
//           ),
//           color: Colors.white,
//           barWidth: 5,
//           isStrokeCapRound: true,
//           dotData: const FlDotData(
//             show: false,
//           ),
//           belowBarData: BarAreaData(
//             show: true,
//             gradient: LinearGradient(
//               colors: gradientColors
//                   .map((color) => color.withOpacity(0.3))
//                   .toList(),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// double? getMaxSideValue(List<LineData> dataList) {
//   if (dataList.isEmpty) {
//     return null; // Return null or a default value if the list is empty
//   }
//
//   return dataList.map((data) => data.sideValue).reduce((max, value) => max > value ? max : value);
// }
// double calculateYAxisInterval(double maxY, double screenHeight) {
//   // Set the desired number of labels on the y-axis
//   const int desiredLabels = 5;
//
//   // Calculate a dynamic interval based on the desired number of labels
//   double interval = (maxY / desiredLabels).ceilToDouble();
//
//   // Ensure the interval is not too small or too large for the screen
//   double maxLabels = screenHeight / 40; // Assuming each label takes up 40 pixels
//   return interval < maxY / maxLabels ? maxY / maxLabels : interval;
// }
// // final datalist = [
// //   _LineData(12.0, DateTime(2022, 1, 1)),
// //   _LineData(20.0, DateTime(2022, 2, 2)),
// //   _LineData(30.0, DateTime(2022, 3, 3)),
// //   _LineData(40.0, DateTime(2022, 4, 4)),
// //   _LineData(50.0, DateTime(2022, 5, 5)),
// //
// //   //What I want to make for OOP  method that call
// // ];

// //
// //
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:nutribaby_app/core/constants/colors.dart';
// import 'package:nutribaby_app/core/helper/helper_functions.dart';
// import 'package:nutribaby_app/features/home/presentation/widgets/zoomable_chart.dart';
// import '../../domain/health_data_model.dart';
//
// class CustomLineChart2 extends StatefulWidget {
//   final List<LineData> dataList; // The data list to be passed to the chart
//
//   CustomLineChart2({Key? key, required this.dataList}) : super(key: key);
//
//   @override
//   State<CustomLineChart2> createState() => _CustomLineChart2State();
// }
//
// class _CustomLineChart2State extends State<CustomLineChart2> {
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       body: Center(
//         child: LineChartSample2(widget.dataList),
//       ),
//     );
//   }
// }
//
// class LineChartSample2 extends StatelessWidget {
//   LineChartSample2(this.dataList, {Key? key}) : super(key: key);
//
//   final List<LineData> dataList;
//
//   final List<Color> gradientColors = [
//     NColors.Pprimary,
//     NColors.primary,
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     double? maxSideValue = getMaxSideValue(dataList);
//     double adjustedMaxY = (maxSideValue ?? 0) * 1.2;
//     double screenHeight = MediaQuery.of(context).size.height;
//
//     double yAxisInterval = calculateYAxisInterval(adjustedMaxY, screenHeight);
//
//
//
//     // Filter data within a month
//     final DateTime startDate = dataList.isNotEmpty ? dataList.first.date : DateTime.now();
//     final DateTime endDate = dataList.isNotEmpty ? dataList.last.date : DateTime.now();
//     final List<FlSpot> filteredSpots = [];
//     final List<DateTime> xLabels = [];
//     return ListView.builder(
//       scrollDirection: Axis.horizontal,
//       reverse: true,
//       itemCount: 1,
//       itemBuilder: (context, index) {
//         return SizedBox(
//           width: 2500,
//           height: 400,
//           child: FutureBuilder<List<FlSpot>>(
//             // Fetch the next set of data when needed
//             future: fetchData(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return CircularProgressIndicator();
//               } else if (snapshot.hasError) {
//                 return Text('Error: ${snapshot.error}');
//               } else {
//                 List<FlSpot> spots = snapshot.data ?? [];
//                 return Padding(
//                   padding: const EdgeInsets.only(
//                     right: 18.0,
//                     left: 0,
//                     top: 24,
//                     bottom: 12,
//                   ),
//                   child: AspectRatio(
//                     aspectRatio: 16 / 9,
//                     child: LineChart(
//                       mainData(spots, yAxisInterval, adjustedMaxY),
//                     ),
//                   ),
//                 );
//               }
//             },
//           ),
//         );
//       },
//     );
//   }
//   // CollectionReference _healthReference = FirebaseFirestore.instance.collection(
//   //     'users');
//   // final FirebaseAuth _auth = FirebaseAuth.instance;
//   // DocumentSnapshot? lastDocument;
//   //
//   // Future<List<FlSpot>> fetchData() async {
//   //   try {
//   //     // Fetch the next set of documents using startAfter
//   //     QuerySnapshot querySnapshot = await _healthReference
//   //         .doc(_auth.currentUser!.uid)
//   //         .collection('health')
//   //         .orderBy("dateTime", descending: false)
//   //         .startAfter([lastDocument])
//   //         .limit(20)
//   //         .get();
//   //
//   //     if (querySnapshot.docs.isNotEmpty) {
//   //       // Update the lastDocument for the next page
//   //       lastDocument = querySnapshot.docs.last;
//   //
//   //       // Process and return the new data
//   //       return querySnapshot.docs.map((doc) {
//   //         // Process your document data and create FlSpot objects
//   //         return FlSpot(/* Extract data from doc */);
//   //       }).toList();
//   //     } else {
//   //       // No more data, return an empty list
//   //       return [];
//   //     }
//   //   } catch (error) {
//   //     throw error;
//   //   }
//   // }
//
//
//   List<Widget> _buildLeftTitles(double yAxisInterval, double adjustedMaxY, int maxSideValue) {
//     List<Widget> titles = [];
//     for (int i = maxSideValue; i <= adjustedMaxY; i -= yAxisInterval.toInt()) {
//       titles.add(
//         Text(
//           i.toString(),
//           textAlign: TextAlign.right,
//         ),
//       );
//     }
//     return titles;
//   }
//   LineChartData mainData(List<FlSpot> spots, double yAxisInterval, double adjustedMaxY/*double minX, double maxX*/) {
//
//     return LineChartData(
//       gridData: FlGridData(
//         show: false,
//         drawVerticalLine: true,
//         getDrawingHorizontalLine:  (value) => FlLine(
//           color: NColors.black,
//           strokeWidth: 1,
//         ),
//       ),
//       titlesData: FlTitlesData(
//         show: true,
//         rightTitles: AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         topTitles: AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         bottomTitles: AxisTitles(
//           // drawBelowEverything: true,
//           sideTitles: SideTitles(
//               showTitles: true,
//               reservedSize: 20,
//               interval:1,
//               getTitlesWidget: (value, titleMeta) {
//                 final index = value.toInt();
//                 if (index >= 0 && index < dataList.length) {
//                   final date = dataList[index].date;
//                   final dayOfWeek = DateFormat('EEE').format(date);
//                   // final dayOfWeek = DateFormat('d').format(date);
//                   final monthOfYear = DateFormat('MMM').format(date);
//                   // final monthOfYear = DateFormat('m').format(date);
//                   final yearToYear = DateFormat('yyyy').format(date);// Get the day of the week
//
//                   return Text(
//                     '$dayOfWeek',
//                     // '$dayOfWeek/$monthOfYear/$yearToYear',
//                     style: TextStyle(fontSize: 12),
//                   );
//                 }
//                 return Text('');
//               }
//
//           ),
//         ),
//         leftTitles: AxisTitles(
//           drawBelowEverything: false,
//           sideTitles: SideTitles(
//             showTitles: true,
//             interval: yAxisInterval,
//             getTitlesWidget: (value, meta) {
//
//               return Text(
//                 value.toInt().toString(),
//                 textAlign: TextAlign.center,
//               );
//
//               // return Text('');
//             },
//             reservedSize: 42,
//
//           ),
//         ),
//       ),
//       borderData: FlBorderData(
//           show: false,
//           border: Border.all(color: const Color(0xff37434d), width: 1)),
//       // minX: minX,
//       minX: 0,
//       // maxX: maxX - 1,
//       maxX:dataList.length - 1,
//       // maxX:7.0,
//       // maxX:3.0,
//       // maxX: dataList.length.toDouble() - 1,
//       backgroundColor: Colors.white,
//       minY: 0,
//       maxY: adjustedMaxY,
//       // lineTouchData: LineTouchData(enabled: false),
// // Adjust this value according to your data range
//       lineBarsData: [
//         LineChartBarData(
//           spots: spots,
//           isCurved: true,
//           gradient: LinearGradient(
//             colors: gradientColors,
//           ),
//           color: Colors.white,
//           barWidth: 5,
//           isStrokeCapRound: true,
//           dotData: const FlDotData(
//             show: false,
//           ),
//           belowBarData: BarAreaData(
//             show: true,
//             gradient: LinearGradient(
//               colors: [NColors.Pprimary, Color(0xffffffff)],
//               stops: [0.1, 0.9],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// double? getMaxSideValue(List<LineData> dataList) {
//   if (dataList.isEmpty) {
//     return null; // Return null or a default value if the list is empty
//   }
//
//   return dataList.map((data) => data.sideValue).reduce((max, value) => max > value ? max : value);
// }
// double calculateYAxisInterval(double maxY, double screenHeight) {
//   // Set the desired number of labels on the y-axis
//   const int desiredLabels = 5;
//
//   // Calculate a dynamic interval based on the desired number of labels
//   double interval = (maxY / desiredLabels).ceilToDouble();
//
//   // Ensure the interval is not too small or too large for the screen
//   double maxLabels = screenHeight / 40; // Assuming each label takes up 40 pixels
//   return interval < maxY / maxLabels ? maxY / maxLabels : interval;
// }
