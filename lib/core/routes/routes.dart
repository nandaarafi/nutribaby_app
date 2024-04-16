import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nutribaby_app/features/authentication/presentation/screen/login_screen.dart';
import 'package:nutribaby_app/features/home/presentation/screen/chart_screen.dart';
import 'package:nutribaby_app/features/home/presentation/screen/loading_screen.dart';
import 'package:nutribaby_app/features/home/presentation/widgets/calendar.dart';
import 'package:nutribaby_app/features/home/presentation/widgets/custon_line_chart.dart';

import '../../features/authentication/presentation/screen/forgot_password.dart';
import '../../features/authentication/presentation/screen/sign_up_screen.dart';
import '../../features/home/presentation/screen/add_health_data_screen.dart';
import '../errors/routes_error.dart';
import 'constants.dart';
import 'cubit/navigation_cubit.dart';

class AppRouter {

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter _router = GoRouter(
    initialLocation: Routes.signInNamedPage,
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
        path: Routes.signInNamedPage,
        // builder: (BuildContext context, GoRouterState state) => const LoginScreen()
        builder: (BuildContext context, GoRouterState state) =>  LoginScreen()
        //   return LoginPage();
        // },
      ),
      GoRoute(
        path: Routes.signUpNamedPage,
        builder: (BuildContext context, GoRouterState state) => const SignUpScreen()
        //   return HomePage();
        // },
      ),
      GoRoute(
        path: Routes.homeNamedPage,
        builder: (BuildContext context, GoRouterState state) => const AddHealthScreen()
      ),
      GoRoute(
          path: Routes.homeChartPage,
          builder: (BuildContext context, GoRouterState state) => const ChartScreen()
      ),
      GoRoute(
          path: Routes.loadingNamedPage,
          builder: (BuildContext context, GoRouterState state) => const LoadingScreen()
      ),
      GoRoute(
          path: Routes.forgetPassPage,
          builder: (BuildContext context, GoRouterState state) => const ForgotPassScreen()
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),

  );

  static GoRouter get router => _router;
}