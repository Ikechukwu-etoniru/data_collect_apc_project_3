import 'package:data_collect_v2/helper/boxes.dart';
import 'package:data_collect_v2/models/geo_political_zone.dart';
import 'package:data_collect_v2/models/individual.dart';
import 'package:data_collect_v2/models/lg.dart';
import 'package:data_collect_v2/models/state.dart';
import 'package:data_collect_v2/models/ward.dart';
import 'package:data_collect_v2/providers/auth_provider.dart';
import 'package:data_collect_v2/providers/location_provider.dart';
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

import '../providers/voters_info_provider.dart';

class AddIndividualScreen extends StatefulWidget {
  static const routeName = 'add_individual_screen.dart';
  const AddIndividualScreen({super.key});

  @override
  State<AddIndividualScreen> createState() => _AddIndividualScreenState();
}

class _AddIndividualScreenState extends State<AddIndividualScreen> {
  @override
  void initState() {
    super.initState();
    _getAllStates();
  }

  final _formKey = GlobalKey<FormState>();

  var _isLoading = false;

// Dropdown List
  List<StateModel>? stateList;
  List<LgModel>? localGovernmentList;
  List<WardModel>? wardList;
  List<StateModel>? votingStateList;
  List<LgModel>? votingLgaList;
  List<WardModel>? votingWardList;

// Dropdown Boolean to show loading
  var _isStateLoading = false;
  var _isLgLoading = false;
  var _isWardLoading = false;
  var _isVotingStateLoading = false;
  var _isVotingLgaLoading = false;
  var _isVotingWardLoading = false;

// Error loading value for dropdown boolean
  var _isStateLoadingError = false;
  var _isLgLoadingError = false;
  var _isWardLoadingError = false;
  var _isVotingStateLoadingError = false;
  var _isVotingLgaLoadingError = false;
  var _isVotingWardLoadingError = false;

// selected int values

  int? _selectedGeoPoliticalZone;
  int? _selectedState;
  int? _selectedLg;
  int? _selectedWard;
  int? _selectedVotingState;
  int? _selectedVotinglga;
  int? _selectedVotingWard;
  String? _selectedWorkCategory;
  // Demand
  List<String>? selectedDemandList;

// String values
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _dataNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _pollingUnitController = TextEditingController();
  final _vinNumberController = TextEditingController();

  final demandList = [
    "Micro credit",
    "Skill Acquisition training",
    "Equipment/tools empowerment",
    "Housing mortgage Access",
    "Car Loan",
    "Scholarship/Student Loan",
  ];

  final occupationList = [
    "Farmer",
    "Civil Servant",
    "Trader",
    "Student",
    "Artisan",
    "Others",
  ];

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

  Future _getLg({required bool isVoting, required int stateId}) async {
    try {
      setState(() {
        if (!isVoting) {
          _isLgLoading = true;
        } else {
          _isVotingLgaLoading = true;
        }
      });
      var lgListFromProvider =
          await Provider.of<LocationProvider>(context, listen: false)
              .getLgaByStateId(stateId.toString());
      setState(() {
        if (!isVoting) {
          localGovernmentList = lgListFromProvider;
        } else {
          votingLgaList = lgListFromProvider;
        }
      });
    } catch (error) {
      setState(() {
        if (!isVoting) {
          _isLgLoadingError = true;
        } else {
          _isVotingLgaLoadingError = true;
        }
      });
    } finally {
      setState(() {
        if (!isVoting) {
          _isLgLoading = false;
        } else {
          _isVotingLgaLoading = false;
        }
      });
    }
  }

