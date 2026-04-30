class Calculation {
  final int? id;
  final String expression;
  final String result;
  final DateTime createdAt;

  Calculation({
    this.id,
    required this.expression,
    required this.result,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'expression': expression,
      'result': result,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Calculation.fromMap(Map<String, dynamic> map) {
    return Calculation(
      id: map['id'] as int?,
      expression: map['expression'] as String,
      result: map['result'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
