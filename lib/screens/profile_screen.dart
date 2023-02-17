
import 'package:data_collect_v2/models/user.dart';
import 'package:data_collect_v2/providers/auth_provider.dart';
import 'package:data_collect_v2/utils/my_padding.dart';
import 'package:data_collect_v2/widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile_screen.dart';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User get user {
    return Provider.of<AuthProvider>(context, listen: false).user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Your Profile',
          ),
          actions: [
            Builder(builder: (context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                icon: const Icon(
                  Icons.dashboard,
                ),
              );
            }),
          ]),
      endDrawer: const MyDrawer(),
      body: Padding(
        padding: MyPadding.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileBlock(
              title: 'Name',
              body: user.name,
            ),
            ProfileBlock(
              title: 'Phone Number',
              body: user.phone,
            ),
            ProfileBlock(
              title: 'Address',
              body: user.address ?? 'Not Set',
            ),
            ProfileBlock(
              title: 'Bank Account Name',
              body: user.acctName ?? 'Not Set',
            ),
            ProfileBlock(
              title: 'Bank Account Number',
              body: user.acctNumber ?? 'Not Set',
            ),
            ProfileBlock(
              title: 'Bank Name',
              body: user.bankName ?? 'Not Set',
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileBlock extends StatelessWidget {
  final String title;
  final String body;
  const ProfileBlock({
    required this.title,
    required this.body,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          body,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
