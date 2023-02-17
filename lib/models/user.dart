class User {
  final int id;
  final String name;
  final String phone;
  final String? email;
  final int? stateId;
  final int? lgaId;
  final int? zoneId;
  final int? wardId;
  final String? address;
  final String? bankName;
  final String? acctNumber;
  final String? acctName;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.acctName,
    required this.acctNumber, 
    required this.address,
    required this.bankName,
    required this.email,
    required this.lgaId,
    required this.stateId,
    required this.wardId,
    required this.zoneId
  });
}
