import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../errors/routes_error.dart';


class Routes{
  static const rootLogin = '/';
  static const signInNamedPage = '/sign-in';
  static const signUpNamedPage = '/sign-up';
  static const signUpUserDataNamedPage = '/data';
  static const addNamedPage = '/add';
  static const homeChartPage = '/grafik';
  static const profileNamedPage = '/profile';
  static const profileDetailsNamedPage = 'details';
  static const settingsNamedPage = '/settings';
  static const loadingNamedPage = '/loading';
  static const forgetPassPage = '/forgot-pass';


  static Widget errorWidget(BuildContext context, GoRouterState state) =>
      const NotFoundScreen();

}