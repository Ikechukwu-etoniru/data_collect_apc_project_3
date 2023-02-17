

import 'package:data_collect_v2/providers/auth_provider.dart';
import 'package:data_collect_v2/screens/dashboard_screen.dart';
import 'package:data_collect_v2/utils/alert.dart';
import 'package:data_collect_v2/utils/my_colors.dart';
import 'package:data_collect_v2/utils/my_input_border.dart';
import 'package:data_collect_v2/utils/my_padding.dart';
import 'package:data_collect_v2/widgets/chip_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddBankDetails extends StatefulWidget {
  static const routeName = '/add_bank_information.dart';
  const AddBankDetails({super.key});

  @override
  State<AddBankDetails> createState() => _AddBankDetailsState();
}

class _AddBankDetailsState extends State<AddBankDetails> {
  final _formKey = GlobalKey<FormState>();

// Details
  final acctNameController = TextEditingController();
  final acctNumberController = TextEditingController();
  final bankNameController = TextEditingController();

  //

  var _isLoading = false;

  Future<bool?> _confirmAcctInfo() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: ((context) {
        return Dialog(
          backgroundColor: Colors.white,
          elevation: 20,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              20,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 30,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Confirm Bank Details',
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Divider(),
                const Text(
                  'Account Name',
                  style: TextStyle(color: MyColors.greyColor),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  acctNameController.text,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const Divider(),
                const Text(
                  'Account Number',
                  style: TextStyle(color: MyColors.greyColor),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  acctNumberController.text,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const Divider(),
                const Text(
                  'Bank Name',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  bankNameController.text,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const Divider(),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ChipButton(
                      text: 'Cancel',
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      buttonColor: Colors.red,
                    ),
                    ChipButton(
                      text: 'Continue',
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  Future _addBank() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    final confirm = await _confirmAcctInfo();
    if (confirm == null || !confirm) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    final result = await authProvider.sendBankInformation(
      name: acctNameController.text,
      number: acctNumberController.text,
      bank: bankNameController.text,
    );

    if (result.status == true) {
      await authProvider.getUserDetails();
      Alert.showInfoSnackbar(message: result.message, context: context);
      _navigateToDashboard();
      authProvider.getUserDetails();
    } else {
      Alert.showInfoSnackbar(message: result.message, context: context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _navigateToDashboard() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      DashBoardScreen.routeName,
      (route) => false,
    );
  }

  AuthProvider get authProvider {
    return Provider.of<AuthProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Add Your Bank Details',
        ),
      ),
      body: Padding(
        padding: MyPadding.screenPadding,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Icon(
                  Icons.home,
                  size: 40,
                  color: Colors.grey[300],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text('Account Name'),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                onFieldSubmitted: ((value) {
                  FocusScope.of(context).unfocus();
                }),
                controller: acctNameController,
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
              const Text('Account Number'),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                onFieldSubmitted: ((value) {
                  FocusScope.of(context).unfocus();
                }),
                controller: acctNumberController,
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
              const Text('Bank Name'),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                onFieldSubmitted: ((value) {
                  FocusScope.of(context).unfocus();
                }),
                controller: bankNameController,
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
                height: 40,
              ),
              Center(
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : ChipButton(
                        text: 'Continue',
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          _addBank();
                        },
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
