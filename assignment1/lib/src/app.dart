import 'package:flutter/material.dart';

import 'app_store.dart';
import 'auth_page.dart';
import 'home_page.dart';
import 'subject_setup_page.dart';

class StudentPlannerApp extends StatefulWidget {
  const StudentPlannerApp({super.key});

  @override
  State<StudentPlannerApp> createState() => _StudentPlannerAppState();
}

class _StudentPlannerAppState extends State<StudentPlannerApp> {
  final AppStore store = AppStore();
  bool signedIn = false;
  bool needsSetup = false;

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Оюутны төлөвлөгч',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF315CFF),
          brightness: Brightness.light,
          surface: const Color(0xFFF7F8FC),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F8FC),
        fontFamily: 'Arial',
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFE7EAF2)),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
      home: !signedIn
          ? AuthPage(
              onAuthenticated: (id, name, isNew) {
                setState(() {
                  if (isNew) {
                    store.prepareNewStudent(id, name);
                  } else {
                    store.setStudent(id, name);
                  }
                  signedIn = true;
                  needsSetup = isNew;
                });
              },
            )
          : needsSetup
          ? SubjectSetupPage(
              store: store,
              onComplete: () => setState(() => needsSetup = false),
            )
          : HomePage(
              store: store,
              onSignOut: () => setState(() => signedIn = false),
            ),
    );
  }
}
