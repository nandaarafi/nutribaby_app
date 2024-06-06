import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:nutribaby_app/core/constants/colors.dart';


class SignUpScaffoldWithNavBar extends StatelessWidget {
  /// Constructs an [ScaffoldWithNavBar].
  const SignUpScaffoldWithNavBar({
    required this.child,
    super.key,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didpop){
      },
      child: Scaffold(
        body: child,
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(Icons.add),
              label: 'Sign Up',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(Icons.graphic_eq),
              label: 'Data',
            ),
            // BottomNavigationBarItem(
            //   backgroundColor: Colors.white,
            //   icon: Icon(Icons.person),
            //   label: 'Profile',
            // ),
          ],
          currentIndex: _calculateSelectedIndex(context),
          onTap: (int idx) => _onItemTapped(idx, context),
        ),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/sign-up')) {
      return 0;
    }
    if (location.startsWith('/data')) {
      return 1;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/sign-up');
      case 1:
        GoRouter.of(context).go('/data');
    }
  }
}