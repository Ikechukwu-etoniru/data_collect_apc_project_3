
import 'package:data_collect_v2/models/geo_political_zone.dart';
import 'package:data_collect_v2/models/positions.dart';
import 'package:data_collect_v2/models/state.dart';
import 'package:data_collect_v2/models/ward.dart';
import 'package:data_collect_v2/providers/auth_provider.dart';
import 'package:data_collect_v2/providers/location_provider.dart';
import 'package:data_collect_v2/screens/awaiting_confirmation_screen.dart';
import 'package:data_collect_v2/screens/login_screen.dart';
import 'package:data_collect_v2/utils/alert.dart';
import 'package:data_collect_v2/utils/my_input_border.dart';
import 'package:data_collect_v2/utils/my_padding.dart';
import 'package:data_collect_v2/utils/text_util.dart';
import 'package:data_collect_v2/widgets/my_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/lg.dart';
import '../utils/my_colors.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = '/sign_up_screen.dart';
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var _obscurePassword = true;
  var _obscureConfirmPassword = true;
  final _formKey = GlobalKey<FormState>();

  // Remember to prevent signing up without internet

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

  int? _selectedPosition;
  int? _selectedGeoPoliticalZone;
  int? _selectedState;
  int? _selectedLg;
  int? _selectedWard;

//  Selected String values

  final nameController = TextEditingController();
  final numberController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

//  boolean to control screen loading

  var _isLoading = false;

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

  Future _createAccount() async {
    FocusScope.of(context).unfocus();
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    final signUpStatus =
        await Provider.of<AuthProvider>(context, listen: false).signUp(
      name: nameController.text,
      phone: numberController.text,
      password: passwordController.text,
      zone: _selectedGeoPoliticalZone!,
      state: _selectedState!,
      lga: _selectedLg!,
      ward: _selectedWard!,
      address: addressController.text,
      role: _selectedPosition!,
    );
    if (signUpStatus.status == true) {
      _showSnackbarAndNavigateUserToAwaitScreen(signUpStatus.message);
    } else {
      Alert.showInfoSnackbar(
        message: signUpStatus.message,
        context: context,
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _showSnackbarAndNavigateUserToAwaitScreen(String message) {
    Alert.showInfoSnackbar(
      message: message,
      context: context,
    );
    Navigator.of(context).pushNamed(AwaitingConfirmationScreen.routeName);
  }

  void _saveHasSeenSignUp() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    if (localStorage.containsKey('old user')) {
      return;
    } else {
      localStorage.setBool('old user', true);
    }
  }

  @override
  void initState() {
    super.initState();
    _saveHasSeenSignUp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 10,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: MyPadding.screenPadding,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Name'),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: nameController,
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
                    hintText: 'Full Name',
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
                const Text('Phone Number'),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: numberController,
                  onFieldSubmitted: ((value) {
                    FocusScope.of(context).unfocus();
                  }),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field can\'t be empty';
                    } else if (double.tryParse(value) == null) {
                      return 'Enter a valid number';
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
                    hintText: 'WhatsApp Number',
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
                const Text('Position'),
                const SizedBox(
                  height: 5,
                ),
                MyDropDown(
                  items: TextUtil.positions
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    final val = value as PositionModel;
                    _selectedPosition = val.id;
                  },
                  hint: const Text('Position'),
                  validator: (value) {
                    if (value == null) {
                      return 'Select your position';
                    } else {
                      return null;
                    }
                  },
                  maxHeight: 200,
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
                      return 'Select your Geo-Political zone';
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
                      return 'Select your Local Government';
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
                      return 'Select your Ward';
                    } else {
                      return null;
                    }
                  },
                  maxHeight: 200,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text('Address'),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: addressController,
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
                    hintText: 'Address',
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
                  controller: passwordController,
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
                  obscureText: _obscurePassword,
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
                const Text('Confirm Password'),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: confirmPasswordController,
                  onFieldSubmitted: ((value) {
                    FocusScope.of(context).unfocus();
                  }),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field can\'t be empty';
                    } else if (passwordController.text != value) {
                      return 'Passwords do not match';
                    } else {
                      return null;
                    }
                  },
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 13,
                      horizontal: 10,
                    ),
                    suffixIcon: IconButton(
                      onPressed: !_obscureConfirmPassword
                          ? null
                          : () async {
                              setState(() {
                                _obscureConfirmPassword = false;
                              });
                              await Future.delayed(
                                const Duration(seconds: 3),
                              );
                              setState(() {
                                _obscureConfirmPassword = true;
                              });
                            },
                      icon: Icon(
                        Icons.remove_red_eye,
                        color: _obscureConfirmPassword
                            ? MyColors.primaryColor
                            : Colors.grey,
                      ),
                    ),
                    hintText: 'Confirm Password',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                    border: MyInputBorder.borderInputBorder,
                    focusedBorder: MyInputBorder.focusedInputBorder,
                    errorBorder: MyInputBorder.errorInputBorder,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(LoginScreen.routeName);
                      },
                      child: const Text(
                        'Already Registered?',
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
                          _createAccount();
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
                              'REGISTER',
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
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
