import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutribaby_app/core/routes/routes.dart';
import 'package:nutribaby_app/features/authentication/presentation/cubit/user_data_cubit.dart';
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
import 'package:flutter/foundation.dart' show kIsWeb;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyDeQjrSF7L3d_IVtI9Jnw5UfTDKsSVz1nI",
        authDomain: "nutrition-app-4fe95.firebaseapp.com",
        databaseURL: "https://nutrition-app-4fe95-default-rtdb.firebaseio.com",
        projectId: "nutrition-app-4fe95",
        storageBucket: "nutrition-app-4fe95.firebasestorage.app",
        messagingSenderId: "833519327871",
        appId: "1:833519327871:web:befb4795f8c64c5d657d4a",
      ),
    );
  } else {
    await Firebase.initializeApp(); // For mobile or other platforms.
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChartProvider()),
        ChangeNotifierProvider(create: (_) => DateProvider()),
        ChangeNotifierProvider(create: (_) => ChartDataProvider()),
        ChangeNotifierProvider(create: (_) => TrendStateProvider()),
        ChangeNotifierProvider(create: (_) => PasswordVisibilityProvider()),
      ],
      child: const AppSizeWrapper(),
    ),
  );
}

class AppSizeWrapper extends StatelessWidget {
  const AppSizeWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Android size (portrait mode)
    const double androidWidth = 360.0;
    const double androidHeight = 640.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Container(
            width: androidWidth,
            height: androidHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: const MyApp(),
            ),
          ),
        );
      },
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => HealthRealtimeCubit()),
        BlocProvider(create: (context) => HealthCubit()),
        BlocProvider(create: (context) => HealthChartDataCubit()),
        BlocProvider(create: (context) => UserDataCubit()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        themeMode: ThemeMode.system,
        theme: NTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}