import 'package:data_collect_v2/models/user.dart';
import 'package:data_collect_v2/providers/auth_provider.dart';
import 'package:data_collect_v2/screens/dashboard_screen.dart';
import 'package:data_collect_v2/screens/login_screen.dart';
import 'package:data_collect_v2/screens/profile_screen.dart';
import 'package:data_collect_v2/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  Future<bool?> _confirmLogoutDialog(BuildContext context) {
    return showDialog<bool>(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            title: const Text(
              'Confirm Logout',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                fontFamily: 'Raleway',
              ),
            ),
            elevation: 30,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Proceed'),
              )
            ],
          );
        });
  }

  Future _completeLogOut() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    if (localStorage.containsKey('token')) {
      localStorage.remove('token');
    }
    Scaffold.of(context).closeEndDrawer();
    Navigator.of(context).pushNamedAndRemoveUntil(
      LoginScreen.routeName,
      (route) => false,
    );
  }

  User get user {
    return Provider.of<AuthProvider>(context, listen: false).user;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Text('Hello  ${user.name.split(' ')[0]}'),
            const Divider(),
            DrawerTextButton(
              text: 'Dashboard',
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  DashBoardScreen.routeName,
                  (route) => false,
                );
              },
              icon: Icons.space_dashboard_outlined,
            ),
            const Divider(),
            DrawerTextButton(
              text: 'Profile',
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  ProfileScreen.routeName,
                  (route) => false,
                );
              },
              icon: Icons.person,
            ),
            const Divider(),
            DrawerTextButton(
              text: 'Log Out',
              onPressed: () async {
                final confirm = await _confirmLogoutDialog(context);
                if (confirm != null && confirm) {
                  _completeLogOut();
                }
              },
              icon: Icons.logout,
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerTextButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final IconData icon;
  const DrawerTextButton(
      {required this.text,
      required this.onPressed,
      required this.icon,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        text,
        style: const TextStyle(
          color: MyColors.buttonColor,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onPressed,
      trailing: Icon(icon),
    );
  }
}