  Future _getWard({required bool isVoting, required int lgaId}) async {
    try {
      setState(() {
        if (!isVoting) {
          _isWardLoading = true;
        } else {
          _isVotingWardLoading = true;
        }
      });
      var wardListFromProvider =
          await Provider.of<LocationProvider>(context, listen: false)
              .getwardByLgaId(lgaId.toString());
      setState(() {
        if (!isVoting) {
          wardList = wardListFromProvider;
        } else {
          votingWardList = wardListFromProvider;
        }
      });
    } catch (error) {
      setState(() {
        if (!isVoting) {
          _isWardLoadingError = true;
        } else {
          _isVotingLgaLoadingError = true;
        }
      });
    } finally {
      setState(() {
        if (!isVoting) {
          _isWardLoading = false;
        } else {
          _isVotingWardLoading = false;
        }
      });
    }
  }

  Future _getAllStates() async {
    try {
      setState(() {
        _isVotingStateLoading = true;
      });
      final stateListFromDb =
          Provider.of<LocationProvider>(context, listen: false).states;

      setState(() {
        votingStateList = stateListFromDb;
      });
    } catch (error) {
      setState(() {
        _isVotingStateLoadingError = true;
      });
    } finally {
      setState(() {
        _isVotingStateLoading = false;
      });
    }
  }

  Future _saveIndividual() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    if (selectedDemandList == null || selectedDemandList!.isEmpty) {
      Alert.showInfoSnackbar(
        message: 'Select your demands',
        context: context,
      );
    }

    setState(() {
      _isLoading = true;
    });

    var internetConnection = await InternetConnection.checkInternetStatus();

    if (!internetConnection) {
      _offlineAddIndividual();
      return;
    }

