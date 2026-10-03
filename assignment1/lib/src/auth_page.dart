import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key, required this.onAuthenticated});

  final void Function(String id, String name, bool isNew) onAuthenticated;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final formKey = GlobalKey<FormState>();
  final idController = TextEditingController(text: 'B242270045');
  final passwordController = TextEditingController(text: 'student1');
  final nameController = TextEditingController();
  final codeController = TextEditingController();
  bool registering = false;
  bool codeSent = false;
  bool hidePassword = true;

  @override
  void dispose() {
    idController.dispose();
    passwordController.dispose();
    nameController.dispose();
    codeController.dispose();
    super.dispose();
  }

  bool get validId =>
      RegExp(r'^B\d{9}$').hasMatch(idController.text.trim().toUpperCase());

  void submit() {
    if (!(formKey.currentState?.validate() ?? false)) return;
    if (registering && !codeSent) {
      setState(() => codeSent = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${idController.text.toUpperCase()}@must.edu.mn хаяг руу код илгээлээ.',
          ),
        ),
      );
      return;
    }
    widget.onAuthenticated(
      idController.text.trim(),
      registering ? nameController.text : 'Мөнхбаяр',
      registering,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: const Color(0xFF315CFF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.school_rounded,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      registering ? 'Бүртгэл үүсгэх' : 'Тавтай морил',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF111827),
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      registering
                          ? 'Сургуулийн хаягаа баталгаажуулаад эхлээрэй.'
                          : 'Хичээл, даалгавраа нэг дор төлөвлө.',
                      style: const TextStyle(
                        color: Color(0xFF687086),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      key: const Key('studentIdField'),
                      controller: idController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: const InputDecoration(
                        labelText: 'Оюутны код',
                        hintText: 'B242270045',
                        prefixIcon: Icon(Icons.badge_outlined),
                      ),
                      validator: (_) => validId
                          ? null
                          : 'B үсэг болон 9 оронтой код оруулна уу',
                      onChanged: (_) {
                        if (codeSent) setState(() => codeSent = false);
                      },
                    ),
                    if (registering) ...[
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Нэр',
                          prefixIcon: Icon(Icons.person_outline_rounded),
                        ),
                        validator: (value) => (value?.trim().isEmpty ?? true)
                            ? 'Нэрээ оруулна уу'
                            : null,
                      ),
                    ],
                    if (registering && codeSent) ...[
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: codeController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Баталгаажуулах код',
                          helperText: 'Demo код: 123456',
                          prefixIcon: Icon(Icons.mark_email_read_outlined),
                        ),
                        validator: (value) =>
                            value == '123456' ? null : 'Demo код 123456',
                      ),
                    ],
                    if (!registering || codeSent) ...[
                      const SizedBox(height: 14),
                      TextFormField(
                        key: const Key('passwordField'),
                        controller: passwordController,
                        obscureText: hidePassword,
                        decoration: InputDecoration(
                          labelText: registering ? 'Шинэ нууц үг' : 'Нууц үг',
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          suffixIcon: IconButton(
                            onPressed: () =>
                                setState(() => hidePassword = !hidePassword),
                            icon: Icon(
                              hidePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                        ),
                        validator: (value) => (value?.length ?? 0) < 6
                            ? 'Доод тал нь 6 тэмдэгт байна'
                            : null,
                      ),
                    ],
                    const SizedBox(height: 22),
                    FilledButton(
                      key: const Key('authSubmitButton'),
                      onPressed: submit,
                      child: Text(
                        registering
                            ? (codeSent ? 'Бүртгэл үүсгэх' : 'Код илгээх')
                            : 'Нэвтрэх',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => setState(() {
                        registering = !registering;
                        codeSent = false;
                      }),
                      child: Text(
                        registering
                            ? 'Бүртгэлтэй юу? Нэвтрэх'
                            : 'Шинэ хэрэглэгч үү? Бүртгүүлэх',
                      ),
                    ),
                    if (!registering) ...[
                      const SizedBox(height: 18),
                      const Row(
                        children: [
                          Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'эсвэл',
                              style: TextStyle(color: Color(0xFF8A91A3)),
                            ),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 18),
                      OutlinedButton.icon(
                        onPressed: () => ScaffoldMessenger.of(context)
                            .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Microsoft холболтод Azure тохиргоо шаардлагатай.',
                                ),
                              ),
                            ),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(54),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        icon: const Icon(Icons.window_rounded),
                        label: const Text('Microsoft хаягаар нэвтрэх'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
