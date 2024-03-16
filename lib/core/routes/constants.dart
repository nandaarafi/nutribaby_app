import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../errors/routes_error.dart';

class Routes{
  static const rootLogin = '/';
  static const signInNamedPage = '/sign-in';
  static const signUpNamedPage = '/sign-up';
  static const homeNamedPage = '/home';
  static const homeChartPage = '/charts';
  static const profileNamedPage = '/profile';
  static const profileDetailsNamedPage = 'details';
  static const settingsNamedPage = '/settings';
  static const loadingNamedPage = '/loading';
  static Widget errorWidget(BuildContext context, GoRouterState state) => const NotFoundScreen();


}