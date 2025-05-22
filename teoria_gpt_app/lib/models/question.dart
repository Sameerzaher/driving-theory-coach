// Your Question class definition here
class Question {
  // Example fields
  final String field1;
  final int field2;

  // Unnamed constructor
  Question({
    required this.field1,
    required this.field2,
  });

  // Add this factory constructor for JSON deserialization
  factory Question.fromJson(Map<String, dynamic> json) {
    // Replace the following with your actual fields and parsing logic
    return Question(
      field1: json['field1'],
      field2: json['field2'],
    );
  }
}