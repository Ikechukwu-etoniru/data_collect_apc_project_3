import 'dart:convert';


import 'package:data_collect_v2/helper/boxes.dart';
import 'package:data_collect_v2/models/exception.dart';
import 'package:data_collect_v2/models/lg.dart';
import 'package:data_collect_v2/models/state.dart';
import 'package:data_collect_v2/models/ward.dart';
import 'package:data_collect_v2/utils/api_url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LocationProvider with ChangeNotifier {

  List<StateModel> _states = [];

  List<StateModel> get states {
    return [..._states];
  }

  List<LgModel> _lgas = [];

  List<LgModel> get lgas {
    return [..._lgas];
  }

  List<WardModel> _wards = [];

  List<WardModel> get wards {
    return [..._wards];
  }

  Future addAllStatesToDb() async {
    try {
      final url = Uri.parse('${ApiUrl.baseUrl}get/fetch-state');
      final header = ApiUrl.setHeaders();
      final response = await http.get(
        url,
        headers: header,
      );
      final res = json.decode(response.body);
      print(res);
      if (response.statusCode == 201 || response.statusCode == 200) {
        List<StateModel> stateListFromDb = [];
        List dbStates = res;
        for (var element in dbStates) {
          final singleState = StateModel(
            zoneId: element['zone_id'].toString(),
            name: element['name'],
            stateId: element['id'],
          );
          stateListFromDb.add(singleState);
        }

        var box = Boxes.getStates();
        box.addAll(stateListFromDb);
      } else {
        throw AppException('An error occurred');
      }
    } catch (error) {
      print(error);
      throw AppException('An error occurred');
    }
  }

  Future addAllLgasToDb() async {
    try {
      final url = Uri.parse('${ApiUrl.baseUrl}get/fetch-lgas');
      final header = ApiUrl.setHeaders();
      final response = await http.get(
        url,
        headers: header,
      );
      final res = json.decode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        List<LgModel> lgListFromDb = [];
        List dbLgas = res;
        for (var element in dbLgas) {
          final singleLg = LgModel(
            lgaId: element['id'],
            stateId: element['state_id'].toString(),
            name: element['name'],
          );
          lgListFromDb.add(singleLg);
        }

        var box = Boxes.getLgas();
        box.addAll(lgListFromDb);
      } else {
        throw AppException('An error occurred');
      }
    } catch (error) {
      throw AppException('An error occurred');
    }
  }

  Future addAllWardToDb() async {
    try {
      final url = Uri.parse('${ApiUrl.baseUrl}get/fetch-wards');
      final header = ApiUrl.setHeaders();
      final response = await http.get(
        url,
        headers: header,
      );
      final res = json.decode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        List<WardModel> wardListFromDb = [];
        List dbWards = res;
        for (var element in dbWards) {
          final singleWard = WardModel(
            wardId: element['id'],
            lgaId: element['lga_id'].toString(),
            name: element['name'],
          );
          wardListFromDb.add(singleWard);
        }

        var box = Boxes.getWards();
        box.addAll(wardListFromDb);
      } else {
        throw AppException('An error occurred');
      }
    } catch (error) {
      throw AppException('An error occurred');
    }
  }

  Future getAllStateFromDb() async {
    var box = Boxes.getStates();
    var statesList = box.values;
    _states.addAll(statesList);
  }

  Future getAllLgaFromDb() async {
    var box = Boxes.getLgas();
    var lgasList = box.values;
    _lgas.addAll(lgasList);
  }

  Future getAllWardsFromDb() async {
    var box = Boxes.getWards();
    var wardsList = box.values;
    _wards.addAll(wardsList);
  }

  List<StateModel> getStateByZoneId(String zoneId) {
    return _states.where((element) => element.zoneId == zoneId).toList();
  }

  Future<List<LgModel>> getLgaByStateId(String stateId) async {
    return _lgas.where((element) => element.stateId == stateId).toList();
  }

  Future<List<WardModel>> getwardByLgaId(String lgaId) async {
    return _wards.where((element) => element.lgaId == lgaId).toList();
  }

  
}
