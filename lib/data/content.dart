import 'dart:convert';
import 'package:flutter/services.dart';

class QuizQuestion {
  const QuizQuestion({
    required this.prompt,
    required this.answers,
    required this.correctIndex,
    required this.explanation,
  });

  final String prompt;
  final List<String> answers;
  final int correctIndex;
  final String explanation;

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      prompt: json['prompt'] as String,
      answers: List<String>.from(json['answers']),
      correctIndex: json['correctIndex'] as int,
      explanation: json['explanation'] as String,
    );
  }
}

class Lesson {
  const Lesson({
    required this.id,
    required this.title,
    required this.eyebrow,
    required this.description,
    required this.example,
    required this.questions,
  });

  final String id;
  final String title;
  final String eyebrow;
  final String description;
  final String example;
  final List<QuizQuestion> questions;

  factory Lesson.fromJson(Map<String, dynamic> json) {
    var questionList = json['questions'] as List;
    List<QuizQuestion> parsedQuestions = questionList
        .map((q) => QuizQuestion.fromJson(q as Map<String, dynamic>))
        .toList();

    return Lesson(
      id: json['id'] as String,
      title: json['title'] as String,
      eyebrow: json['eyebrow'] as String,
      description: json['description'] as String,
      example: json['example'] as String,
      questions: parsedQuestions,
    );
  }
}

class PracticeMessage {
  const PracticeMessage({
    required this.id,
    required this.channel,
    required this.sender,
    required this.subject,
    required this.body,
    required this.isScam,
    required this.explanation,
  });

  final String id;
  final String channel;
  final String sender;
  final String subject;
  final String body;
  final bool isScam;
  final String explanation;

  factory PracticeMessage.fromJson(Map<String, dynamic> json) {
    return PracticeMessage(
      id: json['id'] as String,
      channel: json['channel'] as String,
      sender: json['sender'] as String,
      subject: json['subject'] as String,
      body: json['body'] as String,
      isScam: json['isScam'] as bool,
      explanation: json['explanation'] as String,
    );
  }
}

class ContentLoader {
  // Dynamically load all lesson JSON files from the assets/lessons/ folder
  static Future<List<Lesson>> loadLessons() async {
    final AssetManifest assetManifest =
        await AssetManifest.loadFromAssetBundle(rootBundle);

    // Filter asset keys belonging to the lessons folder
    final List<String> lessonKeys = assetManifest
        .listAssets()
        .where((String key) =>
            key.startsWith('assets/lessons/') && key.endsWith('.json'))
        .toList();

    List<Lesson> lessons = [];
    for (String key in lessonKeys) {
      final String jsonString = await rootBundle.loadString(key);
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      lessons.add(Lesson.fromJson(jsonData));
    }

    return lessons;
  }

  // Dynamically load all practice message JSON files from the assets/practice_messages/ folder
  static Future<List<PracticeMessage>> loadPracticeMessages() async {
    final AssetManifest assetManifest =
        await AssetManifest.loadFromAssetBundle(rootBundle);

    final List<String> messageKeys = assetManifest
        .listAssets()
        .where((String key) =>
            key.startsWith('assets/practice_messages/') &&
            key.endsWith('.json'))
        .toList();

    List<PracticeMessage> messages = [];
    for (String key in messageKeys) {
      final String jsonString = await rootBundle.loadString(key);
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      messages.add(PracticeMessage.fromJson(jsonData));
    }

    return messages;
  }
}
