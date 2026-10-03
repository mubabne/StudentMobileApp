import 'package:flutter/material.dart';

import 'models.dart';

class AppStore extends ChangeNotifier {
  AppStore() {
    final now = DateTime.now();
    subjects.addAll(const [
      Subject(
        name: 'Мобайл программчлал',
        code: 'F.ITM301',
        teacher: 'Б. Батзориг',
        credits: 3,
        color: Color(0xFF315CFF),
        lectureDay: 0,
        lecturePeriod: 4,
        labDay: 2,
        labPeriod: 3,
      ),
      Subject(
        name: 'Өгөгдлийн сан',
        code: 'F.ITM204',
        teacher: 'Д. Энхтуяа',
        credits: 3,
        color: Color(0xFF7C4DFF),
        lectureDay: 1,
        lecturePeriod: 2,
        labDay: 4,
        labPeriod: 1,
      ),
      Subject(
        name: 'Програм хангамжийн зохиомж',
        code: 'F.ITM312',
        teacher: 'С. Мөнхбаяр',
        credits: 3,
        color: Color(0xFF00A982),
        lectureDay: 3,
        lecturePeriod: 3,
        practiceDay: 1,
        practicePeriod: 5,
      ),
    ]);
    tasks.addAll([
      StudentTask(
        title: 'UI загвар дуусгах',
        subjectCode: 'F.ITM301',
        dueDate: now.add(const Duration(days: 1)),
        type: 'Лаборатори 2',
      ),
      StudentTask(
        title: 'SQL query бодлого',
        subjectCode: 'F.ITM204',
        dueDate: now.add(const Duration(days: 3)),
        type: 'Бие даалт',
      ),
      StudentTask(
        title: 'Use case диаграм',
        subjectCode: 'F.ITM312',
        dueDate: now.add(const Duration(days: 7)),
        type: 'Дасгал',
      ),
    ]);
    notes.addAll([
      StudyNote(
        title: 'State management',
        subjectCode: 'F.ITM301',
        summary: 'Widget-ийн төлөв өөрчлөгдөхөд UI дахин зурагдана. Төлвийг хэрэгтэй түвшинд хадгалж, өгөгдлийн нэг эх үүсвэртэй байлгана.',
        updatedAt: now.subtract(const Duration(hours: 2)),
      ),
      StudyNote(
        title: 'Normalization',
        subjectCode: 'F.ITM204',
        summary: '1NF нь атом утга, 2NF нь хэсэгчилсэн хамаарлыг, 3NF нь дам хамаарлыг арилгана.',
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
    ]);
  }

  String studentId = 'B242270045';
  String studentName = 'Мөнхбаяр';
  final List<Subject> subjects = [];
  final List<StudentTask> tasks = [];
  final List<StudyNote> notes = [];

  int get totalCredits => subjects.fold(0, (sum, item) => sum + item.credits);

  void setStudent(String id, String name) {
    studentId = id.toUpperCase();
    studentName = name.trim().isEmpty ? 'Оюутан' : name.trim();
    notifyListeners();
  }

  void prepareNewStudent(String id, String name) {
    studentId = id.toUpperCase();
    studentName = name.trim().isEmpty ? 'Оюутан' : name.trim();
    subjects.clear();
    tasks.clear();
    notes.clear();
    notifyListeners();
  }

  void addSubject(Subject subject) {
    subjects.add(subject);
    notifyListeners();
  }

  void addTask(StudentTask task) {
    tasks.add(task);
    notifyListeners();
  }

  void toggleTask(int index) {
    tasks[index] = tasks[index].copyWith(isDone: !tasks[index].isDone);
    notifyListeners();
  }

  void addNote(StudyNote note) {
    notes.insert(0, note);
    notifyListeners();
  }
}
