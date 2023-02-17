import 'package:hive/hive.dart';

part 'lg.g.dart';

@HiveType(typeId: 2)
class LgModel extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final int lgaId;
  @HiveField(2)
  final String stateId;

  LgModel({
    required this.name,
    required this.lgaId,
    required this.stateId,
  });
}
