import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/exceptions.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_form_fields.dart';



class ForgotPassScreen extends StatefulWidget {

  const ForgotPassScreen({super.key});
  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  final emailController = TextEditingController();

  @override
  void dispose(){
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget submitButton() {
      return BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is PasswordResetSent) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Password reset email sent successfully, Check Your Email'),
                duration: Duration(seconds: 2),
              ),
            );
          } else if (state is AuthFailed) {
            //WARNING: Undetected showDialog error
            // NHelperFunctions.dismissKeyboard(context);
            // showDialog(
            //   context: context,
            //   builder: (context) => AlertDialog(
            //     title: Text("Error"),
            //     content: Text(state.error),
            //     actions: [
            //       TextButton(
            //         onPressed: () {
            //           Navigator.pop(context);
            //         },
            //         child: Text("OK"),
            //       ),
            //     ],
            //   ),
            // );
            // // ScaffoldMessenger.of(context).showSnackBar(
            // //   SnackBar(
            // //     backgroundColor: Colors.red,
            // //     content: Text(state.error),
            // //   ),
            // // );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return CustomButton(
            title: 'Submit',
            margin: EdgeInsets.only(top: 20),
            onPressed: () {
              String email = emailController.text.trim();
              if (email.isNotEmpty) {
                context.read<AuthCubit>().resetPassword(email);
              } else {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Error"),
                    content: Text(CustomErrorMessages.emailEmpty),
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
                // Handle empty email field
                // Show error message or toast
              }

              // context.read<AuthCubit>().signInRole(
              //   email: emailController.text,
              //   password: passwordController.text,
              // );
            },
          );
        },
      );
    }
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///Headings
            Text("Forget Password", style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            Text("Don’t worry sometimes people can forget too, enter your email and we will send you a password reset link.",
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 12 * 2),
            ///Email
          CustomTextFormField(
      title: 'Email ',
      hintText: 'contoh@gmail.com ',
      controller: emailController,
      icon: Icon(Icons.mail),
    ),
            submitButton(),
          ],
        ),
      ),
    );
  }

}