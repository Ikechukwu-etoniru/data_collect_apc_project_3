import 'package:hive/hive.dart';

part 'individual.g.dart';

@HiveType(typeId: 4)
class Individual extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String phone;
  @HiveField(2)
  final String cphone;
  @HiveField(3)
  final int zone;
  @HiveField(4)
  final int state;
  @HiveField(5)
  final int lga;
  @HiveField(6)
  final int ward;
  @HiveField(7)
  final int vstate;
  @HiveField(8)
  final int vlga;
  @HiveField(9)
  final int vward;
  @HiveField(10)
  final String category;
  @HiveField(11)
  final String pollingUnit;
  @HiveField(12)
  final List<String> demand;
  @HiveField(13)
  final String vinNumber;

  Individual({
    required this.category,
    required this.cphone,
    required this.demand,
    required this.lga,
    required this.name,
    required this.phone,
    required this.pollingUnit,
    required this.state,
    required this.vlga,
    required this.vstate,
    required this.vward,
    required this.ward,
    required this.zone,
    required this.vinNumber,
  });
}
