import 'package:flutter/material.dart';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:nutribaby_app/core/constants/colors.dart';
import 'package:nutribaby_app/core/routes/constants.dart';
import 'package:nutribaby_app/core/routes/routes.dart';
import 'package:nutribaby_app/features/home/presentation/screen/add_health_data_screen.dart';
import 'package:provider/provider.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/helper/helper_functions.dart';

import '../../../home/presentation/cubit/health_cubit.dart';
import '../../../home/presentation/cubit/health_realtime_cubit.dart';

import '../cubit/auth_cubit.dart';
import '../provider/date_picker.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_date_picker.dart';
import '../widgets/custom_text_form_fields.dart';

import '../widgets/custom_text_form_fields_suffix.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});


  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController parentNameController = TextEditingController(text: '');
  final TextEditingController babyNameController = TextEditingController(text: '');
  final TextEditingController genderController = TextEditingController(text: '');
  final TextEditingController emailController = TextEditingController(text: '');

  final TextEditingController passwordController = TextEditingController(text: '');
  final TextEditingController dateNowController = TextEditingController(text: '');
  final TextEditingController dateBirthController = TextEditingController();
  final TextEditingController beratController = TextEditingController();
  final TextEditingController tinggiController = TextEditingController();
  final TextEditingController lingkarKepalaController = TextEditingController();

  // final TextEditingController hobbyController = TextEditingController(text: '');


  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    FocusScope.of(context).unfocus();

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: Provider.of<DateProvider>(context, listen: false).selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      Provider.of<DateProvider>(context, listen: false).updateSelectedDate(pickedDate);
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      dateBirthController.text = formattedDate;
    }
  }



  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    parentNameController.dispose();
    babyNameController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Widget title() {
      return Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Text(
          'Segera Daftar \nuntuk mengecek \nnutrisi si kecil',
          style: Theme.of(context).textTheme.headlineMedium
        ),
      );
    }

    Widget inputSection() {
      Widget parentNameInput() {
        return CustomTextFormField(
          title: 'Nama Orang tua/Wali',
          hintText: 'Masukan Nama Orangtua',
          controller: parentNameController,
          icon: Icon(Iconsax.man),
        );
      }

      Widget babyNameInput() {
        return CustomTextFormField(
          title: 'Nama Bayi',
          hintText: 'Masukan Nama Bayi',
          controller: babyNameController,
          icon: Icon(Iconsax.ruler),
        );
      }
      Widget BeratInput() {
        return CustomTextFormFieldSuffix(
          title: 'Berat',
          hintText: 'Masukan Berat',
          controller: beratController,
          suffixText: 'kg',
          widthSuffix: 50,
        );
      }

      Widget TinggiInput() {
        return CustomTextFormFieldSuffix(
          title: 'Tinggi',
          hintText: 'Masukan Tinggi',
          controller: tinggiController,
          suffixText: 'cm',
          widthSuffix: 58,
        );
      }
      Widget LingkarKepalaInput() {
        return CustomTextFormFieldSuffix(
          title: 'Lingkar Kepala',
          hintText: 'Masukan Lingkar Kepala',
          controller: lingkarKepalaController,
          suffixText: 'mm',
          widthSuffix: 65,
        );
      }


      Widget emailInput() {
        return CustomTextFormField(
          title: 'Email',
          hintText: 'contoh@gmail.com',
          controller: emailController,
          icon: Icon(Icons.mail),
        );
      }
      Widget ageInput() {
        return Consumer<DateProvider>(
            builder: (context, dateProvider, child) {
              return CustomDatePicker(
                OnPressed: () {
                  _selectDate(context);
                },
                title: 'Tanggal Lahir',
                hintText: 'Pilih Tanggal lahir',
                controller: dateBirthController,
              );
            }
          );

      }
      Widget genderInput() {
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Jenis Kelamin',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                hint: const Text('Pilih Jenis Kelamin'),
                value: genderController.text,
                onChanged: (String? newValue) {
                  setState(() {
                    genderController.text = newValue ?? '';
                  });
                },
                items: <String>['','Laki-Laki', 'Perempuan']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,
                    style: Theme.of(context).textTheme.bodyMedium
                    ),
                  );
                }).toList(),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 17,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17),
                    borderSide: BorderSide(color: NColors.primary),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17),
                    borderSide: BorderSide(color: NColors.primary),
                  ),
                ),
              ),
            ],
          ),
        );
      }

      Widget passwordInput() {
        return CustomTextFormField(
          title: 'Password',
          hintText: 'password',
          obsecureText: true,
          controller: passwordController,
          icon: Icon(Icons.password),
        );
      }
      Widget dateInput() {
        return CustomTextFormField(
          title: 'Tanggal Menyimpan Data',
          hintText: '',
          controller: dateNowController,
        );
      }



      Widget GetButton(){
        return BlocConsumer<HealthRealtimeCubit, HealthRealtimeState>(
          listener: (context, state) {
            if (state is HealthRealtimeSuccess) {
              for (var healthRealModel in state.healthReal) {
                beratController.text = healthRealModel.weight.toString();
                tinggiController.text = healthRealModel.height.toString();
                lingkarKepalaController.text = healthRealModel.headCircumference.toString();
                dateNowController.text = healthRealModel.dateNow.toString();
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
                context.read<HealthRealtimeCubit>().fetchRealtime();
              },
            );
          },
        );

      }
      Widget submitButton() {
        return BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              context.read<HealthCubit>().addData(
                  height: double.parse(tinggiController.text),
                  weight: double.parse(beratController.text),
                  headCircumference: double.parse(lingkarKepalaController.text),
                  dateTime: parseDate(dateNowController.text)
              );
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Success"),
                  content: Text("Sukses Mendaftar"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        AppRouter.router.go(Routes.homeChartPage);
                      },
                      child: Text("OK"),
                    ),
                  ],
                ),
              );
            } else if (state is AuthFailed) {
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
            if (state is AuthLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return CustomButton(
              title: 'Daftar',

              margin: EdgeInsets.only(top: 30),
              onPressed: () {

                if (emailController.text.isEmpty ||
                    passwordController.text.isEmpty ||
                    parentNameController.text.isEmpty ||
                    babyNameController.text.isEmpty ||
                    dateBirthController.text.isEmpty ||
                    genderController.text.isEmpty) {
                  // Show an error message or handle it as needed
                  NHelperFunctions.dismissKeyboard(context);
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Error"),
                      content: Text(CustomErrorMessages.requiredField),
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
                } else {

                  // Call signUp method only if all required fields are filled
                  context.read<AuthCubit>().signUp(
                    email: emailController.text,
                    password: passwordController.text,
                    parentName: parentNameController.text,
                    babyName: babyNameController.text,
                    birthdate: parseDate(dateBirthController.text),
                    gender: genderController.text,
                  );



                }
                // context.read<AuthCubit>().signInRole(
                //     email: emailController.text,
                //     password: passwordController.text);
                    },
            );
          },
        );
      }




      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        decoration: BoxDecoration(
          color: NColors.white,
          borderRadius: BorderRadius.circular(17),
        ),
        child: Column(
          children: [
            emailInput(),
            passwordInput(),
            parentNameInput(),
            babyNameInput(),
            ageInput(),
            genderInput(),
            BeratInput(),
            TinggiInput(),
            LingkarKepalaInput(),
            dateInput(),
            GetButton(),
            submitButton(),
          ],
        ),
      );
    }

    Widget signInButton() {
      return GestureDetector(
        onTap: () {
          AppRouter.router.go(Routes.signInNamedPage);
          },
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(
            top: 50,
            bottom: 73,
          ),
          child: Text(
            'Have an account? Sign In',
            style: TextStyle(fontFamily: 'Poppins',
            color: Colors.grey,
            decoration: TextDecoration.underline),
            ),
          ),

      );
    }

    return Scaffold(
      backgroundColor: NColors.white,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: 24,
          ),
          children: [
            title(),
            inputSection(),
            // signInButton(),
          ],
        ),
      ),
    );
  }
}

DateTime parseDate(String dateStr) {
  DateFormat format = new DateFormat("dd-MM-yyyy");
  DateTime dateTime = format.parse(dateStr);
  return dateTime;
  // List<String> parts = dateStr.split('/');
  // if (parts.length != 3) {
  //   throw FormatException("Invalid date format: $dateStr");
  // }
  //
  // int day = int.parse(parts[0]);
  // int month = int.parse(parts[1]);
  // int year = int.parse(parts[2]);
  //
  // return DateTime(year, month, day);
}