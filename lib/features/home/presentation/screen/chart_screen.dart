import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutribaby_app/core/routes/routes.dart';
import 'package:nutribaby_app/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:nutribaby_app/features/home/domain/usecases/average_per_month.dart';
import 'package:nutribaby_app/features/home/domain/usecases/calculate_trends_data.dart';
import 'package:nutribaby_app/features/home/presentation/screen/loading_screen.dart';
import 'package:nutribaby_app/features/home/presentation/widgets/tab_bar_conclusion.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/colors.dart';

import '../../../../core/routes/constants.dart';
import '../../../authentication/model/auth_data_model.dart';
import '../../domain/health_data_model.dart';
import '../cubit/health_chart_data_cubit.dart';
import '../cubit/health_cubit.dart';
import '../data/data_tables.dart';
import '../provider/chart_controller.dart';
import '../widgets/app_bar.dart';

import '../widgets/head_circumference_tab_bar.dart';
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
          body: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthSuccess){
                UserModel user = state.user;
                return Column(
                  children: [
                    SizedBox(height: 20),
                    TabBar(
                      onTap: (selectedTabIndex) {
                      },
                      tabAlignment: TabAlignment.center,
                      labelStyle: Theme.of(context).textTheme.titleMedium,
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
                                  DataTables data = DataTables();
                                  // print(state.health);
                                  List<LineData> weightDataList = state.health['weight'] ?? [];
                                  List<LineData> heightDataList = state.health['height'] ?? [];
                                  List<LineData> headCircumferenceDataList = state.health['headCircumference'] ?? [];

                                  double weightTrend = UsecaseModel().calculateTrendPercentageReversed(weightDataList);
                                  double heightTrend = UsecaseModel().calculateTrendPercentageReversed(heightDataList);
                                  double headCircumferenceTrend = UsecaseModel().calculateTrendPercentageReversed(headCircumferenceDataList);

                                  List<LineData> listBoysExpectedWeight2 = data.generateBoysExpectedWeight2(user.birthdate);
                                  List<LineData> listBoysExpectedWeight3 = data.generateBoysExpectedWeight3(user.birthdate);
                                  List<LineData> listBoysExpectedWeightMinus2 = data.generateBoysExpectedWeightMinus2(user.birthdate);
                                  List<LineData> listBoysExpectedWeightMinus3 = data.generateBoysExpectedWeightMinus3(user.birthdate);

                                  List<LineData> listBoysExpectedHeight2 = data.generateBoysExpectedHeight2(user.birthdate);
                                  List<LineData> listBoysExpectedHeight3 = data.generateBoysExpectedHeight3(user.birthdate);
                                  List<LineData> listBoysExpectedHeightMinus2 = data.generateBoysExpectedHeightMinus2(user.birthdate);
                                  List<LineData> listBoysExpectedHeightMinus3 = data.generateBoysExpectedHeightMinus3(user.birthdate);

                                  List<LineData> listGirlExpectedWeight2 = data.generateGirlExpectedWeight2(user.birthdate);
                                  List<LineData> listGirlExpectedWeight3 = data.generateGirlExpectedWeight3(user.birthdate);
                                  List<LineData> listGirlExpectedWeightMinus2 = data.generateGirlExpectedWeightMinus2(user.birthdate);
                                  List<LineData> listGirlExpectedWeightMinus3 = data.generateGirlExpectedWeightMinus3(user.birthdate);

                                  List<LineData> listGirlExpectedHeight2 = data.generateGirlExpectedHeight2(user.birthdate);
                                  List<LineData> listGirlExpectedHeight3 = data.generateGirlExpectedHeight3(user.birthdate);
                                  List<LineData> listGirlExpectedHeightMinus2 = data.generateGirlExpectedHeightMinus2(user.birthdate);
                                  List<LineData> listGirlExpectedHeightMinus3 = data.generateGirlExpectedHeightMinus3(user.birthdate);

                                  List<LineData> weightMonthlyAverage = DataProcessor().calculateMonthlyAverages(weightDataList);
                                  List<LineData> heightMonthlyAverage = DataProcessor().calculateMonthlyAverages(heightDataList);

                                  if (user.gender == 'Laki-Laki') {
                                    return TabBarView(
                                      physics: NeverScrollableScrollPhysics(),
                                      children: [
                                        FCategoryTab(labelUpdateTable: 'weight',dataList: weightMonthlyAverage, labelTable: "Berat", unit: " kg", restorationId: 'main',
                                          expectedList2: listBoysExpectedWeight2,
                                          expectedList3: listBoysExpectedWeight3,
                                          expectedMinus2: listBoysExpectedWeightMinus2,
                                          expectedMinus3: listBoysExpectedWeightMinus3,
                                        ),
                                        FCategoryTab(labelUpdateTable: 'height',dataList: heightMonthlyAverage, labelTable: "Tinggi", unit: " cm", restorationId: 'main',
                                          expectedList2: listBoysExpectedHeight2,
                                          expectedList3: listBoysExpectedHeight3,
                                          expectedMinus2: listBoysExpectedHeightMinus2,
                                          expectedMinus3: listBoysExpectedHeightMinus3,
                                        ),
                                        FCategoryTabHead(labelUpdateTable:'headCircumference',dataList: headCircumferenceDataList, labelTable: "LingkarKepala", unit: " cm", restorationId: 'main'),
                                        ConclusionScreen(weightTrends: weightTrend, heightTrends: heightTrend, headCircumferenceTrends: headCircumferenceTrend),
                                      ],
                                    );
                                  } else {
                                    return TabBarView(
                                      physics: NeverScrollableScrollPhysics(),
                                      children: [
                                        FCategoryTab(labelUpdateTable: 'weight',dataList: weightMonthlyAverage, labelTable: "Berat", unit: " kg", restorationId: 'main',
                                          expectedList2: listGirlExpectedWeight2,
                                          expectedList3: listGirlExpectedWeight3,
                                          expectedMinus2: listGirlExpectedWeightMinus2,
                                          expectedMinus3: listGirlExpectedWeightMinus3,
                                        ),
                                        FCategoryTab(labelUpdateTable: 'height',dataList: heightMonthlyAverage, labelTable: "Tinggi", unit: " cm", restorationId: 'main',
                                          expectedList2: listGirlExpectedHeight2,
                                          expectedList3: listGirlExpectedHeight3,
                                          expectedMinus2: listGirlExpectedHeightMinus2,
                                          expectedMinus3: listGirlExpectedHeightMinus3,
                                        ),
                                        FCategoryTabHead(labelUpdateTable:'headCircumference',dataList: headCircumferenceDataList, labelTable: "LingkarKepala", unit: " cm", restorationId: 'main'),
                                        ConclusionScreen(weightTrends: weightTrend, heightTrends: heightTrend, headCircumferenceTrends: headCircumferenceTrend),
                                      ],
                                    );
                                  }


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
                                  DataTables data = DataTables();

                                  // print(state.health);
                                  List<LineData> weightDataList = state.health['weight'] ?? [];
                                  List<LineData> heightDataList = state.health['height'] ?? [];
                                  List<LineData> headCircumferenceDataList = state.health['headCircumference'] ?? [];


                                  double weightTrend = UsecaseModel().calculateTrendPercentage(weightDataList);
                                  double heightTrend = UsecaseModel().calculateTrendPercentage(heightDataList);
                                  double headCircumferenceTrend = UsecaseModel().calculateTrendPercentage(headCircumferenceDataList);

                                  List<LineData> weightMonthlyAverage = DataProcessor().calculateMonthlyAverages(weightDataList);
                                  List<LineData> heightMonthlyAverage = DataProcessor().calculateMonthlyAverages(heightDataList);

                                  List<LineData> listBoysExpectedWeight2 = data.generateBoysExpectedWeight2(user.birthdate);
                                  List<LineData> listBoysExpectedWeight3 = data.generateBoysExpectedWeight3(user.birthdate);
                                  List<LineData> listBoysExpectedWeightMinus2 = data.generateBoysExpectedWeightMinus2(user.birthdate);
                                  List<LineData> listBoysExpectedWeightMinus3 = data.generateBoysExpectedWeightMinus3(user.birthdate);

                                  List<LineData> listBoysExpectedHeight2 = data.generateBoysExpectedHeight2(user.birthdate);
                                  List<LineData> listBoysExpectedHeight3 = data.generateBoysExpectedHeight3(user.birthdate);
                                  List<LineData> listBoysExpectedHeightMinus2 = data.generateBoysExpectedHeightMinus2(user.birthdate);
                                  List<LineData> listBoysExpectedHeightMinus3 = data.generateBoysExpectedHeightMinus3(user.birthdate);

                                  List<LineData> listGirlExpectedWeight2 = data.generateGirlExpectedWeight2(user.birthdate);
                                  List<LineData> listGirlExpectedWeight3 = data.generateGirlExpectedWeight3(user.birthdate);
                                  List<LineData> listGirlExpectedWeightMinus2 = data.generateGirlExpectedWeightMinus2(user.birthdate);
                                  List<LineData> listGirlExpectedWeightMinus3 = data.generateGirlExpectedWeightMinus3(user.birthdate);

                                  List<LineData> listGirlExpectedHeight2 = data.generateGirlExpectedHeight2(user.birthdate);
                                  List<LineData> listGirlExpectedHeight3 = data.generateGirlExpectedHeight3(user.birthdate);
                                  List<LineData> listGirlExpectedHeightMinus2 = data.generateGirlExpectedHeightMinus2(user.birthdate);
                                  List<LineData> listGirlExpectedHeightMinus3 = data.generateGirlExpectedHeightMinus3(user.birthdate);
                                  if (user.gender == 'Laki-Laki') {
                                    return TabBarView(
                                      physics: NeverScrollableScrollPhysics(),
                                      children: [
                                        FCategoryTab(labelUpdateTable: 'weight',dataList: weightMonthlyAverage, labelTable: "Berat", unit: " kg", restorationId: 'main',
                                          expectedList2: listBoysExpectedWeight2,
                                          expectedList3: listBoysExpectedWeight3,
                                          expectedMinus2: listBoysExpectedWeightMinus2,
                                          expectedMinus3: listBoysExpectedWeightMinus3,
                                        ),
                                        FCategoryTab(labelUpdateTable: 'height',dataList: heightMonthlyAverage, labelTable: "Tinggi", unit: " cm", restorationId: 'main',
                                          expectedList2: listBoysExpectedHeight2,
                                          expectedList3: listBoysExpectedHeight3,
                                          expectedMinus2: listBoysExpectedHeightMinus2,
                                          expectedMinus3: listBoysExpectedHeightMinus3,
                                        ),
                                        FCategoryTabHead(labelUpdateTable:'headCircumference',dataList: headCircumferenceDataList, labelTable: "LingkarKepala", unit: " cm", restorationId: 'main'),
                                        ConclusionScreen(weightTrends: weightTrend, heightTrends: heightTrend, headCircumferenceTrends: headCircumferenceTrend),
                                      ],
                                    );
                                  } else {
                                    return TabBarView(
                                      physics: NeverScrollableScrollPhysics(),
                                      children: [
                                        FCategoryTab(labelUpdateTable: 'weight',dataList: weightMonthlyAverage, labelTable: "Berat", unit: " kg", restorationId: 'main',
                                          expectedList2: listGirlExpectedWeight2,
                                          expectedList3: listGirlExpectedWeight3,
                                          expectedMinus2: listGirlExpectedWeightMinus2,
                                          expectedMinus3: listGirlExpectedWeightMinus3,
                                        ),
                                        FCategoryTab(labelUpdateTable: 'height',dataList: heightMonthlyAverage, labelTable: "Tinggi", unit: " cm", restorationId: 'main',
                                          expectedList2: listGirlExpectedHeight2,
                                          expectedList3: listGirlExpectedHeight3,
                                          expectedMinus2: listGirlExpectedHeightMinus2,
                                          expectedMinus3: listGirlExpectedHeightMinus3,
                                        ),
                                        FCategoryTabHead(labelUpdateTable:'headCircumference',dataList: headCircumferenceDataList, labelTable: "LingkarKepala", unit: " cm", restorationId: 'main'),
                                        ConclusionScreen(weightTrends: weightTrend, heightTrends: heightTrend, headCircumferenceTrends: headCircumferenceTrend),
                                      ],
                                    );
                                  }
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
                );
              } else if (state is AuthFailed){
                return Center(
                  child: Text("Error : ${state.error}"
                  ),
                );
              } else if (state is AuthLoading){
                return Center(child: CircularProgressIndicator(),);
              } return Container();

  },
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


