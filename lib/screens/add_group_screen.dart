
import 'package:data_collect_v2/helper/boxes.dart';
import 'package:data_collect_v2/models/geo_political_zone.dart';
import 'package:data_collect_v2/models/group.dart';
import 'package:data_collect_v2/models/lg.dart';
import 'package:data_collect_v2/models/state.dart';
import 'package:data_collect_v2/models/ward.dart';
import 'package:data_collect_v2/providers/auth_provider.dart';
import 'package:data_collect_v2/providers/location_provider.dart';
import 'package:data_collect_v2/providers/voters_info_provider.dart';
import 'package:data_collect_v2/screens/dashboard_screen.dart';
import 'package:data_collect_v2/screens/offline_dashboard.dart';
import 'package:data_collect_v2/utils/alert.dart';
import 'package:data_collect_v2/utils/internet_connection.dart';
import 'package:data_collect_v2/utils/my_input_border.dart';
import 'package:data_collect_v2/utils/my_padding.dart';
import 'package:data_collect_v2/utils/text_util.dart';
import 'package:data_collect_v2/widgets/chip_button.dart';
import 'package:data_collect_v2/widgets/my_dropdown.dart';
import 'package:data_collect_v2/widgets/select_demand.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddGroupScreen extends StatefulWidget {
  static const routeName = '/add_group_screen.dart';
  const AddGroupScreen({super.key});

  @override
  State<AddGroupScreen> createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends State<AddGroupScreen> {
  final _formKey = GlobalKey<FormState>();

  var _isLoading = false;

// Dropdown List
  List<StateModel>? stateList;
  List<LgModel>? localGovernmentList;
  List<WardModel>? wardList;

// Dropdown Boolean to show loading
  var _isStateLoading = false;
  var _isLgLoading = false;
  var _isWardLoading = false;

// Error loading value for dropdown boolean
  var _isStateLoadingError = false;
  var _isLgLoadingError = false;
  var _isWardLoadingError = false;

// selected int values

  int? _selectedGeoPoliticalZone;
  int? _selectedState;
  int? _selectedLg;
  int? _selectedWard;
//
  final groupNameController = TextEditingController();
  final chairmanNameController = TextEditingController();
  final secretaryNameController = TextEditingController();
  final chairmanNumberController = TextEditingController();

  final demandList = [
    "Community road rehabilitation",
    "Micro credit",
    "Community Educational project",
    "Community water project",
    "Community flood control project",
    "Professional patronage",
    "Equipment/tools empowerment",
    "Community security improvement",
    "Agricultural loan scheme",
  ];
  List<String>? selectedDemandList;

  void getList(List<String> list) {
    selectedDemandList = list;
  }

  Future _getState(int zoneId) async {
    try {
      setState(() {
        _isStateLoading = true;
      });
      var stateListFromProvider =
          Provider.of<LocationProvider>(context, listen: false)
              .getStateByZoneId(zoneId.toString());
      setState(() {
        stateList = stateListFromProvider;
      });
    } catch (error) {
      setState(() {
        _isStateLoadingError = true;
      });
    } finally {
      setState(() {
        _isStateLoading = false;
      });
    }
  }

  Future _getLg(int stateId) async {
    try {
      setState(() {
        _isLgLoading = true;
      });
      var lgListFromProvider =
          await Provider.of<LocationProvider>(context, listen: false)
              .getLgaByStateId(stateId.toString());
      setState(() {
        localGovernmentList = lgListFromProvider;
      });
    } catch (error) {
      setState(() {
        _isLgLoadingError = true;
      });
    } finally {
      setState(() {
        _isLgLoading = false;
      });
    }
  }

  Future _getWard(int lgaId) async {
    try {
      setState(() {
        _isWardLoading = true;
      });
      var wardListFromProvider =
          await Provider.of<LocationProvider>(context, listen: false)
              .getwardByLgaId(lgaId.toString());
      setState(() {
        wardList = wardListFromProvider;
      });
    } catch (error) {
      setState(() {
        _isWardLoadingError = true;
      });
    } finally {
      setState(() {
        _isWardLoading = false;
      });
    }
  }

  Future _addGroup() async {
    final isValid = _formKey.currentState!.validate();
    // Check if there is a demand
    if (selectedDemandList == null || selectedDemandList!.isEmpty) {
      Alert.showInfoDialog(
        context,
        'You have not selected your demand',
      );
    }
    // Validate form
    if (!isValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });
    var internetConnection = await InternetConnection.checkInternetStatus();

    if (!internetConnection) {
      _offlineAddGroup();
      return;
    }

    final userId = Provider.of<AuthProvider>(context, listen: false).user.id;
    final result = await voteProvider.addGroup(
      context: context,
      name: groupNameController.text,
      phone: chairmanNumberController.text,
      cname: chairmanNameController.text,
      secretary: secretaryNameController.text,
      zone: _selectedGeoPoliticalZone!,
      state: _selectedState!,
      lga: _selectedLg!,
      ward: _selectedWard!,
      demand: selectedDemandList!,
      userId: userId,
    );

    if (result.status == true) {
      authProvider.increaseGroup();
      Alert.showInfoSnackbar(
        message: result.message,
        context: context,
      );
      _navigateToDashboard();
    } else {
      Alert.showInfoSnackbar(
        message: result.message,
        context: context,
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future _offlineAddGroup() async {
    final newGroup = Group(
      name: groupNameController.text,
      phone: chairmanNumberController.text,
      cname: chairmanNameController.text,
      secretary: secretaryNameController.text,
      zone: _selectedGeoPoliticalZone!,
      state: _selectedState!,
      lga: _selectedLg!,
      ward: _selectedWard!,
      demand: selectedDemandList!,
    );
    var box = Boxes.getGroups();
    await box.add(newGroup);

    Alert.showInfoSnackbar(
      message:
          'Group has been stored offline. When you have internet connection, it will be dynamically uploaded',
      context: context,
    );
    _navigateToOfflineDashboard();
  }

  VotersInfoProvider get voteProvider {
    return Provider.of<VotersInfoProvider>(context, listen: false);
  }

  AuthProvider get authProvider {
    return Provider.of<AuthProvider>(context, listen: false);
  }

  void _navigateToDashboard() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      DashBoardScreen.routeName,
      (route) => false,
    );
  }

  void _navigateToOfflineDashboard() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      OfflineDashboard.routeName,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Group',
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: MyPadding.screenPadding,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Group\'s Name'),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: groupNameController,
                  onFieldSubmitted: ((value) {
                    FocusScope.of(context).unfocus();
                  }),
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
                    hintText: '',
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
                const Text('Chairman\'s Name'),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  onFieldSubmitted: ((value) {
                    FocusScope.of(context).unfocus();
                  }),
                  controller: chairmanNameController,
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
                    hintText: '',
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
                const Text('Chairman\'s Number'),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  onFieldSubmitted: ((value) {
                    FocusScope.of(context).unfocus();
                  }),
                  controller: chairmanNumberController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field can\'t be empty';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 13,
                      horizontal: 10,
                    ),
                    hintText: '',
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
                const Text('Secretary\'s Name'),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  onFieldSubmitted: ((value) {
                    FocusScope.of(context).unfocus();
                  }),
                  controller: secretaryNameController,
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
                    hintText: '',
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
                const Text('Geo-Political Zone'),
                const SizedBox(
                  height: 5,
                ),
                MyDropDown(
                  items: TextUtil.geopoliticalZone
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    final val = value as GeoPoliticalZone;
                    _selectedGeoPoliticalZone = val.zoneId;
                    setState(() {
                      stateList = null;
                      localGovernmentList = null;
                      wardList = null;
                    });
                    _getState(val.zoneId);
                  },
                  hint: const Text('Select Geopolitical Zone'),
                  validator: (value) {
                    if (value == null) {
                      return 'Select a Geo-Political zone';
                    } else {
                      return null;
                    }
                  },
                  maxHeight: 200,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text('State'),
                const SizedBox(
                  height: 5,
                ),
                MyDropDown(
                  items: stateList == null
                      ? []
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList()
                      : stateList!
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.name),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    final val = value as StateModel;
                    _selectedState = val.stateId;
                    setState(() {
                      localGovernmentList = null;
                      wardList = null;
                    });
                    _getLg(val.stateId);
                  },
                  hint: Text(
                    stateList == null
                        ? ''
                        : _isStateLoading
                            ? 'Loading'
                            : _isStateLoadingError
                                ? 'Error Loading data'
                                : 'Select State',
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Select a State';
                    } else {
                      return null;
                    }
                  },
                  maxHeight: 200,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text('Local Government'),
                const SizedBox(
                  height: 5,
                ),
                MyDropDown(
                  items: localGovernmentList == null
                      ? []
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList()
                      : localGovernmentList!
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.name),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    final val = value as LgModel;
                    _selectedLg = val.lgaId;
                    setState(() {
                      wardList = null;
                    });
                    _getWard(val.lgaId);
                  },
                  hint: Text(
                    localGovernmentList == null
                        ? ''
                        : _isLgLoading
                            ? 'Loading'
                            : _isLgLoadingError
                                ? 'Error Loading data'
                                : 'Select Local Government',
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Select a Local Government';
                    } else {
                      return null;
                    }
                  },
                  maxHeight: 200,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text('Ward'),
                const SizedBox(
                  height: 5,
                ),
                MyDropDown(
                  items: wardList == null
                      ? []
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList()
                      : wardList!
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.name),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    final val = value as WardModel;
                    _selectedWard = val.wardId;
                  },
                  hint: Text(
                    wardList == null
                        ? ''
                        : _isWardLoading
                            ? 'Loading'
                            : _isWardLoadingError
                                ? 'Error Loading data'
                                : 'Select Ward',
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Select a Ward';
                    } else {
                      return null;
                    }
                  },
                  maxHeight: 200,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text('Demand  (multiple select - max 3)'),
                const SizedBox(
                  height: 5,
                ),
                SelectDemandCotainer(
                  demandList: demandList,
                  getList: getList,
                  maxSelect: 3,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Spacer(),
                    if (_isLoading) const CircularProgressIndicator(),
                    if (!_isLoading)
                      ChipButton(
                        text: 'Save',
                        onPressed: () {
                          _addGroup();
                        },
                      ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
