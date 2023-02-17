
import 'package:data_collect_v2/providers/auth_provider.dart';
import 'package:data_collect_v2/screens/awaiting_confirmation_screen.dart';
import 'package:data_collect_v2/screens/initialization_screen.dart';
import 'package:data_collect_v2/screens/offline_dashboard.dart';
import 'package:data_collect_v2/screens/signup_screen.dart';
import 'package:data_collect_v2/utils/alert.dart';
import 'package:data_collect_v2/utils/internet_connection.dart';
import 'package:data_collect_v2/utils/my_colors.dart';
import 'package:data_collect_v2/utils/my_input_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = 'login_screen.dart';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //

  var test = 'hh';
  var _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();

  //
  final numberController = TextEditingController();
  final passwordController = TextEditingController();

  //

  var _isLoading = false;

  Future<void> _launchForgetPasswordUrl() async {
    try {
      final url =
          Uri.parse('https://apc-iccdatacenter.org/forgot-password');
      final status = await launchUrl(url);
      if (!status) {
        Alert.showInfoSnackbar(
          message: 'Error occured loading forget password webpage',
          context: context,
        );
      }
    } catch (error) {
      Alert.showInfoSnackbar(
        message: 'Error occured loading forget password webpage',
        context: context,
      );
    }
  }

  Future _loginUser() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    var internetConnection = await InternetConnection.checkInternetStatus();
    if (!internetConnection) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          OfflineDashboard.routeName, (route) => false);
      return;
    }

    final loginStatus =
        await Provider.of<AuthProvider>(context, listen: false).login(
      phone: numberController.text,
      password: passwordController.text,
    );
    if (loginStatus.status == true) {
      _navigateToDashboard();
    } else if (loginStatus.status == false &&
        loginStatus.message == 'Please verify your account') {
      _showUnverifiedAcctSnackbarAndNavigateToAwaitScreen();
    } else if (loginStatus.status == false) {
      _showSnackBar(loginStatus.message);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      Alert.snackBar(
        message: message,
        context: context,
      ),
    );
  }

  void _showUnverifiedAcctSnackbarAndNavigateToAwaitScreen() {
    _showSnackBar('Your account is unverified');
    Navigator.of(context).pushNamed(AwaitingConfirmationScreen.routeName);
  }

  void _navigateToDashboard() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      InitializationScreen.routeName,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 10,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(
                'images/dc_logo.png',
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 5,
              ),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Phone Number'),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      onFieldSubmitted: ((value) {
                        FocusScope.of(context).unfocus();
                      }),
                      controller: numberController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field can\'t be empty';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 13,
                          horizontal: 10,
                        ),
                        hintText: 'Phone Number',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                        border: MyInputBorder.borderInputBorder,
                        focusedBorder: MyInputBorder.focusedInputBorder,
                        errorBorder: MyInputBorder.errorInputBorder,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text('Password'),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      onFieldSubmitted: ((value) {
                        FocusScope.of(context).unfocus();
                      }),
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field can\'t be empty';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 13,
                          horizontal: 10,
                        ),
                        suffixIcon: IconButton(
                          onPressed: !_obscurePassword
                              ? null
                              : () async {
                                  setState(() {
                                    _obscurePassword = false;
                                  });
                                  await Future.delayed(
                                    const Duration(seconds: 3),
                                  );
                                  setState(() {
                                    _obscurePassword = true;
                                  });
                                },
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: _obscurePassword
                                ? MyColors.primaryColor
                                : Colors.grey,
                          ),
                        ),
                        hintText: 'Password',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                        border: MyInputBorder.borderInputBorder,
                        focusedBorder: MyInputBorder.focusedInputBorder,
                        errorBorder: MyInputBorder.errorInputBorder,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                SignupScreen.routeName, (route) => false);
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            _launchForgetPasswordUrl();
                          },
                          child: const Text(
                            'Forgot your password?',
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        if (_isLoading) const CircularProgressIndicator(),
                        if (!_isLoading)
                          GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              _loginUser();
                            },
                            child: Chip(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  7,
                                ),
                              ),
                              backgroundColor: Colors.black,
                              label: const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 5,
                                ),
                                child: Text(
                                  'LOG IN',
                                  style: TextStyle(
                                    letterSpacing: 2,
                                    color: Colors.white,
                                    // fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
