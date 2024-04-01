class LocalGovernment {
  final int id;
  final String lgName;

  LocalGovernment({
    required this.id,
    required this.lgName,
  });

  factory LocalGovernment.fromSqfliteDatabase(Map<String, dynamic> map) =>
      LocalGovernment(
        id: map['id'] ?? 0,
        lgName: map['localGovernmentName'] ?? '',
      );
}
