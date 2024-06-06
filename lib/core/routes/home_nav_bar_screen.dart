import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:nutribaby_app/core/constants/colors.dart';


class HomeScaffoldWithNavBar extends StatelessWidget {
  /// Constructs an [ScaffoldWithNavBar].
  const HomeScaffoldWithNavBar({
    required this.child,
    super.key,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    List<IconData> iconsBefore = [
      IconsaxOutline.home,
      IconsaxOutline.shop,
      IconsaxOutline.heart,
      IconsaxOutline.profile_circle,
    ];
    List<IconData> iconsAfter = [
      IconsaxBold.home,
      IconsaxBold.shop,
      IconsaxBold.heart,
      IconsaxBold.profile_circle,
    ];
    List<String> labelIcon = [
      "Home",
      "Shop",
      "Favorite",
      "Profile",
    ];
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
              label: 'Tambah',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(Icons.graphic_eq),
              label: 'Grafik',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _calculateSelectedIndex(context),
          onTap: (int idx) => _onItemTapped(idx, context),
        ),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/add')) {
      return 0;
    }
    if (location.startsWith('/grafik')) {
      return 1;
    }
    if (location.startsWith('/profile')) {
      return 2;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/add');
      case 1:
        GoRouter.of(context).go('/grafik');
      case 2:
        GoRouter.of(context).go('/profile');
    }
  }
}