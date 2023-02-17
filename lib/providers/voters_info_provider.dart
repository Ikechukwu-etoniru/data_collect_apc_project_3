import 'dart:convert';


import 'package:data_collect_v2/models/response_model.dart';
import 'package:data_collect_v2/utils/api_url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VotersInfoProvider with ChangeNotifier {
  Future<ResponseModel> addIndividual({
    required String name,
    required String phone,
    required String cphone,
    required int zone,
    required int state,
    required int lga,
    required int ward,
    required int vstate,
    required int vlga,
    required int vward,
    required String category,
    required String pollingUnit,
    required List<String> demand,
    required int userId,
    required String vinNumber,
  }) async {
    try {
      final url = Uri.parse('${ApiUrl.baseUrl}add/member');
      final header = await ApiUrl.setTokenHeaders();
      final body = json.encode({
        'name': name,
        'phone': phone,
        'cphone': cphone,
        'demand': demand,
        'zone': zone,
        'state': state,
        'lga': lga,
        'ward': ward,
        'vstate': vstate,
        'vlga': vlga,
        'vward': vward,
        'category': category,
        'polling_unit': pollingUnit,
        'user_id': userId,
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
          status: true,
        );
      } else {
        return ResponseModel(
          message: 'Error occured adding this individual',
          status: false,
        );
      }
    } catch (error) {
      return ResponseModel(
        message: 'Error occured adding this individual',
        status: false,
      );
    }
  }

  Future<ResponseModel> addGroup({
    required BuildContext context,
    required String name,
    required String phone,
    required String cname,
    required String secretary,
    required int zone,
    required int state,
    required int lga,
    required int ward,
    required List<String> demand,
    required int userId,
  }) async {
    try {
      final url = Uri.parse('${ApiUrl.baseUrl}add/group');
      final header = await ApiUrl.setTokenHeaders();
      final body = json.encode({
        'user_id': userId,
        'demand': demand,
        'ward': ward,
        'lga': lga,
        'state': state,
        'zone': zone,
        'secretary': secretary,
        'cname': cname,
        'phone': phone,
        'name': name,
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
          status: true,
        );
      } else {
        return ResponseModel(
          message: 'Error occured adding this group',
          status: false,
        );
      }
    } catch (error) {
      return ResponseModel(
        message: 'Error occured adding this group',
        status: false,
      );
    }
  }
}
