

import 'package:data_collect_v2/screens/auth_screen.dart';
import 'package:data_collect_v2/screens/login_screen.dart';
import 'package:data_collect_v2/utils/my_colors.dart';
import 'package:data_collect_v2/utils/my_padding.dart';
import 'package:data_collect_v2/widgets/chip_button.dart';
import 'package:flutter/material.dart';

class LoadingSpinnerWithScaffold extends StatelessWidget {
  const LoadingSpinnerWithScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          backgroundColor: MyColors.buttonColor,
        ),
      ),
    );
  }
}

class ErrorScreenWithScaffold extends StatelessWidget {
  const ErrorScreenWithScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(
            child: Icon(
              Icons.error,
              color: Colors.red,
              size: 100,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'An error occurred',
            style: TextStyle(fontSize: 20),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  LoginScreen.routeName, (route) => false);
            },
            child: const Text(
              'Go Back',
            ),
          )
        ],
      ),
    );
  }
}

class ErrorScreenWithScaffoldInitializeApp extends StatelessWidget {
  const ErrorScreenWithScaffoldInitializeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: MyPadding.screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Icon(
                Icons.error,
                color: Colors.red,
                size: 100,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'An error occurred while initializing app',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            ChipButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    CheckAuthScreen.routeName, (route) => false);
              },
              text: 'Try Again',
            )
          ],
        ),
      ),
    );
  }
}
