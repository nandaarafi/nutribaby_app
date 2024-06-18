import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutribaby_app/core/helper/helper_functions.dart';
import 'package:nutribaby_app/core/routes/constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:device_info_plus/device_info_plus.dart';


import '../../../../core/constants/colors.dart';
import '../../../../core/routes/routes.dart';
import '../../data/auth_remote_data_source.dart';
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
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;
  // ValueNotifier userCredential = ValueNotifier('');

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  List<Permission> statuses = [
    Permission.storage,
  ];
  Future<void> requestPermission() async {
    try {
      for (var element in statuses) {
        if ((await element.status.isDenied ||
            await element.status.isPermanentlyDenied)) {
          await statuses.request();
        }
      }
    } catch (e) {
      // debugPrint('$e');
    } finally {
      await requestPermission();
    }
  }
  void test() async {
    final plugin = DeviceInfoPlugin();
    final android = await plugin.androidInfo;

    final storageStatus = android.version.sdkInt < 33
        ? await Permission.storage.request()
        : PermissionStatus.granted;

    if (storageStatus == PermissionStatus.granted) {
      print("granted");
    }
    if (storageStatus == PermissionStatus.denied) {
      print("denied");
    }
    if (storageStatus == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    }
  }
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
    // test();
    // requestPermission();
  }
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
                      : Icons.visibility_off)
              )
            );
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
                AppRouter.router.go('/add');
                // AppRouter.router.go(Routes.homeNamedPage);
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
            // SizedBox(height: 30),
            // Divider(
            //   height: 20, // Customize the height of the divider
            //   thickness: 2, // Customize the thickness of the divider
            //   color: Colors.grey, // Customize the color of the divider
            // ),
            // SizedBox(height: 30),
            //   GestureDetector(
            //     onTap: _handleGoogleSignIn,
            //
            //
            //     child: Image.asset(
            //       'assets/images/google.png',
            //       width: 50, // Adjust the width of the image
            //       height: 50, // Adjust the height of the image
            //     ),
            //   )

          ],
        ),
      );
    }



    return PopScope(
      canPop: false,
      onPopInvoked: (didpop){

      },
      child: Scaffold(
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
      ),
    );
  }
  void _handleGoogleSignIn(){
    try {
      GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
      _auth.signInWithProvider(_googleAuthProvider);
    } catch (error) {
      print(error);
    }
  }
}