import 'package:flutter/material.dart';
import 'package:nutribaby_app/core/routes/constants.dart';
import 'package:nutribaby_app/core/routes/routes.dart';

import '../../data/health_data_source.dart';

class ProfilScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              try {
                // Attempt to sign out asynchronously
                await HealthService().signOut();
                // If sign-out succeeds, navigate to sign-in page
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Succes'),
                    content: Text('Berhasil Logout'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          AppRouter.router.go(Routes.signInNamedPage);
                        },
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );

              } catch (e) {
                // Handle sign-out error
                print('Sign-out failed: $e');
                // Show a snackbar, dialog, or error message to the user
                // For example, display an error dialog
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Sign-out Error'),
                    content: Text('Failed to sign out. Please try again.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          AppRouter.router.pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            },
            child: Text('Logout'),
          ),
        ),
      ),
    );
  }

}