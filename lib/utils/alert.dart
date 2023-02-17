import 'package:flutter/material.dart';

class Alert {
  static void showInfoSnackbar(
      {required String message, required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(
      Alert.snackBar(
        message: message,
        context: context,
      ),
    );
  }

  static SnackBar snackBar(
      {required String message, required BuildContext context}) {
    return SnackBar(
      elevation: 100,
      backgroundColor: Colors.black,
      behavior: SnackBarBehavior.floating,
      content: Text(message),
      action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
          }),
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
    );
  }

  static Future showInfoDialog(BuildContext context, String message) async {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            elevation: 30,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 15,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.done_all,
                    size: 30,
                    color: Colors.green,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Registration Successful',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Chip(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      label: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
