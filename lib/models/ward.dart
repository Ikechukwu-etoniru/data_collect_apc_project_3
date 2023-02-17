import 'package:hive/hive.dart';

part 'ward.g.dart';

@HiveType(typeId: 3)
class WardModel extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final int wardId;
  @HiveField(2)
  final String lgaId;

  WardModel({
    required this.name,
    required this.wardId,
    required this.lgaId,
  });
}
