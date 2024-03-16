import 'package:flutter/material.dart';

import '../../../../core/helper/helper_functions.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key,

  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Image(
              width: 500,
              height: 500,
              // width: NHelperFunctions.screenWidth() * 0.8,
              // height: NHelperFunctions.screenHeight() * 0.6,
              image: AssetImage('assets/images/sammy-line-searching.gif'),
            ),
            Text(
                "Loading",
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center
            ),
            const SizedBox(height: 16.0,),
            Container(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(),
            )

          ],
        ),
      ),
    );
  }
}
