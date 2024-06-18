import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nutribaby_app/core/routes/sign_up_nav_bar_screen.dart';
import 'package:nutribaby_app/features/authentication/presentation/screen/login_screen.dart';
import 'package:nutribaby_app/features/home/presentation/screen/chart_screen.dart';
import 'package:nutribaby_app/features/home/presentation/screen/loading_screen.dart';
import 'package:nutribaby_app/features/home/presentation/screen/profile_screen.dart';
import 'package:nutribaby_app/features/home/presentation/widgets/calendar.dart';
import 'package:nutribaby_app/features/home/presentation/widgets/custon_line_chart.dart';

import '../../features/authentication/presentation/screen/data_user_screen.dart';
import '../../features/authentication/presentation/screen/forgot_password.dart';
import '../../features/authentication/presentation/screen/sign_up_screen.dart';
import '../../features/home/presentation/screen/add_health_data_screen.dart';
import '../errors/routes_error.dart';
import 'constants.dart';
import 'home_nav_bar_screen.dart';

class AppRouter {

  static final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
  static final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

  static final GoRouter _router = GoRouter(
    initialLocation: Routes.signInNamedPage,
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    routes: [
      ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) {
            return HomeScaffoldWithNavBar(child: child);
          },
          routes: <RouteBase>[
          GoRoute(
            path: Routes.addNamedPage,
            parentNavigatorKey: _shellNavigatorKey,
            pageBuilder: (BuildContext context, GoRouterState state){
              return NoTransitionPage(
                  child: AddHealthScreen()
              );
            }
          ),
          GoRoute(
            path: Routes.homeChartPage,
            parentNavigatorKey: _shellNavigatorKey,
            pageBuilder: (BuildContext context, GoRouterState state){
              return NoTransitionPage(
              child: ChartScreen());
  }
          ),
          GoRoute(
            path: Routes.profileNamedPage,
            parentNavigatorKey: _shellNavigatorKey,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return  NoTransitionPage(
                  child: ProfilScreen()
              );
            }
          ),
        ]
      ),
      ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) {
            return SignUpScaffoldWithNavBar(child: child);
          },
          routes: <RouteBase>[
            GoRoute(
                path: Routes.signUpNamedPage,
                parentNavigatorKey: _shellNavigatorKey,
                pageBuilder: (BuildContext context, GoRouterState state){
                  return NoTransitionPage(
                      child: SignUpScreen()
                  );
                }
            ),
            GoRoute(
                path: Routes.signUpUserDataNamedPage,
                parentNavigatorKey: _shellNavigatorKey,
                pageBuilder: (BuildContext context, GoRouterState state){
                  return NoTransitionPage(
                      child: ShowUsersScreen());
                }
            ),
          ]
      ),

      GoRoute(
        path: Routes.signInNamedPage,
        builder: (BuildContext context, GoRouterState state) =>  LoginScreen()
      ),
      // GoRoute(
      //   path: Routes.signUpNamedPage,
      //   builder: (BuildContext context, GoRouterState state) => const SignUpScreen()
      // ),
      GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: Routes.loadingNamedPage,
          pageBuilder: (BuildContext context, GoRouterState state) {
            return  NoTransitionPage(
                child: LoadingScreen()
            );
          }
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

