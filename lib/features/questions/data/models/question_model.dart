import 'package:neclicensepreperation/features/questions/domain/entities/question.dart';

class QuestionModel extends Question {
  QuestionModel({
    required super.id,
    required super.userId,
    required super.question,
    required super.option1,
    required super.option2,
    required super.option3,
    required super.option4,
    required super.answer,
    required super.topics,
    required super.updatedAt,
    required super.difficulty, // New difficulty field
  });

  // Convert the QuestionModel instance to JSON format
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'user_id': userId,
      'question': question,
      'option1': option1,
      'option2': option2,
      'option3': option3,
      'option4': option4,
      'answer': answer,
      'topics': topics,
      'updated_at': updatedAt.toIso8601String(),
      'difficulty': difficulty, // Include difficulty in JSON
    };
  }

  // Create a QuestionModel instance from JSON data
  factory QuestionModel.fromJson(Map<String, dynamic> map) {
    return QuestionModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      question: map['question'] as String,
      option1: map['option1'] as String,
      option2: map['option2'] as String,
      option3: map['option3'] as String,
      option4: map['option4'] as String,
      answer: map['answer'] as String,
      topics: map['topics'] == null
          ? []
          : List<String>.from(
              (map['topics'] as List<dynamic>).map((e) => e.toString())),
      updatedAt: map['updated_at'] == null
          ? DateTime.now()
          : DateTime.parse(map['updated_at']),
      difficulty: map['difficulty'] as String, // Parse difficulty from JSON
    );
  }
}
