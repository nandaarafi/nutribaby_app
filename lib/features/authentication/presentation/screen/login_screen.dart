import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutribaby_app/core/helper/helper_functions.dart';
import 'package:nutribaby_app/core/routes/constants.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/routes/routes.dart';
import '../cubit/auth_cubit.dart';
import '../provider/password_vis_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_form_fields.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});


  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Widget title() {
      return Container(
        margin: const EdgeInsets.only(top: 30),
        child: Text(
          'Login untuk memulai \nAplikasi ini',
          style: Theme.of(context).textTheme.headlineMedium
        ),
      );
    }

    Widget inputSection() {
      Widget emailInput() {
        final emailFocusNode = FocusNode(); // Create a FocusNode
        return CustomTextFormField(
          title: 'Email ',
          hintText: 'contoh@gmail.com ',
          controller: emailController,
          icon: Icon(Icons.mail),
          // focusNode: emailFocusNode,
        );
      }

      Widget passwordInput() {
        final passFocusNode = FocusNode(); // Create a FocusNode
        return Consumer<PasswordVisibilityProvider>(
            builder: (context, passwordVisibilityProvider, _) {
            return CustomTextFormField(
              title: 'Password',
              hintText: 'password',
              onTap: () => FocusScope.of(context).unfocus(),
              obsecureText: passwordVisibilityProvider.obscureText,
              controller: passwordController,
              icon: IconButton(
                  onPressed: () {
                    passwordVisibilityProvider.toggleObscureText();
                  },
                  icon: Icon(
                      passwordVisibilityProvider.obscureText
                      ? Icons.visibility
                      : Icons.visibility_off)));
          }
        );
      }

      Widget forgotPassword(){
        return Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              AppRouter.router.push(Routes.forgetPassPage);
            },
            child: const Text(
              "Lupa Password",
              style: TextStyle(color: NColors.primary),
            ),
          ),
        );
      }

      Widget submitButton() {
        return BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              //Super_admin or users Logic
              if(state.user.role == 'super_admin'){
                AppRouter.router.go(Routes.signUpNamedPage);
              }else{
                AppRouter.router.go(Routes.homeNamedPage);
              }
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
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(
              //     backgroundColor: Colors.red,
              //     content: Text(state.error),
              //   ),
              // );
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return CustomButton(
              title: 'Login',
              margin: EdgeInsets.only(top: 20),
              onPressed: () {
                context.read<AuthCubit>().signInRole(
                  email: emailController.text,
                  password: passwordController.text,
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
          vertical: 29,
        ),
        decoration: BoxDecoration(
          color: NColors.white,
          borderRadius: BorderRadius.circular(17),
        ),
        child: Column(
          children: [
            emailInput(),
            passwordInput(),
            forgotPassword(),
            submitButton(),
          ],
        ),
      );
    }

    Widget signUpButton() {
      return GestureDetector(
        onTap: () {
        AppRouter.router.go(Routes.signUpNamedPage);
        },
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(
            top: 50,
            bottom: 73,
          ),
          child: Text(
            'Don\'t have an account? Sign Up',
            style: TextStyle(
              color: Colors.grey,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: NColors.white,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: 24,
          ),
          children: [
            title(),
            inputSection(),
            // signUpButton(),
          ],
        ),
      ),
    );
  }
}