import 'package:flutter/material.dart';

class Subject {
  const Subject({
    required this.name,
    required this.code,
    required this.teacher,
    required this.credits,
    required this.color,
    this.lectureDay,
    this.lecturePeriod,
    this.labDay,
    this.labPeriod,
    this.practiceDay,
    this.practicePeriod,
  });

  final String name;
  final String code;
  final String teacher;
  final int credits;
  final Color color;
  final int? lectureDay;
  final int? lecturePeriod;
  final int? labDay;
  final int? labPeriod;
  final int? practiceDay;
  final int? practicePeriod;
}

class StudentTask {
  const StudentTask({
    required this.title,
    required this.subjectCode,
    required this.dueDate,
    required this.type,
    this.isDone = false,
  });

  final String title;
  final String subjectCode;
  final DateTime dueDate;
  final String type;
  final bool isDone;

  StudentTask copyWith({bool? isDone}) => StudentTask(
    title: title,
    subjectCode: subjectCode,
    dueDate: dueDate,
    type: type,
    isDone: isDone ?? this.isDone,
  );
}

class StudyNote {
  const StudyNote({
    required this.title,
    required this.subjectCode,
    required this.summary,
    required this.updatedAt,
  });

  final String title;
  final String subjectCode;
  final String summary;
  final DateTime updatedAt;
}

const weekdays = ['Даваа', 'Мягмар', 'Лхагва', 'Пүрэв', 'Баасан'];

const periodTimes = {
  1: '08:00–09:30',
  2: '09:40–11:10',
  3: '11:20–12:50',
  4: '13:20–14:50',
  5: '15:00–16:30',
  6: '16:40–18:10',
};
