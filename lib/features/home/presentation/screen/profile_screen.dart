import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutribaby_app/core/routes/constants.dart';
import 'package:nutribaby_app/core/routes/routes.dart';
import 'package:nutribaby_app/features/authentication/model/auth_data_model.dart';
import 'package:nutribaby_app/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:nutribaby_app/features/home/presentation/widgets/app_bar.dart';

import '../../../../core/constants/colors.dart';
import '../../../authentication/presentation/widgets/custom_button.dart';
import '../../data/health_data_source.dart';

class ProfilScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBarDefault(title: "Profile",),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: BlocBuilder<AuthCubit, AuthState>(
  builder: (context, state) {
    if (state is AuthSuccess){
      final UserModel user = state.user;
      return Column(
        children: [
          // SizedBox(height: 50),
          CustomContainerBorder(
            title: "Email",
            subtitle: user.email,
          ),
          CustomContainerBorder(
            title: "Nama Bayi",
            subtitle: user.babyName,
          ),
          CustomContainerBorder(
            title: "Nama Orang Tua",
            subtitle: user.parentName,
          ),
          CustomContainerBorder(
            title: "Jenis Kelamin Bayi",
            subtitle: user.gender,
          ),
          CustomContainerBorder(
            title: "Umur",
            subtitle: agregateBirthdate(user.birthdate),
          ),
          CustomButton(
            title: "Logout",
            onPressed: () async {
              try {
                // Attempt to sign out asynchronously
                await HealthService().signOut();
                // If sign-out succeeds, navigate to sign-in page
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Succes'),
                    content: Text('Berhasil Logout'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          AppRouter.router.go(Routes.signInNamedPage);
                        },
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );

              } catch (e) {
                // Handle sign-out error
                print('Sign-out failed: $e');
                // Show a snackbar, dialog, or error message to the user
                // For example, display an error dialog
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Sign-out Error'),
                    content: Text('Failed to sign out. Please try again.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          AppRouter.router.pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      );
    }
    else if (state is AuthLoading){
      return Center(child: CircularProgressIndicator());
    }
    else {
      return Container();
    }

  },
),
        ),
      ),
    );
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
      ageString += '${years} ${years == 1 ? 'tahun' : 'tahun'}';
    }

    if (months > 0) {
      if (ageString.isNotEmpty) {
        ageString += ' ';
      }
      ageString += '${months} ${months == 1 ? 'bulan' : 'bulan'}';
    }

    if (days > 0) {
      if (ageString.isNotEmpty) {
        ageString += ' ';
      }
      ageString += '${days} ${days == 1 ? 'hari' : 'hari'}';
    }
    // const int maxLength = 15; // Maximum length for the truncated text
    // if (ageString.length > maxLength) {
    //   ageString = ageString.substring(0, maxLength) + '...';
    // }
    return ageString;
  }


}

class CustomContainerBorder extends StatelessWidget {
  final String title;
  final String subtitle;

  const CustomContainerBorder({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
            Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(
                height: 6,
              ),
              Container(
                width: double.infinity,
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 15),
                // width: 100,
                decoration: BoxDecoration(
                    border: Border.all(color: NColors.primary),
                    borderRadius: BorderRadius.circular(17)
                ),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            subtitle
                        )),

              ),
              SizedBox(height: 20),

            ],
          );


  }
}