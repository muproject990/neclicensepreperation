class Question {
  final String id;
  final String userId;
  final String question;
  final String option1;
  final String option2;
  final String option3;
  final String option4;
  final String answer;
  final List<String> topics;
  final DateTime updatedAt;
  final String difficulty;

  Question({
    required this.id,
    required this.userId,
    required this.question,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.option4,
    required this.answer,
    required this.topics,
    required this.updatedAt,
    required this.difficulty,
  });

  // Factory method to parse from Supabase CSV-like data
  factory Question.fromSupabase(String data) {
    List<String> fields = data.split(',');

    // Parsing the topics list by removing surrounding brackets and splitting by comma
    List<String> topics = fields[8]
        .replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll('"', '')
        .split(',');

    return Question(
      id: fields[0],
      updatedAt: DateTime.parse(fields[1]),
      userId: fields[2],
      question: fields[3],
      option1: fields[4],
      option2: fields[5],
      option3: fields[6],
      option4: fields[7],
      answer: fields[9],
      topics: topics,
      difficulty: fields[10],
    );
  }
}
