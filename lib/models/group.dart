import 'package:hive/hive.dart';

part 'group.g.dart';

@HiveType(typeId: 5)
class Group extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String phone;
  @HiveField(2)
  final String cname;
  @HiveField(3)
  final String secretary;
  @HiveField(4)
  final int zone;
  @HiveField(5)
  final int state;
  @HiveField(6)
  final int lga;
  @HiveField(7)
  final int ward;
  @HiveField(8)
  final List<String> demand;

  Group({
    required this.cname,
    required this.demand,
    required this.lga,
    required this.name,
    required this.phone,
    required this.secretary,
    required this.state,
    required this.ward,
    required this.zone,
  });
}
