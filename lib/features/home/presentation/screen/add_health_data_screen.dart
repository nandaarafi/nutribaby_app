import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';
import 'package:nutribaby_app/core/constants/colors.dart';
import 'package:nutribaby_app/core/helper/helper_functions.dart';
import 'package:nutribaby_app/core/routes/constants.dart';
import 'package:nutribaby_app/core/routes/routes.dart';
import 'package:nutribaby_app/features/authentication/presentation/widgets/custom_text_form_fields_suffix.dart';


import 'package:nutribaby_app/features/home/data/health_data_source.dart';
import 'package:nutribaby_app/features/home/presentation/cubit/health_cubit.dart';
import 'package:nutribaby_app/features/home/presentation/cubit/health_realtime_cubit.dart';

import '../../../authentication/presentation/screen/sign_up_screen.dart';
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
  final TextEditingController headCircumferenceController = TextEditingController(text: '');
  final TextEditingController dateInputController = TextEditingController(text: '');
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void dispose() {
    weightController.dispose();
    heightController.dispose();
    headCircumferenceController.dispose();
    dateInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didpop){
        //DONOTHING
      },
      child: Scaffold(
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
              // nextButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget inputSection() {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        color: NColors.white,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        children: [
          beratInput(),
          tinggiInput(),
          linkarKepalaInput(),
          dateInput(),
          saveButton(),
          SizedBox(height: 30),
          submitButton(),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget beratInput() {
    return CustomTextFormFieldSuffix(
      title: 'Berat',
      hintText: '',
      controller: weightController,
      suffixText: "kg",
      widthSuffix: 80,
    );
  }

  Widget tinggiInput() {
    return CustomTextFormFieldSuffix(
      title: 'Tinggi',
      hintText: '',
      controller: heightController,
      suffixText: "cm",
      widthSuffix: 78,
    );
  }

  Widget linkarKepalaInput() {
    return CustomTextFormFieldSuffix(
      title: 'Lingkar Kepala',
      hintText: '',
      controller: headCircumferenceController,
      suffixText: 'cm',
      widthSuffix: 85,
    );
  }

  Widget dateInput() {
    return CustomTextFormField(
      title: 'Tanggal',
      hintText: '',
      controller: dateInputController,
    );
  }

  Widget saveButton() {
    return BlocConsumer<HealthRealtimeCubit, HealthRealtimeState>(
      listener: (context, state) {
        if (state is HealthRealtimeSuccess) {
          for (var healthRealModel in state.healthReal) {
            print(weightController.text);
            weightController.text = healthRealModel.weight.toString();
            heightController.text = healthRealModel.height.toString();
            headCircumferenceController.text = healthRealModel.headCircumference.toString();
            dateInputController.text = healthRealModel.dateNow.toString();
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
        }
        return CustomButton(
          title: 'Ambil Data',
          onPressed: () {
            context.read<HealthRealtimeCubit>().fetchRealtime();
            // String dateString = '27-02-2002';
            // DateFormat format = new DateFormat("dd-MM-yyyy");
            // // DateTime dateTime = DateTime.now();
            // DateTime dateTime = format.parse(dateString);
            // print(dateTime);
            },
        );
      },
    );
  }

  Widget submitButton() {
    return BlocConsumer<HealthCubit, HealthState>(
      listener: (context, state) {
        if (state is HealthAddedSuccess) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Success"),
              content: Text("Sukses Menambahkan Data"),
              actions: [
                TextButton(
                  onPressed: () {
                    AppRouter.router.pop();
                    AppRouter.router.go(Routes.homeChartPage);
                  },
                  child: Text("OK"),
                ),
              ],
            ),
          );
        } else if (state is HealthFailed) {
          NHelperFunctions.dismissKeyboard(context);
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Error"),
              content: Text(state.error),
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
          onPressed: () {
            context.read<HealthCubit>().addData(
              height: double.parse(heightController.text),
              weight: double.parse(weightController.text),
              headCircumference: double.parse(headCircumferenceController.text),
              dateTime: parseDate(dateInputController.text)
            );
          },
        );
      },
    );
}
    Widget nextButton() {
      return Positioned(
        right: 24,
        bottom: 24, // Adjusted bottom margin for better positioning
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
                        AppRouter.router.pop();
                      },
                      child: Text("OK"),
                    ),
                  ],
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(), backgroundColor: NColors.primary, // Use primary color as background color
          ),
          child: Icon(Icons.arrow_right, color: Colors.white), // Use standard Icons.arrow_right
        ),
      );
    }


  }