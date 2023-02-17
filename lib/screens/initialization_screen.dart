
import 'package:data_collect_v2/helper/boxes.dart';
import 'package:data_collect_v2/providers/voters_info_provider.dart';
import 'package:data_collect_v2/screens/dashboard_screen.dart';
import 'package:data_collect_v2/widgets/loading_spinner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class InitializationScreen extends StatefulWidget {
  static const routeName = '/initialization_screen.dart';
  const InitializationScreen({super.key});

  @override
  State<InitializationScreen> createState() => _InitializationScreenState();
}

class _InitializationScreenState extends State<InitializationScreen> {
  var _isLoading = false;
  var _isError = false;

  @override
  void initState() {
    super.initState();
    _getUserDetails();
  }

  Future _getUserDetails() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await authProvider.getUserDetails();
      await authProvider.getRegisteredGroups();
      await authProvider.getRegisteredIndividuals();
      _sendOfflineUsersOnline();
    } catch (error) {
      setState(() {
        _isError = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future _sendOfflineUsersOnline() async {
    final groupBox = Boxes.getGroups();
    final individualBox = Boxes.getIndividual();
    if (groupBox.values.isEmpty && individualBox.values.isEmpty) {
      return;
    }

    if (individualBox.values.isNotEmpty) {
      for (var element in individualBox.values) {
        await Provider.of<VotersInfoProvider>(context, listen: false)
            .addIndividual(
          name: element.name,
          phone: element.phone,
          cphone: element.cphone,
          zone: element.zone,
          state: element.state,
          lga: element.lga,
          ward: element.ward,
          vstate: element.vstate,
          vlga: element.vlga,
          vward: element.vward,
          category: element.category,
          pollingUnit: element.pollingUnit,
          demand: element.demand,
          userId: authProvider.user.id,
          vinNumber: element.vinNumber
        );
        await element.delete();
      }
    }

    if (groupBox.values.isNotEmpty) {
      for (var element in groupBox.values) {
        await Provider.of<VotersInfoProvider>(context, listen: false).addGroup(
          context: context,
          name: element.name,
          phone: element.phone,
          cname: element.cname,
          secretary: element.secretary,
          zone: element.zone,
          state: element.state,
          lga: element.lga,
          ward: element.ward,
          demand: element.demand,
          userId: authProvider.user.id,
        );
        await element.delete();
      }
    }
  }

  AuthProvider get authProvider {
    return Provider.of<AuthProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const LoadingSpinnerWithScaffold()
        : _isError
            ? const ErrorScreenWithScaffold()
            : const DashBoardScreen();
  }
}
