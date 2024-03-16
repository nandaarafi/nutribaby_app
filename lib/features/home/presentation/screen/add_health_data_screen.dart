import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nutribaby_app/core/constants/colors.dart';
import 'package:nutribaby_app/core/helper/helper_functions.dart';
import 'package:nutribaby_app/core/routes/constants.dart';
import 'package:nutribaby_app/core/routes/routes.dart';
import 'package:nutribaby_app/features/home/data/health_data_source.dart';
import 'package:nutribaby_app/features/home/presentation/cubit/health_cubit.dart';
import 'package:nutribaby_app/features/home/presentation/cubit/health_realtime_cubit.dart';

import '../../../authentication/presentation/widgets/custom_button.dart';
import '../../../authentication/presentation/widgets/custom_text_form_fields.dart';

import '../widgets/app_bar.dart';

class AddHealthScreen extends StatefulWidget {
  const AddHealthScreen({Key? key}) : super(key: key);

  @override
  _AddHealthScreenState createState() => _AddHealthScreenState();
}

class _AddHealthScreenState extends State<AddHealthScreen> {
  final TextEditingController weightController = TextEditingController(text: '');
  final TextEditingController heightController = TextEditingController(text: '');
  final TextEditingController headCircumferenceController =
  TextEditingController(text: '');
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void dispose() {
    weightController.dispose();
    heightController.dispose();
    headCircumferenceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget inputSection() {
      Widget parentNameInput() {
        return CustomTextFormField(
          title: 'Berat',
          hintText: '',
          controller: weightController,
        );
      }

      Widget babyNameInput() {
        return CustomTextFormField(
          title: 'Tinggi',
          hintText: '',
          controller: heightController,
        );
      }

      Widget emailInput() {
        return CustomTextFormField(
          title: 'Lingkar Kepala',
          hintText: '',
          controller: headCircumferenceController,
        );
      }

      Widget saveButton() {
        return BlocConsumer<HealthRealtimeCubit, HealthRealtimeState>(
          listener: (context, state) {
            if (state is HealthRealtimeSuccess) {
              for (var healthRealModel in state.healthReal) {
                weightController.text = healthRealModel.weight.toString();
                heightController.text = healthRealModel.height.toString();
                headCircumferenceController.text = healthRealModel.headCircumference.toString();
              }
            } else if (state is HealthRealtimeFailed) {
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
                      // },
                    // );
            }
            return CustomButton(
              title: 'Ambil Data',
              margin: EdgeInsets.only(top: 10),
              onPressed: () {
                // Call the cubit function to fetch data
                context.read<HealthRealtimeCubit>().fetchRealtime();
              },
            );
          },
        );
      }
      Widget submitButton() {
        // UserModel? user;
        return BlocConsumer<HealthCubit, HealthState>(
          listener: (context, state) {
            if (state is HealthAddedSuccess) {
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(
              //     content: Text("Data Berhasil Ditambahkan"),
              //     duration: Duration(seconds: 2), // Adjust duration as needed
              //   ),
              // );
              // AppRouter.router.go(Routes.homeChartPage);
              AppRouter.router.go(Routes.homeChartPage);
            } else if (state is HealthFailed) {
              print("HealthFailed state received: ${state.error}");
              NHelperFunctions.dismissKeyboard(context);
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Error"),
                  content: Text(state.error),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("OK"),
                    ),
                  ],
                ),
              );

            }
          },
          builder: (context, state) {
            if (state is HealthLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return CustomButton(
              title: 'Simpan Data',
              // margin: EdgeInsets.only(top: 20),
              onPressed: () {
                context.read<HealthCubit>().addData(
                  // id: "test",
                  height: double.parse(heightController.text),
                  weight: double.parse(weightController.text),
                  headCircumference: double.parse(headCircumferenceController.text),
                  // dateTime: DateTime.now(),

                );


              },
            );
          },
        );
      }
      return Container(
        margin: const EdgeInsets.only(top: 30),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 30,
        ),
        decoration: BoxDecoration(
          color: NColors.white,
          borderRadius: BorderRadius.circular(17),
        ),
        child: Column(
          children: [
            parentNameInput(),
            babyNameInput(),
            emailInput(),
            saveButton(),
            SizedBox(height: 30),
            submitButton(),
            SizedBox(height: 30),
          ],
        ),
      );
    }
    Widget nextButton() {
      return Positioned(
        right: 24,
        bottom: kBottomNavigationBarHeight,
        child: ElevatedButton(
          onPressed: () async {
            // Check if data exists
            bool dataExists = await HealthService().checkDataExists();

            if (dataExists) {
              // Data exists, navigate to the next page
              AppRouter.router.push(Routes.homeChartPage);
            } else {
              // Data doesn't exist, show a message or take appropriate action
              NHelperFunctions.dismissKeyboard(context);
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Error"),
                  content: Text("Add your Data First"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("OK"),
                    ),
                  ],
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor: NColors.primary,
          ),
          child: const Icon(Iconsax.arrow_right_3, color: NColors.white),
        ),
      );
    }

    return Scaffold(
      appBar: MyAppBar(),
      backgroundColor: NColors.white,
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.symmetric(horizontal: 24),
              children: [
                inputSection(),
              ],
            ),
            nextButton(),
          ],
        ),
      ),
    );
  }
}