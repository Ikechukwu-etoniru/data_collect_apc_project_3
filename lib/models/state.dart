import 'package:hive/hive.dart';

part 'state.g.dart';

@HiveType(typeId: 1)
class StateModel extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final int stateId;
  @HiveField(2)
  final String zoneId;

  StateModel({
    required this.name,
    required this.stateId,
    required this.zoneId,
  });
}
