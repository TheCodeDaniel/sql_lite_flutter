class States {
  final int id;
  final String stateName;

  States({
    required this.id,
    required this.stateName,
  });

  factory States.fromSqfliteDatabase(Map<String, dynamic> map) => States(
        id: map['id'] ?? 0,
        stateName: map['stateName'] ?? '',
      );
}
