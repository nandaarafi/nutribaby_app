
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutribaby_app/core/helper/helper_functions.dart';
import 'package:nutribaby_app/core/routes/routes.dart';
import 'package:nutribaby_app/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/colors.dart';
import '../../../authentication/model/auth_data_model.dart';
import '../../../authentication/presentation/widgets/custom_date_picker.dart';
import '../../data/health_data_source.dart';
import '../../domain/health_data_model.dart';
import '../cubit/health_chart_data_cubit.dart';
import '../provider/chart_controller.dart';
import 'custon_line_chart.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class FCategoryTab extends StatefulWidget {
  final List<LineData> dataList;
  final String unit;
  final String labelTable;
  final String? restorationId;
  final String labelUpdateTable;

  FCategoryTab({
    required this.dataList,
    required this.unit,
    required this.labelUpdateTable,
    required this.labelTable,
    required this.restorationId,
  });

  @override
  _FCategoryTabState createState() => _FCategoryTabState();
}

class _FCategoryTabState extends State<FCategoryTab> /*with RestorationMixin*/ {
  List<double> testData = [2781, 2667, 2785, 1031, 646, 2340, 2410];

  @override
  void initState() {
    // //TODO: Argument to Kesimpulan
    // double trend = calculateTrend(widget.dataList);
    // print(trend);
    super.initState();
  }
  final TextEditingController _dateController = TextEditingController();

  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  DateTime? _startDate;
  DateTime? _endDate;
  void _applyDateRangeAndCloseModal() {
    String formattedStartDate = _startDate != null
        ? DateFormat('dd MMM, yyyy').format(_startDate!)
        : '';
    String formattedEndDate =
        _endDate != null ? DateFormat('dd MMM, yyyy').format(_endDate!) : '';

    _dateController.text = "$formattedStartDate - $formattedEndDate";
    AppRouter.router.pop();
    // Navigator.of(context).pop();
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _startDate = args.value.startDate;
        _endDate = args.value.endDate ?? args.value.startDate;
        String formattedStartDate =
            DateFormat('dd MMM, yyyy').format(args.value.startDate);
        String formattedEndDate = args.value.endDate != null
            ? DateFormat('dd MMM, yyyy').format(args.value.endDate!)
            : '';
        _dateController.text = "$formattedStartDate - $formattedEndDate";
        _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
            // ignore: lines_longer_than_80_chars
            ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
        // _range = _dateController.text;
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  List<String> list = <String>['weeks', 'month'];
  String selectedValue = 'weeks';

  @override
  Widget build(BuildContext context) {
    List<LineData> dataListReversed = widget.dataList.reversed.toList();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //Dropdown week month
              // Align(
              //   widthFactor: 4,
              //   alignment: Alignment.centerRight,
              //   child: Consumer<ChartProvider>(
              //     builder: (context, provider, _) => DropdownButton<String>(
              //       value: provider.selectedValue,
              //       items: list.map((String value) {
              //         return DropdownMenuItem<String>(
              //           value: value,
              //           child: Text(value),
              //         );
              //       }).toList(),
              //       onChanged: (String? newValue) {
              //         provider.setSelectedValue(newValue!);
              //         // TODO: Handle the change in selected value, update the chart accordingly
              //       },
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: NHelperFunctions.screenWidth(context) * 0.6,
                      child: CustomDatePicker(
                        OnPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext builderContext) {
                              return Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Container(
                                    color: Colors.white,
                                    height: 400,
                                    child: Column(
                                      children: [
                                        SfDateRangePicker(
                                          onSelectionChanged:
                                              _onSelectionChanged,
                                          selectionMode:
                                              DateRangePickerSelectionMode
                                                  .range,
                                          selectionColor: Colors.black,
                                          minDate: DateTime.now()
                                              .subtract(Duration(days: 365)),
                                          maxDate: DateTime.now(),
                                        ),
                                        TextButton(
                                          onPressed:
                                              _applyDateRangeAndCloseModal,
                                          child: Text('OK'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                          //TODO: Make this
                        },
                        title: "",
                        hintText: "Pilih Data",
                        controller: _dateController,
                      ),
                    ),
                    SizedBox(width: 20),
                    // Align(
                    //   alignment: Alignment.bottomLeft,
                    GestureDetector(
                      onTap: () async {
                        if (_startDate == null || _endDate == null) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Error"),
                              content: Text("Date Range is Empty"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    AppRouter.router.pop();
                                  },
                                  child: Text("OK"),
                                ),
                              ],
                            ),
                          );
                        } else {
                          ChartDataProvider provider = Provider.of<ChartDataProvider>(context, listen: false);

                          provider.setShowingChart(false);
                          provider.setLoadingState(false);

                          try {
                            await context.read<HealthChartDataCubit>().fetchNewHealthData(_startDate!, _endDate!);
                            // if (provider.emptyError) {
                            //  print("Empty List");
                            //   // Setting states after successful fetch
                            // }else{
                            provider.setLoadingState(true);
                            provider.setShowingChart(true);
                            provider.setFetchInitial(false);
                            widget.dataList.clear();
                          } catch (error) {
                            print('Error fetching data: $error');

                          }
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        height: 60,
                        width: 70,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xff503F95),
                          border: Border.all(color: NColors.primary),
                          borderRadius: BorderRadius.circular(17),
                        ),
                        // color: Colors.black,
                        child: Center(
                          child: Text(
                            "Cari",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Consumer<ChartDataProvider>(
                builder: (context, provider, _) => Container(
                  height: NHelperFunctions.screenHeight(context) * 0.23,
                  width: double.infinity,
                  child: provider.LoadingState
                      ? CustomLineChart2(
                          dataList: widget.dataList,
                          xViewInterval: "",
                          // selectedValue: provider.selectedValue,
                        )
                      : Center(
                          child: Container(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Status Gizi",
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Color(0xff503F95)),
                    ),
                    SizedBox(height: 5),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: NHelperFunctions.screenHeight(context) * 0.13,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0xff503F95)
                            // color: Colors.white
                            ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  NHelperFunctions.screenWidth(context) * 0.09),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: NHelperFunctions.screenHeight(context) *
                                    0.07,
                                width: NHelperFunctions.screenWidth(context) *
                                    0.14,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Color(0xff36CBD8)),
                                child: Row(
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      widget.dataList.isNotEmpty
                                          ? (widget.dataList.length - 1)
                                              .toString()
                                          : '0',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 23,
                                      ),
                                    ),
                                    Text(
                                      "th",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 22),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Consumer<ChartDataProvider>(
                                    builder: (context, provider, _) {
                                      List<LineData> dataList =
                                          provider.fetchInitial
                                              ? widget.dataList
                                              : dataListReversed;
                                      return RichText(
                                        text: TextSpan(
                                            style: DefaultTextStyle.of(context)
                                                .style,
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: dataList.isNotEmpty
                                                    ? dataList[0]
                                                        .sideValue
                                                        .toString()
                                                    : '0',
                                                style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 20,
                                                    color: Colors.white),
                                              ),
                                              TextSpan(
                                                // text: " kg",
                                                text: "${widget.unit ?? 'N/A'}",
                                                style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 20,
                                                    color: Colors.white),
                                              ),
                                            ]),
                                      );
                                    },
                                  ),
                                  BlocBuilder<AuthCubit, AuthState>(
                                    builder: (context, state) {
                                      if (state is AuthSuccess) {
                                        final UserModel user = state.user;

                                        return Text(
                                            "Age ${agregateBirthdate(user.birthdate)}",
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w300,
                                                fontSize: 11,
                                                color: Colors.white),
                                            overflow: TextOverflow
                                                .ellipsis, // Display '...' when text overflows
                                            maxLines:
                                                1); // Limit to one line                                        );
                                      } else {
                                        return Text("Error");
                                      }
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(width: 20),
                              // Text(
                              //   "Sehat",
                              //   style: TextStyle(
                              //       fontFamily: 'Poppins',
                              //       fontWeight: FontWeight.w400,
                              //       fontSize: 22,
                              //       color: Colors.white),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Table Data",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Color(0xff503f95)),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: NHelperFunctions.screenHeight(context) * 0.3,
                      width: NHelperFunctions.screenWidth(context) * 0.9,
                      child: Consumer<ChartDataProvider>(
                        builder: (context, provider, _) {
                          List<LineData> dataList = provider.fetchInitial
                              ? widget.dataList
                              : dataListReversed;
                          return DataTable2(
                            columnSpacing: 6,
                            horizontalMargin: 6,
                            minWidth: 300,
                            columns: [
                              DataColumn2(
                                label: Text(widget.labelTable),
                                size: ColumnSize.M,
                              ),
                              DataColumn2(
                                label: Text('Date'),
                                size: ColumnSize.M,
                              ),
                              DataColumn2(
                                label: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(''),
                                ),
                                size: ColumnSize.S,
                              ),
                            ],
                            // rows: provider.fetchInitial ? dataListReversed
                            rows: dataList
                                .map((lineData) => DataRow(
                                      cells: [
                                        DataCell(Text(
                                            '${lineData.sideValue.toString()} ${widget.unit}')),
                                        DataCell(Text(DateFormat('dd-MM-yyyy')
                                            .format(lineData.date))),
                                        DataCell(
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.edit),
                                                onPressed: () {
                                                  _showEditDialog(lineData);
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ))
                                .toList(),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    //GenerateData
                    // ElevatedButton(
                    //   onPressed: () async {
                    //     try {
                    //       await HealthService().generateRawData(
                    //         startDate: DateTime(2023, 10, 26),
                    //         endDate: DateTime(2023, 12, 31),
                    //       );
                    //       // Optionally, you can notify the user that the data has been generated
                    //       showDialog(
                    //         context: context,
                    //         builder: (context) => AlertDialog(
                    //           title: Text("Success"),
                    //           content: Text("Generate your data success"),
                    //           actions: [
                    //             TextButton(
                    //               onPressed: () {
                    //                 Navigator.pop(context);
                    //               },
                    //               child: Text("OK"),
                    //             ),
                    //           ],
                    //         ),
                    //       );
                    //     } catch (e) {
                    //       // Handle errors
                    //       print('Error generating raw data: $e');
                    //     }
                    //   },
                    //   child: Text('Generate Raw Data'),
                    // ),
                  ],
                ),
              ),

              // child: LineChartSample9()),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(LineData lineData) {
    TextEditingController sideValueController =
        TextEditingController(text: lineData.sideValue.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Edit Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // width: 68,
                child: TextFormField(
                  controller: sideValueController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: widget.labelTable, suffixText: widget.unit),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Date: ${DateFormat('dd-MM-yyyy').format(lineData.date)}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // Update lineData with new values
                lineData.sideValue = double.parse(sideValueController.text);
                // Close the dialog
                AppRouter.router.pop();
                //WARNING: No State Management Update, just right on from data source :)
                await HealthService()
                    .updateHealthData(widget.labelUpdateTable, lineData);
                setState(() {});
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                AppRouter.router.pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

String agregateBirthdate(DateTime birthDate) {
  // DateTime birthDate = DateTime.parse("2022-01-25 11:17:15.446");
  DateTime currentDate = DateTime.now();
  Duration ageDifference = currentDate.difference(birthDate);

  int years = ageDifference.inDays ~/ 365;
  int months = (ageDifference.inDays % 365) ~/ 30;
  int days = ageDifference.inDays % 30;

  String ageString = '';

  if (years > 0) {
    ageString += '${years} ${years == 1 ? 'year' : 'years'}';
  }

  if (months > 0) {
    if (ageString.isNotEmpty) {
      ageString += ' ';
    }
    ageString += '${months} ${months == 1 ? 'month' : 'months'}';
  }

  if (days > 0) {
    if (ageString.isNotEmpty) {
      ageString += ' ';
    }
    ageString += '${days} ${days == 1 ? 'day' : 'days'}';
  }
  // const int maxLength = 15; // Maximum length for the truncated text
  // if (ageString.length > maxLength) {
  //   ageString = ageString.substring(0, maxLength) + '...';
  // }
  return ageString;
}
