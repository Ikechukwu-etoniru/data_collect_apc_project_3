
import 'package:data_collect_v2/providers/auth_provider.dart';
import 'package:data_collect_v2/screens/add_bank_details.dart';
import 'package:data_collect_v2/screens/add_group_screen.dart';
import 'package:data_collect_v2/screens/add_indivdual_screen.dart';
import 'package:data_collect_v2/utils/my_colors.dart';
import 'package:data_collect_v2/utils/my_padding.dart';
import 'package:data_collect_v2/widgets/chip_button.dart';
import 'package:data_collect_v2/widgets/group_amount_container.dart';
import 'package:data_collect_v2/widgets/individual_amount_container.dart';
import 'package:data_collect_v2/widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashBoardScreen extends StatelessWidget {
  static const routeName = 'dashboard_screen.dart';
  const DashBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf9f9f9),
      appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: false,
          title: const CircleAvatar(
            radius: 18,
            backgroundImage: AssetImage(
              'images/dc_logo.png',
            ),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TopContainer(),
          const Divider(),
          Padding(
            padding: MyPadding.screenPadding,
            child: Column(
              children: const [
                IndividualAmountContainer(),
                SizedBox(
                  height: 20,
                ),
                GroupAmountContainer(),
                SizedBox(
                  height: 20,
                ),
                AddAccountContainer()
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AddAccountContainer extends StatelessWidget {
  const AddAccountContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final userBankName = Provider.of<AuthProvider>(context).user.bankName;
    if (userBankName == null) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(AddBankDetails.routeName);
        },
        child: Container(
          height: 90,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                15,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.shade50,
                  blurRadius: 1,
                  spreadRadius: 3,
                )
              ]),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          child: Row(
            children: const [
              Expanded(
                child: Text(
                  'Add your bank information',
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: MyColors.infoColor,
                  ),
                ),
              ),
              Spacer(),
              Icon(
                Icons.error,
                color: Colors.redAccent,
                size: 40,
              )
            ],
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}

class TopContainer extends StatelessWidget {
  const TopContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Dashboard',
            style: TextStyle(
              fontFamily: 'Raleway',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ChipButton(
                text: 'Add Individual',
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(AddIndividualScreen.routeName);
                },
              ),
              const SizedBox(
                width: 15,
              ),
              ChipButton(
                text: 'Add Group',
                onPressed: () {
                  Navigator.of(context).pushNamed(AddGroupScreen.routeName);
                },
              )
            ],
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
