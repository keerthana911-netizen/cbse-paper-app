class AppUser {
  final int id;
  final String name;
  final String email;
  final String role; // "student" | "teacher" | "admin"

  AppUser({required this.id, required this.name, required this.email, required this.role});

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
    );
  }
}

class FixedPaper {
  final int id;
  final String subject;
  final String difficulty;
  final int marks;
  final String? duration;

  FixedPaper({
    required this.id,
    required this.subject,
    required this.difficulty,
    required this.marks,
    this.duration,
  });

  factory FixedPaper.fromJson(Map<String, dynamic> json) {
    return FixedPaper(
      id: json['id'],
      subject: json['subject'],
      difficulty: json['difficulty'],
      marks: json['marks'],
      duration: json['duration'],
    );
  }
}

class Question {
  final int id;
  final String subject;
  final String chapter;
  final String difficulty;
  final String questionText;
  final String? optionA;
  final String? optionB;
  final String? optionC;
  final String? optionD;
  final String? correctOption;
  final String? answerText;
  final int marks;
  final String questionType; // "mcq" | "short_answer" | "long_answer"

  Question({
    required this.id,
    required this.subject,
    required this.chapter,
    required this.difficulty,
    required this.questionText,
    this.optionA,
    this.optionB,
    this.optionC,
    this.optionD,
    this.correctOption,
    this.answerText,
    required this.marks,
    required this.questionType,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      subject: json['subject'],
      chapter: json['chapter'],
      difficulty: json['difficulty'],
      questionText: json['question_text'],
      optionA: json['option_a'],
      optionB: json['option_b'],
      optionC: json['option_c'],
      optionD: json['option_d'],
      correctOption: json['correct_option'],
      answerText: json['answer_text'],
      marks: json['marks'],
      questionType: json['question_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'chapter': chapter,
      'difficulty': difficulty,
      'question_text': questionText,
      'option_a': optionA,
      'option_b': optionB,
      'option_c': optionC,
      'option_d': optionD,
      'correct_option': correctOption,
      'answer_text': answerText,
      'marks': marks,
      'question_type': questionType,
    };
  }
}
