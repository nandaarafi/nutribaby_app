import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutribaby_app/core/routes/routes.dart';
import 'package:nutribaby_app/features/home/domain/usecases/calculate_trends_data.dart';
import 'package:nutribaby_app/features/home/presentation/screen/loading_screen.dart';
import 'package:nutribaby_app/features/home/presentation/widgets/tab_bar_conclusion.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/colors.dart';

import '../../../../core/routes/constants.dart';
import '../../domain/health_data_model.dart';
import '../cubit/health_chart_data_cubit.dart';
import '../cubit/health_cubit.dart';
import '../provider/chart_controller.dart';
import '../widgets/app_bar.dart';

import '../widgets/tab_bar.dart';


class ChartScreen extends StatefulWidget {
  const ChartScreen({Key? key}) : super(key: key);

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    context.read<HealthCubit>().fetchHealthData();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: MyAppBar(),
          body: Column(
            children: [
              SizedBox(height: 20),
              TabBar(
                onTap: (selectedTabIndex) {
                },
                tabAlignment: TabAlignment.center,
                labelStyle: Theme.of(context).textTheme.subtitle1,
                isScrollable: true,
                indicatorColor: Colors.blueAccent,
                unselectedLabelColor: Color(0xff503F95),
                labelColor: Colors.black,
                tabs: [
                  Tab(child: Text("Berat", style: TextStyle(fontSize: 14))),
                  Tab(child: Text("Tinggi", style: TextStyle(fontSize: 14))),
                  Tab(child: Text("LingkarKepala", style: TextStyle(fontSize: 14))),
                  Tab(child: Text("Kesimpulan", style: TextStyle(fontSize: 14))),
                ],
              ),
              Expanded(
                child: Consumer<ChartDataProvider>(
                  builder: (context, provider, _) {
                    if (provider.fetchInitial) {
                      return BlocBuilder<HealthCubit, HealthState>(
                        builder: (context, state) {
                          if (state is HealthSuccess) {
                            print(state.health);
                            List<LineData> weightDataList = state.health['weight'] ?? [];
                            List<LineData> heightDataList = state.health['height'] ?? [];
                            List<LineData> headCircumferenceDataList = state.health['headCircumference'] ?? [];

                            double weightTrend = UsecaseModel().calculateTrendPercentageReversed(weightDataList);
                            double heightTrend = UsecaseModel().calculateTrendPercentageReversed(heightDataList);
                            double headCircumferenceTrend = UsecaseModel().calculateTrendPercentageReversed(headCircumferenceDataList);

                            // print("Weight Data List: $weightDataList");
                            // print("Height Data List: $heightDataList");
                            // print("Head Circumference Data List: $headCircumferenceDataList");

                            return TabBarView(
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                FCategoryTab(labelUpdateTable: 'weight',dataList: weightDataList, labelTable: "Berat", unit: " kg", restorationId: 'main'),
                                FCategoryTab(labelUpdateTable: 'height',dataList: heightDataList, labelTable: "Tinggi", unit: " cm", restorationId: 'main'),
                                FCategoryTab(labelUpdateTable:'headCircumference',dataList: headCircumferenceDataList, labelTable: "LingkarKepala", unit: " cm", restorationId: 'main'),
                                ConclusionScreen(weightTrends: weightTrend, heightTrends: heightTrend, headCircumferenceTrends: headCircumferenceTrend),
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
                          return Container();
                        },
                      );
                    } else if (provider.showingChart) {
                      return BlocBuilder<HealthChartDataCubit, HealthChartDataState>(
                        builder: (context, state) {
                          if (state is HealthNewSuccess) {
                            // print(state.health);
                            List<LineData> weightDataList = state.health['weight'] ?? [];
                            List<LineData> heightDataList = state.health['height'] ?? [];
                            List<LineData> headCircumferenceDataList = state.health['headCircumference'] ?? [];


                            double weightTrend = UsecaseModel().calculateTrendPercentage(weightDataList);
                            double heightTrend = UsecaseModel().calculateTrendPercentage(heightDataList);
                            double headCircumferenceTrend = UsecaseModel().calculateTrendPercentage(headCircumferenceDataList);


                            return TabBarView(
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                FCategoryTab(labelUpdateTable: 'weight',dataList: weightDataList, labelTable: "Berat", unit: " kg", restorationId: 'main'),
                                FCategoryTab(labelUpdateTable: 'height',dataList: heightDataList, labelTable: "Tinggi", unit: " cm", restorationId: 'main'),
                                FCategoryTab(labelUpdateTable:'headCircumference',dataList: headCircumferenceDataList, labelTable: "LingkarKepala", unit: " cm", restorationId: 'main'),
                                ConclusionScreen(weightTrends: weightTrend, heightTrends: heightTrend, headCircumferenceTrends: headCircumferenceTrend),
                              ],
                            );
                          } else if (state is HealthNewFailed) {
                            WidgetsBinding.instance!.addPostFrameCallback((_) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Error"),
                                  content: Text(state.error),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        provider.setFetchInitial(true);
                                        AppRouter.router.pop();
                                        provider.setShowingChart(false);
                                        _refreshScreen(context);
                                      },
                                      child: Text("OK"),
                                    ),
                                  ],
                                ),
                              );
                            });
                          }
                          return SingleChildScrollView(
                              child: Container(
                                width: double.infinity,
                                  height: 1000,
                                  child: LoadingScreen())); // Show loading indicator
                        },
                      );
                    }
                    return const LoadingScreen(); // Default loading screen
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  void _refreshScreen(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      AppRouter.router.go(Routes.loadingNamedPage);
      Future.delayed(Duration(seconds: 1), () {
        AppRouter.router.go(Routes.homeChartPage);
      });
    });
  }
}


