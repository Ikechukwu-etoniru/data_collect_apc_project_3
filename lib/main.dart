import 'package:data_collect_v2/models/group.dart';
import 'package:data_collect_v2/models/lg.dart';
import 'package:data_collect_v2/models/state.dart';
import 'package:data_collect_v2/models/ward.dart';
import 'package:data_collect_v2/providers/auth_provider.dart';
import 'package:data_collect_v2/providers/location_provider.dart';
import 'package:data_collect_v2/providers/voters_info_provider.dart';
import 'package:data_collect_v2/screens/add_bank_details.dart';
import 'package:data_collect_v2/screens/add_group_screen.dart';
import 'package:data_collect_v2/screens/add_indivdual_screen.dart';
import 'package:data_collect_v2/screens/auth_screen.dart';
import 'package:data_collect_v2/screens/awaiting_confirmation_screen.dart';
import 'package:data_collect_v2/screens/dashboard_screen.dart';
import 'package:data_collect_v2/screens/initialization_screen.dart';
import 'package:data_collect_v2/screens/login_screen.dart';
import 'package:data_collect_v2/screens/offline_dashboard.dart';
import 'package:data_collect_v2/screens/profile_screen.dart';
import 'package:data_collect_v2/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'models/individual.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(StateModelAdapter());
  Hive.registerAdapter(LgModelAdapter());
  Hive.registerAdapter(WardModelAdapter());
  Hive.registerAdapter(GroupAdapter());
  Hive.registerAdapter(IndividualAdapter());
  await Hive.openBox<StateModel>('states');
  await Hive.openBox<LgModel>('lgas');
  await Hive.openBox<WardModel>('wards');
  await Hive.openBox<Group>('groups');
  await Hive.openBox<Individual>('individuals');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => VotersInfoProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocationProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Data Collect',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Quicksand',
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            titleTextStyle: TextStyle(
              fontFamily: 'Raleway',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: 1,
            ),
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            color: Colors.transparent,
            elevation: 0,
          ),
        ),
        home: const CheckAuthScreen(),
        routes: {
          LoginScreen.routeName: (ctx) => const LoginScreen(),
          DashBoardScreen.routeName: (ctx) => const DashBoardScreen(),
          AwaitingConfirmationScreen.routeName: (ctx) =>
              const AwaitingConfirmationScreen(),
          AddIndividualScreen.routeName: (ctx) => const AddIndividualScreen(),
          AddGroupScreen.routeName: (ctx) => const AddGroupScreen(),
          ProfileScreen.routeName: (ctx) => const ProfileScreen(),
          SignupScreen.routeName: (ctx) => const SignupScreen(),
          InitializationScreen.routeName: (ctx) => const InitializationScreen(),
          AddBankDetails.routeName: (ctx) => const AddBankDetails(),
          CheckAuthScreen.routeName: (ctx) => const CheckAuthScreen(),
          OfflineDashboard.routeName: (ctx) => const OfflineDashboard()
        },
      ),
    );
  }
}