    final result = await voteProvider.addIndividual(
        name: _nameController.text,
        phone: _dataNumberController.text,
        cphone: _numberController.text,
        zone: _selectedGeoPoliticalZone!,
        state: _selectedState!,
        lga: _selectedLg!,
        ward: _selectedWard!,
        vstate: _selectedVotingState!,
        vlga: _selectedVotinglga!,
        vward: _selectedVotingWard!,
        category: _selectedWorkCategory!,
        pollingUnit: _pollingUnitController.text,
        demand: selectedDemandList!,
        userId: authProvider.user.id,
        vinNumber: _vinNumberController.text);
    if (result.status == true) {
      authProvider.increaseIndividual();
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

  Future _offlineAddIndividual() async {
    final newIndividual = Individual(
        name: _nameController.text,
        phone: _dataNumberController.text,
        cphone: _numberController.text,
        zone: _selectedGeoPoliticalZone!,
        state: _selectedState!,
        lga: _selectedLg!,
        ward: _selectedWard!,
        vstate: _selectedVotingState!,
        vlga: _selectedVotinglga!,
        vward: _selectedVotingWard!,
        category: _selectedWorkCategory!,
        pollingUnit: _pollingUnitController.text,
        demand: selectedDemandList!,
        vinNumber: _vinNumberController.text);
    var box = Boxes.getIndividual();
    await box.add(newIndividual);

    Alert.showInfoSnackbar(
      message:
          'Individual has been stored offline. When you have internet connection, it will be dynamically uploaded',
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
          'Add Individual',
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
                const Text('Full Name'),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  onFieldSubmitted: ((value) {
                    FocusScope.of(context).unfocus();
                  }),
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field cant\' be empty';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 13,
                      horizontal: 10,
                    ),
                    hintText: 'Jane Doe',
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
                const Text('Contact Number'),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  onFieldSubmitted: ((value) {
                    FocusScope.of(context).unfocus();
                  }),
                  controller: _numberController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field cant\' be empty';
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
                    hintText: '08101010101',
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
                const Text('Data Number'),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  onFieldSubmitted: ((value) {
                    FocusScope.of(context).unfocus();
                  }),
                  controller: _dataNumberController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field cant\' be empty';
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
                    hintText: '1234-567-890',
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
                const Text('VIN Number'),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  onFieldSubmitted: ((value) {
                    FocusScope.of(context).unfocus();
                  }),
                  textCapitalization: TextCapitalization.characters,
                  controller: _vinNumberController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field cant\' be empty';
                    } else if (value.length != 19) {
                      return '';
                    } else {
                      return null;
                    }
                  },
                  maxLength: 19,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 13,
                      horizontal: 10,
                    ),
                    hintText: 'OOOO OOOO 0000 0000 000',
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
                const Text('Address'),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  onFieldSubmitted: ((value) {
                    FocusScope.of(context).unfocus();
                  }),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field cant\' be empty';
                    } else {
                      return null;
                    }
                  },
                  controller: _addressController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 13,
                      horizontal: 10,
                    ),
                    hintText: '#10 Street',
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
                    _getAllStates();
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
                      ? ['']
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
                    _getLg(isVoting: false, stateId: val.stateId);
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
                      return 'Select your State';
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
                      ? ['']
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
                    _getWard(lgaId: val.lgaId, isVoting: false);
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
                      ? ['']
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
                const Text('Voting State'),
                const SizedBox(
                  height: 5,
                ),
                MyDropDown(
                  items: votingStateList == null
                      ? ['']
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList()
                      : votingStateList!
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.name),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    final val = value as StateModel;
                    _selectedVotingState = val.stateId;
                    setState(() {
                      votingLgaList = null;
                      votingWardList = null;
                    });
                    _getLg(stateId: val.stateId, isVoting: true);
                  },
                  hint: Text(
                    votingStateList == null
                        ? ''
                        : _isVotingStateLoading
                            ? 'Loading'
                            : _isVotingStateLoadingError
                                ? 'Error Loading data'
                                : 'Select State',
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Select a voting state';
                    } else {
                      return null;
                    }
                  },
                  maxHeight: 200,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text('Voting LGA'),
                const SizedBox(
                  height: 5,
                ),
                MyDropDown(
                  items: votingLgaList == null
                      ? ['']
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList()
                      : votingLgaList!
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.name),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    final val = value as LgModel;
                    _selectedVotinglga = val.lgaId;
                    setState(() {
                      votingWardList = null;
                    });
                    _getWard(lgaId: val.lgaId, isVoting: true);
                  },
                  hint: Text(
                    votingLgaList == null
                        ? ''
                        : _isVotingLgaLoading
                            ? 'Loading'
                            : _isVotingLgaLoadingError
                                ? 'Error Loading data'
                                : 'Select Local Government',
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Select a voting Local Government';
                    } else {
                      return null;
                    }
                  },
                  maxHeight: 200,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text('Voting Ward'),
                const SizedBox(
                  height: 5,
                ),
                MyDropDown(
                  items: votingWardList == null
                      ? ['']
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList()
                      : votingWardList!
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.name),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    final val = value as WardModel;
                    _selectedVotingWard = val.wardId;
                  },
                  hint: Text(
                    votingWardList == null
                        ? ''
                        : _isVotingWardLoading
                            ? 'Loading'
                            : _isVotingWardLoadingError
                                ? 'Error Loading data'
                                : 'Select Voting Ward',
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Select a voting ward';
                    } else {
                      return null;
                    }
                  },
                  maxHeight: 200,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text('Polling Unit'),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  onFieldSubmitted: ((value) {
                    FocusScope.of(context).unfocus();
                  }),
                  controller: _pollingUnitController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field cant\' be empty';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 13,
                      horizontal: 10,
                    ),
                    hintText: 'House 11',
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
                const Text('Work Category'),
                const SizedBox(
                  height: 5,
                ),
                MyDropDown(
                  items: occupationList
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    _selectedWorkCategory = value.toString();
                  },
                  hint: const Text('Choose a work category'),
                  validator: (value) {
                    if (value == null) {
                      return 'Select a work category';
                    } else {
                      return null;
                    }
                  },
                  maxHeight: 200,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text('Demand  (multiple select - max 2)'),
                const SizedBox(
                  height: 5,
                ),
                SelectDemandCotainer(
                  demandList: demandList,
                  getList: getList,
                  maxSelect: 2,
                ),
                const SizedBox(
                  height: 20,
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
                          _saveIndividual();
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

// 90F5 AFA1 5A29 5364 925
// 90F5 AE64 5029 6749 359
// INC2 2000 0002 7506 253
