import 'dart:async';



import 'package:data_collect_v2/helper/boxes.dart';
import 'package:data_collect_v2/providers/location_provider.dart';
import 'package:data_collect_v2/screens/login_screen.dart';
import 'package:data_collect_v2/screens/need_internet_scree.dart';
import 'package:data_collect_v2/utils/internet_connection.dart';
import 'package:data_collect_v2/widgets/loading_spinner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'signup_screen.dart';

class CheckAuthScreen extends StatefulWidget {
  static const routeName = '/check_auth_screen.dart';
  const CheckAuthScreen({Key? key}) : super(key: key);

  @override
  State<CheckAuthScreen> createState() => _CheckAuthScreenState();
}

class _CheckAuthScreenState extends State<CheckAuthScreen> {
  var _isLoading = false;
  var _isError = false;
  var _internentNeededToInitializeApp = false;
  var _isFirstTime = true;

  LocationProvider get locationProvider {
    return Provider.of<LocationProvider>(context, listen: false);
  }

  @override
  void initState() {
    super.initState();
    _getAllAppData();
  }

  Future _getAllAppData() async {
    try {
      setState(() {
        _isLoading = true;
      });
      var internetConnection = await InternetConnection.checkInternetStatus();

      var stateBox = Boxes.getStates();
      var lgaBox = Boxes.getLgas();
      var wardBox = Boxes.getWards();

      if ((stateBox.isEmpty || lgaBox.isEmpty || wardBox.isEmpty) &&
          !internetConnection) {
        _internentNeededToInitializeApp = true;
        return;
      }
      if (stateBox.isEmpty && internetConnection) {
        await locationProvider.addAllStatesToDb();
      }
      if (lgaBox.isEmpty && internetConnection) {
        await locationProvider.addAllLgasToDb();
      }
      if (wardBox.isEmpty && internetConnection) {
        await locationProvider.addAllWardToDb();
      }
      if (stateBox.isNotEmpty) {
        locationProvider.getAllStateFromDb();
      }
      if (lgaBox.isNotEmpty) {
        locationProvider.getAllLgaFromDb();
      }
      if (wardBox.isNotEmpty) {
        locationProvider.getAllWardsFromDb();
      }
      await _checkIfUserHasSeenSignup();
    } catch (error) {
      setState(() {
        _isError = true;
      });
    } finally {
      _isLoading = false;
    }
  }

  Future _checkIfUserHasSeenSignup() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    final oldUser = localStorage.containsKey('old user');
    if (!oldUser) {
      setState(() {
        _isFirstTime = true;
      });
    } else {
      setState(() {
        _isFirstTime = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const LoadingSpinnerWithScaffold()
        : _isError
            ? const ErrorScreenWithScaffoldInitializeApp()
            : _internentNeededToInitializeApp
                ? const NeedInternetScreen()
                : _isFirstTime
                    ? const SignupScreen()
                    : const LoginScreen();
  }
}
