class LocalGovernment{
  final int id;
  final String stateName;

  LocalGovernment({
    required this.id,
    required this.stateName,
  });

  factory LocalGovernment.fromSqfliteDatabase(Map<String, dynamic> map) => LocalGovernment(
        id: map['id'] ?? 0,
        stateName: map['stateName'] ?? '',
      );
}
