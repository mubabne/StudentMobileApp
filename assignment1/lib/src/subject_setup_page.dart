import 'package:flutter/material.dart';

import 'app_store.dart';
import 'models.dart';

class SubjectSetupPage extends StatelessWidget {
  const SubjectSetupPage({
    super.key,
    required this.store,
    required this.onComplete,
  });

  final AppStore store;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: const Text('Хичээлүүдээ нэмэх'),
          centerTitle: false,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Энэ улиралд үзэж байгаа хичээлүүдээ оруулна уу.',
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Дараа нь хуваарь, даалгавраа хялбар төлөвлөнө.',
                  style: TextStyle(color: Color(0xFF687086)),
                ),
                const SizedBox(height: 22),
                Expanded(
                  child: store.subjects.isEmpty
                      ? const _EmptySubjects()
                      : ListView.separated(
                          itemCount: store.subjects.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final subject = store.subjects[index];
                            return Card(
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 8,
                                ),
                                leading: CircleAvatar(
                                  backgroundColor: subject.color.withValues(
                                    alpha: .12,
                                  ),
                                  child: Icon(
                                    Icons.menu_book_rounded,
                                    color: subject.color,
                                  ),
                                ),
                                title: Text(
                                  subject.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                subtitle: Text(
                                  '${subject.code} • ${subject.teacher}',
                                ),
                              ),
                            );
                          },
                        ),
                ),
                OutlinedButton.icon(
                  onPressed: () => showSubjectForm(context, store),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Хичээл нэмэх'),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: store.subjects.isEmpty ? null : onComplete,
                  child: const Text('Үргэлжлүүлэх'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptySubjects extends StatelessWidget {
  const _EmptySubjects();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.library_add_outlined,
            size: 62,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 12),
          const Text(
            'Одоогоор хичээл алга',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
          ),
        ],
      ),
    );
  }
}

Future<void> showSubjectForm(BuildContext context, AppStore store) async {
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final code = TextEditingController();
  final teacher = TextEditingController();
  int credits = 3;
  int? lectureDay;
  int? lecturePeriod;
  int? labDay;
  int? labPeriod;

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => StatefulBuilder(
      builder: (context, setModalState) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          MediaQuery.viewInsetsOf(context).bottom + 20,
        ),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Шинэ хичээл',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: name,
                  decoration: const InputDecoration(labelText: 'Хичээлийн нэр'),
                  validator: (value) =>
                      (value?.trim().isEmpty ?? true) ? 'Нэр оруулна уу' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: code,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(labelText: 'Хичээлийн код'),
                  validator: (value) =>
                      (value?.trim().isEmpty ?? true) ? 'Код оруулна уу' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: teacher,
                  decoration: const InputDecoration(labelText: 'Багш'),
                  validator: (value) => (value?.trim().isEmpty ?? true)
                      ? 'Багшийн нэр оруулна уу'
                      : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  initialValue: credits,
                  decoration: const InputDecoration(labelText: 'Кредит'),
                  items: [1, 2, 3, 4, 5]
                      .map(
                        (value) => DropdownMenuItem(
                          value: value,
                          child: Text('$value кредит'),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => credits = value ?? 3,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Лекцийн хуваарь (сонголттой)',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _dayDropdown(
                        lectureDay,
                        (value) => setModalState(() => lectureDay = value),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _periodDropdown(
                        lecturePeriod,
                        (value) => setModalState(() => lecturePeriod = value),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Лабораторийн хуваарь (сонголттой)',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _dayDropdown(
                        labDay,
                        (value) => setModalState(() => labDay = value),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _periodDropdown(
                        labPeriod,
                        (value) => setModalState(() => labPeriod = value),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () {
                    if (!(formKey.currentState?.validate() ?? false)) return;
                    const colors = [
                      Color(0xFF315CFF),
                      Color(0xFF7C4DFF),
                      Color(0xFF00A982),
                      Color(0xFFFF7A45),
                    ];
                    store.addSubject(
                      Subject(
                        name: name.text.trim(),
                        code: code.text.trim().toUpperCase(),
                        teacher: teacher.text.trim(),
                        credits: credits,
                        color: colors[store.subjects.length % colors.length],
                        lectureDay: lectureDay,
                        lecturePeriod: lecturePeriod,
                        labDay: labDay,
                        labPeriod: labPeriod,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('Хадгалах'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  name.dispose();
  code.dispose();
  teacher.dispose();
}

Widget _dayDropdown(int? value, ValueChanged<int?> onChanged) =>
    DropdownButtonFormField<int>(
      initialValue: value,
      decoration: const InputDecoration(labelText: 'Өдөр'),
      items: List.generate(
        5,
        (index) => DropdownMenuItem(value: index, child: Text(weekdays[index])),
      ),
      onChanged: onChanged,
    );

Widget _periodDropdown(int? value, ValueChanged<int?> onChanged) =>
    DropdownButtonFormField<int>(
      initialValue: value,
      decoration: const InputDecoration(labelText: 'Цаг'),
      items: List.generate(
        6,
        (index) => DropdownMenuItem(
          value: index + 1,
          child: Text('${index + 1}-р цаг'),
        ),
      ),
      onChanged: onChanged,
    );
