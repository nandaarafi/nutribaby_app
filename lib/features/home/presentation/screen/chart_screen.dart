import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nutribaby_app/core/routes/routes.dart';
import 'package:nutribaby_app/features/authentication/presentation/widgets/custom_date_picker.dart';
import 'package:nutribaby_app/features/home/data/health_data_source.dart';
import 'package:nutribaby_app/features/home/presentation/screen/loading_screen.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';


import '../../../../core/constants/colors.dart';

import '../../../../core/routes/constants.dart';
import '../../domain/health_data_model.dart';
import '../cubit/health_chart_data_cubit.dart';
import '../cubit/health_cubit.dart';
import '../provider/chart_controller.dart';
import '../widgets/app_bar.dart';
import '../widgets/custom_bar_chart.dart';
import '../widgets/custon_line_chart.dart';
import '../widgets/tab_bar.dart';


class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {

  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    // Access data from the DateRangeProvider in initState
    // startDate = Provider.of<DateRangeProvider>(context, listen: false).startDate;
    // endDate = Provider.of<DateRangeProvider>(context, listen: false).endDate;
    // if (startDate != null && endDate != null) {
    //   context.read<HealthChartDataCubit>().fetchNewHealthData(startDate!, endDate!);
    // }
    // context.read<HealthChartDataCubit>().fetchNewHealthData();
    context.read<HealthCubit>().fetchHealthData();
  }


  @override
  void dispose() {
    // passwordController.dispose();
    // ChartProvider.dispose();
    super.dispose();
  }


  final TextEditingController _dateController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  void _applyDateRangeAndCloseModal() {
    // if (_startDate != null && _endDate != null) {
    //   _dateController.text = '${DateFormat('dd/MM/yyyy').format(_startDate!)} -'
    // ignore: lines_longer_than_80_chars
    ' ${DateFormat('dd/MM/yyyy').format(_endDate ?? _startDate!)}';
    // _dateController.text = "$formattedStartDate - $formattedEndDate";/*/
    // }
    Navigator.of(context).pop();
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _startDate = args.value.startDate;
        _endDate  = args.value.endDate ?? args.value.startDate;
        String formattedStartDate = DateFormat('dd MMM, yyyy').format(args.value.startDate);
        String formattedEndDate = DateFormat('dd MMM, yyyy').format(args.value.endDate);

        _dateController.text = "$formattedStartDate - $formattedEndDate";
      //   _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
      //   // ignore: lines_longer_than_80_chars
      //       ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
      //   // _range = _dateController.text;
      // } else if (args.value is DateTime) {
      //   _selectedDate = args.value.toString();
      // } else if (args.value is List<DateTime>) {
      //   _dateCount = args.value.length.toString();
      // } else {
      //   _rangeCount = args.value.length.toString();
      }
    });
  }
  void _refreshScreen(BuildContext context) {
    // Call setState or similar method to trigger a rebuild
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // Navigate to the loading page
      AppRouter.router.go(Routes.loadingNamedPage);

      // Delay navigating back to the HomeScreen by 2 seconds
      Future.delayed(Duration(seconds: 1), () {
        // Navigate back to the HomeScreen
        AppRouter.router.go(Routes.homeChartPage);
      });
    });
  }
  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: MyAppBar(), // Your custom AppBar
        body:// context.read<HealthCubit>().fetchHealthData();,
           Column(
            children: [
              TabBar(
                onTap: (selectedTabIndex) {
                  // Handle tab selection if needed
                },
                tabAlignment: TabAlignment.center,
                labelStyle: Theme
                    .of(context)
                    .textTheme
                    .titleMedium,
                isScrollable: true,
                indicatorColor: Colors.blueAccent,
                unselectedLabelColor: Color(0xff503F95),
          labelColor:Colors.black ,
                tabs: [
                  Tab(child: Text("Berat",
                  style: TextStyle(fontSize: 14),)),
                  Tab(child: Text("Tinggi",
                  style: TextStyle(fontSize: 14))),
                  Tab(child: Text("Kepala",
                  style: TextStyle(fontSize: 14))),
                ],
              ),


              Expanded(
                child: Consumer<ChartDataProvider>(
                  builder: (context, provider, _) {
                    if (provider.fetchInitial) {
                      return BlocBuilder<HealthCubit, HealthState>(
                        builder: (context, state) {
                          if (state is HealthSuccess) {
                            List<LineData> weightDataList1 = state.health['weight'] ?? [];
                            List<LineData> heightDataList1 = state.health['height'] ?? [];
                            List<LineData> headCircumferenceDataList1 = state.health['headCircumference'] ?? [];
                            print("Weight Data List: $weightDataList1");
                            print("Height Data List: $heightDataList1");
                            print("Head Circumference Data List: $headCircumferenceDataList1");
                            return TabBarView(
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                FCategoryTab(dataList: weightDataList1, unit: "kg", restorationId: 'main'),
                                FCategoryTab(dataList: heightDataList1, unit: "cm", restorationId: 'main'),
                                FCategoryTab(dataList: headCircumferenceDataList1, unit: "mm", restorationId: 'main'),
                              ],
                            );
                          } else if (state is HealthFailed) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: NColors.white,
                                content: Text(state.error),
                              ),
                            );
                          }
                          // Default case: return an empty container
                          return Container();
                        },
                      );
                    } else if (provider.showingChart) {
                      return BlocBuilder<HealthChartDataCubit, HealthChartDataState>(
                        builder: (context, state) {
                          if (state is HealthNewSuccess) {
                            List<LineData> weightDataList = state
                                .health['weight'] ?? [];
                            List<LineData> heightDataList = state
                                .health['height'] ?? [];
                            List<LineData> headCircumferenceDataList = state
                                .health['headCircumference'] ?? [];
                            // if (weightDataList.isEmpty ||
                            //     heightDataList.isEmpty ||
                            //     headCircumferenceDataList.isEmpty) {
                            //   provider.setEmptyError(true);
                            // } else{
                              print("Weight Data List: $weightDataList");
                            print("Height Data List: $heightDataList");
                            print(
                                "Head Circumference Data List: $headCircumferenceDataList");
                            return TabBarView(
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                FCategoryTab(dataList: weightDataList,
                                    unit: "kg",
                                    restorationId: 'main'),
                                FCategoryTab(dataList: heightDataList,
                                    unit: "cm",
                                    restorationId: 'main'),
                                FCategoryTab(
                                    dataList: headCircumferenceDataList,
                                    unit: "mm",
                                    restorationId: 'main'),
                              ],
                            );
                          // }
                          }
                          else if (state is HealthNewFailed) {
                            print("an error occured");
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    AlertDialog(
                                      title: Text("Error"),
                                      content: Text(state.error),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            provider.setFetchInitial(true);
                                            provider.setShowingChart(false);
                                            _refreshScreen(context);
                                          },
                                          child: Text("OK"),
                                        ),
                                      ],
                                    ),
                              );
                            });
                          } else{
                            return CircularProgressIndicator();
                          }
                          // Default case: return an empty container
                          return Container();
                        },
                      );
                    }
                    // Return null if neither condition is met
                    return LoadingScreen(
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );

  }


}


