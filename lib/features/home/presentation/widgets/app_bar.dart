import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:nutribaby_app/core/routes/constants.dart';
import 'package:nutribaby_app/core/routes/routes.dart';

import '../../../authentication/model/auth_data_model.dart';
import '../../../authentication/presentation/cubit/auth_cubit.dart';
import '../screen/add_health_data_screen.dart';
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(60);


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthSuccess) {
          final UserModel user = state.user;
          return AppBar(
            toolbarHeight: 60,
            title: Container(
              // height: 30,
              margin: const EdgeInsets.only(top: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Hai, ',
                          style: TextStyle(
                              color: Colors.black,
                            fontSize: 25
                          ),// Set your desired color
                        ),
                        TextSpan(
                          text: '${user.parentName}',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.7),
                              fontSize: 25

                          ),
                        ),
                        TextSpan(
                          text: ' dan ',
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.7),
                              fontSize: 25

                          ), // Set your desired color
                        ),
                        TextSpan(
                          text: '\nSi Kecil, ',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 25

                          ),                        ),
                        TextSpan(
                          text: '${user.babyName}',
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.7),
                              fontSize: 25

                          ),                        ),
                      ],
                    ),
                  )


                ],
              ),
            ),
          );
        } else {
          // Return a default AppBar or handle other states
          return AppBar(
            title: Text('Rendering Title Error'),
          );
        }
      },
    );
  }

}

class MyAppBarNBack extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(60);


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthSuccess) {
          final UserModel user = state.user;
          return AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                AppRouter.router.go(Routes.addNamedPage);
              },
            ),
            toolbarHeight: 60,
            title: Container(
              // height: 30,
              margin: const EdgeInsets.only(top: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Hai, ',
                          style: TextStyle(
                              color: Colors.black,
                            fontSize: 25
                          ),// Set your desired color
                        ),
                        TextSpan(
                          text: '${user.parentName}',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.7),
                              fontSize: 25

                          ),
                        ),
                        TextSpan(
                          text: ' dan ',
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.7),
                              fontSize: 25

                          ), // Set your desired color
                        ),
                        TextSpan(
                          text: '\nSi Kecil, ',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 25

                          ),                        ),
                        TextSpan(
                          text: '${user.babyName}',
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.7),
                              fontSize: 25

                          ),                        ),
                      ],
                    ),
                  )


                ],
              ),
            ),
          );
        } else {
          // Return a default AppBar or handle other states
          return AppBar(
            title: Text('Rendering Title Error'),
          );
        }
      },
    );
  }

}

class AppBarBack extends StatelessWidget  implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          // Use Navigator to pop the current route and go back
          AppRouter.router.go(Routes.addNamedPage);
        },
      ),
      title: Text('Your App Title'),
    );
  }
}

class AppBarDefault extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AppBarDefault({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
    );
  }
}