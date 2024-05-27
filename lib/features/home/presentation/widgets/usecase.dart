

import 'package:flutter/cupertino.dart';

import '../../../../core/routes/constants.dart';
import '../../../../core/routes/routes.dart';

class UsecaseWidget {
  static final UsecaseWidget _instance = UsecaseWidget._internal();

  factory UsecaseWidget() {
    return _instance;
  }

  UsecaseWidget._internal();

  void refreshScreen(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      AppRouter.router.go(Routes.loadingNamedPage);
      Future.delayed(Duration(seconds: 1), () {
        AppRouter.router.go(Routes.homeChartPage);
      });
    });
  }
}