
import 'package:data_collect_v2/screens/auth_screen.dart';
import 'package:data_collect_v2/utils/my_padding.dart';
import 'package:data_collect_v2/widgets/chip_button.dart';
import 'package:flutter/material.dart';

class NeedInternetScreen extends StatelessWidget {
  const NeedInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: MyPadding.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error,
              color: Colors.red,
              size: 100,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'This app requires internet connection to initialize the first time',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ChipButton(
              text: 'Are you now connected to internet, Reload',
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    CheckAuthScreen.routeName, (route) => false);
              },
            )
          ],
        ),
      ),
    );
  }
}
