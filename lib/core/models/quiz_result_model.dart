class QuizResultModel {
  final String quizTitle;
  final String courseTitle;
  final int isClass;
  final String? classTitle;
  final String sectionTitle;
  final int attemptCount;
  final String score;
  final int scorePercentage;
  final String lastAttemptAt;

  QuizResultModel({
    required this.quizTitle,
    required this.courseTitle,
    required this.isClass,
    this.classTitle,
    required this.sectionTitle,
    required this.attemptCount,
    required this.score,
    required this.scorePercentage,
    required this.lastAttemptAt,
  });

  factory QuizResultModel.fromJson(Map<String, dynamic> json) {
    return QuizResultModel(
      quizTitle: json['quiz_title'] ?? '',
      courseTitle: json['course_title'] ?? '',
      isClass: json['is_class'] ?? 0,
      classTitle: json['class_title'],
      sectionTitle: json['section_title'] ?? '',
      attemptCount: json['attempt_count'] ?? 0,
      score: json['score'] ?? '0 / 0',
      scorePercentage: json['score_percentage'] ?? 0,
      lastAttemptAt: json['last_attempt_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quiz_title': quizTitle,
      'course_title': courseTitle,
      'is_class': isClass,
      'class_title': classTitle,
      'section_title': sectionTitle,
      'attempt_count': attemptCount,
      'score': score,
      'score_percentage': scorePercentage,
      'last_attempt_at': lastAttemptAt,
    };
  }
}
