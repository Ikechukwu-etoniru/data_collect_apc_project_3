import 'dart:convert';



import 'package:data_collect_v2/models/exception.dart';
import 'package:data_collect_v2/models/response_model.dart';
import 'package:data_collect_v2/models/user.dart';
import 'package:data_collect_v2/utils/api_url.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  User user = User(
    id: 0,
    name: '',
    phone: '',
    acctName: null,
    acctNumber: null,
    address: null,
    bankName: null,
    email: null,
    lgaId: null,
    stateId: null,
    wardId: null,
    zoneId: null,
  );

  int addedIndividual = 0;
  int addedGroup = 0;

  void increaseGroup() {
    addedGroup += 1;
  }

  void increaseIndividual() {
    addedIndividual += 1;
  }

  Future getRegisteredGroups() async {
    try {
      final url = Uri.parse('${ApiUrl.baseUrl}get-user/group-count/${user.id}');
      final header = await ApiUrl.setTokenHeaders();
      final response = await http.get(
        url,
        headers: header,
      );
      final res = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        addedGroup = res['count'];
      }
    } catch (error) {
      throw AppException('An error occured');
    }
  }

  Future getRegisteredIndividuals() async {
    try {
      final url =
          Uri.parse('${ApiUrl.baseUrl}get-user/individual-count/${user.id}');
      final header = await ApiUrl.setTokenHeaders();
      final response = await http.get(
        url,
        headers: header,
      );
      final res = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        addedIndividual = res['count'];
      }
    } catch (error) {
      throw AppException('An error occured');
    }
  }

  Future<ResponseModel> login(
      {required String phone, required String password}) async {
    try {
      final url = Uri.parse('${ApiUrl.baseUrl}login');
      final header = ApiUrl.setHeaders();
      final body = json.encode({'phone': phone, 'password': password});
      final response = await http.post(
        url,
        body: body,
        headers: header,
      );
      final res = json.decode(response.body);
      if (res['message'] == 'Please verify your account') {
        return ResponseModel(message: res['message'], status: false);
      } else if (res['result'] == true) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        setUserProfile(res['user']);
        if (localStorage.containsKey('token')) {
          localStorage.remove('token');
        }
        await localStorage.setString('token', res['access_token']);
        return ResponseModel(message: res['message'], status: res['result']);
      } else {
        return ResponseModel(message: res['message'], status: res['result']);
      }
    } catch (error) {
      print(error);
      return ResponseModel(message: 'An error occured', status: false);
    }
  }

  void setUserProfile(Map<String, dynamic> dbData) {
    user = User(
      id: dbData['id'],
      name: dbData['name'],
      phone: dbData['phone'],
      acctName: null,
      acctNumber: null,
      address: null,
      bankName: null,
      email: null,
      lgaId: null,
      stateId: null,
      wardId: null,
      zoneId: null,
    );
  }

  Future<ResponseModel> signUp({
    required String name,
    required String phone,
    required String password,
    required int zone,
    required int state,
    required int lga,
    required int ward,
    required String address,
    required int role,
  }) async {
    try {
      final url = Uri.parse('${ApiUrl.baseUrl}register');
      final header = ApiUrl.setHeaders();
      final body = json.encode({
        'name': name,
        'phone': phone,
        'password': password,
        'zone': zone,
        'state': state,
        'lga': lga,
        'ward': ward,
        'address': address,
        'role': role
      });
      final response = await http.post(
        url,
        body: body,
        headers: header,
      );
      final res = json.decode(response.body);
      if (res['result'] == true) {
        return ResponseModel(message: res['message'], status: res['result']);
      } else {
        return ResponseModel(message: res['message'], status: res['result']);
      }
    } catch (error) {
      return ResponseModel(message: 'An error occured', status: false);
    }
  }

  Future getUserDetails() async {
    try {
      final url = Uri.parse('${ApiUrl.baseUrl}user/info/${user.id}');
      final header = await ApiUrl.setTokenHeaders();
      final response = await http.get(
        url,
        headers: header,
      );
      final resp = json.decode(response.body);
      final res = resp[0][0];
      if (response.statusCode == 200 || response.statusCode == 201) {
        final userProfile = User(
          id: res['id'],
          name: res['name'],
          phone: res['phone'],
          acctName: res['account_name'],
          acctNumber: res['account_number'],
          address: res['address'],
          bankName: res['bank_name'],
          email: res['email'],
          lgaId: int.parse(res['lga_id'].toString()),
          stateId: int.parse(res['state_id'].toString()),
          wardId: int.parse(res['ward_id'].toString()),
          zoneId: int.parse(res['zone_id'].toString()),
        );
        user = userProfile;
      } else {
        throw AppException('Error occured');
      }
    } catch (error) {
      throw AppException('Error occured');
    }
  }

  Future<ResponseModel> sendBankInformation({
    required String name,
    required String number,
    required String bank,
  }) async {
    try {
      final url = Uri.parse('${ApiUrl.baseUrl}add/account');
      final header = await ApiUrl.setTokenHeaders();
      final body = json.encode({
        'user_id': user.id,
        'name': name,
        'number': number,
        'bank': bank,
      });
      final response = await http.post(
        url,
        body: body,
        headers: header,
      );

      final res = json.decode(response.body);
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          res['result'] == true) {
        return ResponseModel(
          message: res['message'],
          status: res['result'],
        );
      } else {
        return ResponseModel(
            message: 'Error occured adding this bank', status: false);
      }
    } catch (error) {
      return ResponseModel(
          message: 'Error occured adding this bank', status: false);
    }
  }
}
