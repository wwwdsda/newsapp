import 'package:flutter/material.dart';

class NewsItem {
  final String category;
  final String title;
  final String summary;
  final String time;
  final DateTime date;
  final bool isScrapped;
  final bool isValid;

  NewsItem({
    required this.category,
    required this.title,
    required this.summary,
    required this.date,
    required this.isScrapped,
    required this.time,
    required this.isValid,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      title: json['title'] ?? '',
      summary: json['summary'] ?? '',
      date: DateTime.parse(json['date']),
      category: json['category'] ?? '',
      isScrapped: json['isScrapped'] == 1 || json['isScrapped'] == true,
      time: json['time'] ?? '',
      isValid: json['isValid'] ?? false,
    );
  }

  NewsItem copyWith({
    String? category,
    String? title,
    String? summary,
    String? time,
    DateTime? date,
    bool? isScrapped,
    bool? isValid,
  }) {
    return NewsItem(
      category: category ?? this.category,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      time: time ?? this.time,
      date: date ?? this.date,
      isScrapped: isScrapped ?? this.isScrapped,
      isValid: isValid ?? this.isValid,
    );
  }
}
