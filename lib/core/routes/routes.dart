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
import 'nav_bar_screen.dart';

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
            return ScaffoldWithNavBar(child: child);
          },
          routes: <RouteBase>[
          GoRoute(
            path: '/add',
            parentNavigatorKey: _shellNavigatorKey,
            pageBuilder: (BuildContext context, GoRouterState state){
              return NoTransitionPage(
                  child: AddHealthScreen()
              );
            }
          ),
          GoRoute(
            path: '/grafik',
            parentNavigatorKey: _shellNavigatorKey,
            pageBuilder: (BuildContext context, GoRouterState state){
              return NoTransitionPage(
              child: ChartScreen());
  }
          ),
          GoRoute(
            path: '/profile',
            parentNavigatorKey: _shellNavigatorKey,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return  NoTransitionPage(
                child: Scaffold(
                  body: Center(child: ElevatedButton(
                      onPressed:() {}, child: Text("Logout"))),
                ),
              );
            }
          ),
        ]
      ),
      GoRoute(
        path: '/sign-in',
        builder: (BuildContext context, GoRouterState state) =>  LoginScreen()
      ),
      GoRoute(
        path: '/sign-up',
        builder: (BuildContext context, GoRouterState state) => const SignUpScreen()
      ),
      GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: '/loading',
          builder: (BuildContext context, GoRouterState state) => const LoadingScreen()
      ),
      GoRoute(
          path: '/forgot-pass',
          builder: (BuildContext context, GoRouterState state) => const ForgotPassScreen()
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),

  );

  static GoRouter get router => _router;
}



// GoRoute(
// path: Routes.homeNamedPage,
// builder: (BuildContext context, GoRouterState state) => const AddHealthScreen()
// ),
// GoRoute(
// path: Routes.homeChartPage,
// builder: (BuildContext context, GoRouterState state) => const ChartScreen()
// ),