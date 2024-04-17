import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutribaby_app/core/routes/routes.dart';
import 'package:nutribaby_app/features/authentication/presentation/provider/date_picker.dart';
import 'package:nutribaby_app/features/home/presentation/cubit/health_cubit.dart';
import 'package:nutribaby_app/features/home/presentation/cubit/health_realtime_cubit.dart';
import 'package:provider/provider.dart';
import 'core/theme/theme.dart';
import 'features/authentication/presentation/cubit/auth_cubit.dart';
import 'features/authentication/presentation/provider/password_vis_provider.dart';
import 'features/home/presentation/cubit/health_chart_data_cubit.dart';
import 'features/home/presentation/provider/chart_controller.dart';
import 'features/home/presentation/provider/trends_state_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChartProvider()),
        ChangeNotifierProvider(create: (_) => DateProvider()),
        ChangeNotifierProvider(create: (_) => ChartDataProvider()),
        ChangeNotifierProvider(create: (_) => TrendStateProvider()),
        ChangeNotifierProvider(create: (_) => PasswordVisibilityProvider()),
      ],
      child: const MyApp(),
    ),
      );
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
        create: (context) => AuthCubit(),
          ),
          BlocProvider(
            create: (context) => HealthRealtimeCubit(),
          ), BlocProvider(
            create: (context) => HealthCubit(),
          ),BlocProvider(
            create: (context) => HealthChartDataCubit(),
          ),
        // ], child: MaterialApp(
        ], child: MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      themeMode: ThemeMode.system,
      // theme: ThemeData(
      //   primaryColor: Colors.white,
      // ),
      theme: NTheme.lightTheme,
      // home: SyncChart()
      routerConfig: AppRouter.router,
    ),
    );
  }
}
