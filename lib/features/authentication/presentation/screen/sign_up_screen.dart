import 'package:flutter/material.dart';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nutribaby_app/core/constants/colors.dart';
import 'package:nutribaby_app/core/routes/constants.dart';
import 'package:nutribaby_app/core/routes/routes.dart';
import 'package:nutribaby_app/features/home/presentation/screen/add_health_data_screen.dart';
import 'package:provider/provider.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/helper/helper_functions.dart';
import '../cubit/auth_cubit.dart';
import '../provider/date_picker.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_date_picker.dart';
import '../widgets/custom_text_form_fields.dart';

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
  final TextEditingController passwordController =
  TextEditingController(text: '');
  // final TextEditingController hobbyController = TextEditingController(text: '');

  final TextEditingController _dateController = TextEditingController();
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
      _dateController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
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
                controller: _dateController,
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



      Widget submitButton() {
        return BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Success"),
                  content: Text("Sukses Mendaftar"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        AppRouter.router.go(Routes.homeNamedPage);
                      },
                      child: Text("OK"),
                    ),
                  ],
                ),
              );
              // AppRouter.router.go(Routes.homeNamedPage);
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
              margin: EdgeInsets.only(top: 10),
              onPressed: () {
                // Check if required fields are not blank
                if (emailController.text.isEmpty ||
                    passwordController.text.isEmpty ||
                    parentNameController.text.isEmpty ||
                    babyNameController.text.isEmpty ||
                    _dateController.text.isEmpty ||
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
                    birthdate: parseDate(_dateController.text),
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
  List<String> parts = dateStr.split('/');
  if (parts.length != 3) {
    throw FormatException("Invalid date format: $dateStr");
  }

  int day = int.parse(parts[0]);
  int month = int.parse(parts[1]);
  int year = int.parse(parts[2]);

  return DateTime(year, month, day);
}