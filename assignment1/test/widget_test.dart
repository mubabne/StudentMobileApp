import 'package:assignment1/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('login opens the student dashboard', (tester) async {
    await tester.pumpWidget(const StudentPlannerApp());

    expect(find.text('Тавтай морил'), findsOneWidget);
    expect(find.text('B242270045'), findsWidgets);

    await tester.tap(find.byKey(const Key('authSubmitButton')));
    await tester.pumpAndSettle();

    expect(find.text('Сайн уу, Мөнхбаяр'), findsOneWidget);
    expect(find.text('Ойрын хугацаа'), findsOneWidget);
    expect(find.text('Хичээлийн хуваарь'), findsNothing);
  });

  testWidgets('navigation opens the timetable', (tester) async {
    await tester.pumpWidget(const StudentPlannerApp());
    await tester.tap(find.byKey(const Key('authSubmitButton')));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.menu_book_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Хичээлийн хуваарь'), findsOneWidget);
    expect(find.text('Даваа'), findsOneWidget);
    expect(find.text('Баасан'), findsOneWidget);
  });
}
