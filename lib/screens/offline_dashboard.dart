
import 'package:data_collect_v2/helper/boxes.dart';
import 'package:data_collect_v2/models/group.dart';
import 'package:data_collect_v2/models/individual.dart';
import 'package:data_collect_v2/screens/add_group_screen.dart';
import 'package:data_collect_v2/screens/add_indivdual_screen.dart';
import 'package:data_collect_v2/screens/login_screen.dart';
import 'package:data_collect_v2/utils/my_colors.dart';
import 'package:data_collect_v2/widgets/chip_button.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class OfflineDashboard extends StatefulWidget {
  static const routeName = '/offline_dashboard.dart';
  const OfflineDashboard({super.key});

  @override
  State<OfflineDashboard> createState() => _OfflineDashboardState();
}

class _OfflineDashboardState extends State<OfflineDashboard> {
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
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  LoginScreen.routeName, (route) => false);
            },
            icon: const Icon(
              Icons.logout_rounded,
            ),
            label: const Text('Logout'),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            OfflineTopContainer(),
          ],
        ),
      ),
    );
  }
}

class OfflineTopContainer extends StatelessWidget {
  const OfflineTopContainer({super.key});

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'You are offline',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Offline Dashboard',
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
          ValueListenableBuilder<Box<Group>>(
            valueListenable: Boxes.getGroups().listenable(),
            builder: ((context, value, child) {
              final content = value.values.toList().cast<Group>();
              return GroupListContainer(offlineGroupList: content);
            }),
          ),
          ValueListenableBuilder<Box<Individual>>(
            valueListenable: Boxes.getIndividual().listenable(),
            builder: ((context, value, child) {
              final content = value.values.toList().cast<Individual>();
              return IndividualListContainer(offlineIndividualList: content);
            }),
          ),
        ],
      ),
    );
  }
}

class GroupListContainer extends StatelessWidget {
  final List<Group> offlineGroupList;
  const GroupListContainer({required this.offlineGroupList, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: offlineGroupList.isEmpty ? 100 : 300,
      decoration: BoxDecoration(
        border: Border.all(
          color: MyColors.buttonColor,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        children: [
          const Text(
            'Groups you have added offline',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: offlineGroupList.isEmpty
                ? const Center(
                    child: Text(
                      '0',
                      style: TextStyle(fontSize: 17),
                    ),
                  )
                : ListView.builder(
                    itemCount: offlineGroupList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Group Name',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              offlineGroupList[index].name,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const Divider(),
                            const Text(
                              'Group Chairman Name',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              offlineGroupList[index].name,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class IndividualListContainer extends StatelessWidget {
  final List<Individual> offlineIndividualList;
  const IndividualListContainer(
      {required this.offlineIndividualList, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: offlineIndividualList.isEmpty ? 100 : 300,
      margin: const EdgeInsets.symmetric(
        vertical: 15,
      ),
      decoration: BoxDecoration(
          border: Border.all(
            color: MyColors.buttonColor,
          ),
          borderRadius: BorderRadius.circular(15)),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        children: [
          const Text(
            'Individuals you have added offline',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: offlineIndividualList.isEmpty
                ? const Center(
                    child: Text(
                      '0',
                      style: TextStyle(fontSize: 17),
                    ),
                  )
                : ListView.builder(
                    itemCount: offlineIndividualList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Individual Name',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              offlineIndividualList[index].name,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const Divider(),
                            const Text(
                              'Individual Number',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              offlineIndividualList[index].phone,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
