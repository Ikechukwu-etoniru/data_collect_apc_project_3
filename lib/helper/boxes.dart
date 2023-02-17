
import 'package:data_collect_v2/models/group.dart';
import 'package:data_collect_v2/models/individual.dart';
import 'package:data_collect_v2/models/lg.dart';
import 'package:data_collect_v2/models/state.dart';
import 'package:data_collect_v2/models/ward.dart';
import 'package:hive/hive.dart';

class Boxes {
  static Box<StateModel> getStates() {
    return Hive.box<StateModel>('states');
  }

  static Box<LgModel> getLgas() {
    return Hive.box<LgModel>('lgas');
  }

  static Box<WardModel> getWards() {
    return Hive.box<WardModel>('wards');
  }

  static Box<Group> getGroups() {
    return Hive.box<Group>('groups');
  }

  static Box<Individual> getIndividual() {
    return Hive.box<Individual>('individuals');
  }
}
