import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutribaby_app/core/constants/colors.dart';
import 'package:nutribaby_app/core/helper/helper_functions.dart';
import 'package:nutribaby_app/features/home/domain/health_data_model.dart';
import 'package:nutribaby_app/features/home/presentation/cubit/health_realtime_cubit.dart';
import 'package:provider/provider.dart';

import '../provider/trends_state_provider.dart';
import 'custom_container_conclusion.dart';

class ConclusionScreen extends StatefulWidget {
  final double weightTrends;
  final double heightTrends;
  final double headCircumferenceTrends;

  ConclusionScreen({
    required this.weightTrends,
    required this.heightTrends,
    required this.headCircumferenceTrends,
  });

  @override
  _ConclusionScreenState createState() => _ConclusionScreenState();
}

class _ConclusionScreenState extends State<ConclusionScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HealthRealtimeCubit>().fetchRealtimeConclusion();

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Schedule the state update after the build is complete
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      context.read<TrendStateProvider>().updateTrendStates(
            weightPercentageChange: widget.weightTrends,
            heightPercentageChange: widget.heightTrends,
            headCircumferencePercentageChange: widget.headCircumferenceTrends,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController statusGiziController = TextEditingController(text: '');
    TextEditingController statusKepalaController = TextEditingController(text: '');

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            Text(
              "Kesimpulan",
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Color(0xff503F95)),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Consumer<TrendStateProvider>(
                    builder: (context, trendStateProvider, _) {
                  return CustomContainerConclusion(
                      trendState: trendStateProvider.weightTrendState,
                      title: "Berat",
                      subtitle: "Berat anda ",
                      trendsText: widget.weightTrends.toString() + " kg");
                }),
                Consumer<TrendStateProvider>(
                    builder: (context, trendStateProvider, _) {
                  return CustomContainerConclusion(
                      trendState: trendStateProvider.heightTrendState,
                      title: "Tinggi",
                      subtitle: "Tinggi anda ",
                      trendsText: widget.heightTrends.toString() + " cm");
                }),
              ],
            ),
            SizedBox(height: 15),
            Center(
              child: Consumer<TrendStateProvider>(
                  builder: (context, trendStateProvider, _) {
                return CustomContainerConclusion(
                    trendState: trendStateProvider.headCircumferenceTrendState,
                    title: "Lingkar Kepala",
                    subtitle: "Lingkar Kepala anda ",
                    widthScreen: NHelperFunctions.screenWidth(context) * 0.6,
                    trendsText: widget.headCircumferenceTrends.toString() + " cm");
              }),
            ),
            SizedBox(height: 15),
            // Text(
            //   "Fuzzy",
            //   textAlign: TextAlign.start,
            //   style: TextStyle(
            //       fontFamily: 'Poppins',
            //       fontWeight: FontWeight.w600,
            //       fontSize: 20,
            //       color: Color(0xff503F95)),
            // ),
            Container(
              width: double.infinity,
              height: NHelperFunctions.screenHeight(context) * 0.20,
              child: BlocConsumer<HealthRealtimeCubit, HealthRealtimeState>(
                listener: (context, state) {
                  if (state is HealthRealtimeConclusionSucces) {
                      // print("Succes");
                  } else if (state is HealthRealtimeFailed) {
                    print("Failed");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: NColors.white,
                        content: Text(state.error),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is HealthRealtimeLoading) {
                    return AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text("Fetching Data..."),
                        ],
                      ),
                    );
                  } else if (state is HealthRealtimeConclusionSucces) {
                    String statusGizi ="";
                    String statusKepala ="";
                    for (var healthRealModel in state.healthReal) {
                      statusGiziController.text = healthRealModel.statusGizi;
                      statusKepalaController.text = healthRealModel.statusKepala;
                      // print(statusKepala);
                    }
                    // List<HealthConclusionModel> conclusion = state.healthReal; // Extract conclusion
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: NHelperFunctions.screenWidth(context) * 0.4,
                          height: NHelperFunctions.screenHeight(context) * 0.13,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Color(0xff503F95), // Set the background color
                            borderRadius:
                            BorderRadius.circular(20), // Set the border radius
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Icon(Icons.abc),
                                  // SizedBox(width: 15),
                                  Text(
                                    "Status",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    color: Colors.white,
                                    // fontSize: 16.0,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: statusGiziController.text,
                                      // text: "Mikrosefali + Normal",
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 17,
                                            color: Colors.white
                                        ),
                                    ),
                                    // TextSpan(text: subtitle),
                                    // TextSpan(
                                    //   text: (widget.trendState ?? false) ? "naik" : "turun",
                                    //   style: TextStyle(
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: NHelperFunctions.screenWidth(context) * 0.4,
                          height: NHelperFunctions.screenHeight(context) * 0.13,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Color(0xff503F95), // Set the background color
                            borderRadius:
                            BorderRadius.circular(20), // Set the border radius
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Icon(Icons.abc),
                                  // SizedBox(width: 15),
                                  Text(
                                    "Status",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    color: Colors.white,
                                    // fontSize: 16.0,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: statusKepalaController.text,
                                      // text: "Mikrosefali + Normal",
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17,
                                          color: Colors.white
                                      ),
                                    ),
                                    // TextSpan(text: subtitle),
                                    // TextSpan(
                                    //   text: (widget.trendState ?? false) ? "naik" : "turun",
                                    //   style: TextStyle(
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  else if (state is HealthRealtimeFailed){
                    return Container();
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
