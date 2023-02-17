
import 'package:data_collect_v2/screens/login_screen.dart';
import 'package:flutter/material.dart';

class AwaitingConfirmationScreen extends StatelessWidget {
  static const routeName = 'awaiting_confirmation.dart';
  const AwaitingConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 10,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Center(
            child: CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(
                'images/dc_logo.png',
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                10,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                      'Thanks for signing up! Before getting started, system admin will verify your account'),
                  const SizedBox(
                    height: 5,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        LoginScreen.routeName,
                        (route) => false,
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      'Log Out',
                      style: TextStyle(
                        color: Colors.black38,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


