import 'package:flutter/material.dart';

import 'app_store.dart';
import 'models.dart';
import 'subject_setup_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.store, required this.onSignOut});

  final AppStore store;
  final VoidCallback onSignOut;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardTab(
        store: widget.store,
        onOpenCalendar: () => setState(() => currentIndex = 1),
      ),
      CalendarTab(store: widget.store),
      SubjectsTab(store: widget.store),
      NotesTab(store: widget.store),
      ProfileTab(store: widget.store, onSignOut: widget.onSignOut),
    ];
    return AnimatedBuilder(
      animation: widget.store,
      builder: (context, _) => Scaffold(
        body: SafeArea(
          child: IndexedStack(index: currentIndex, children: pages),
        ),
        floatingActionButton: switch (currentIndex) {
          0 || 1 => FloatingActionButton.extended(
            onPressed: () => showTaskForm(context, widget.store),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Даалгавар'),
          ),
          2 => FloatingActionButton(
            onPressed: () => showSubjectForm(context, widget.store),
            child: const Icon(Icons.add_rounded),
          ),
          3 => FloatingActionButton.extended(
            onPressed: () => showNoteForm(context, widget.store),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Тэмдэглэл'),
          ),
          _ => null,
        },
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (value) =>
              setState(() => currentIndex = value),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Нүүр',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_month_outlined),
              selectedIcon: Icon(Icons.calendar_month_rounded),
              label: 'Календар',
            ),
            NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              selectedIcon: Icon(Icons.menu_book_rounded),
              label: 'Хичээл',
            ),
            NavigationDestination(
              icon: Icon(Icons.notes_outlined),
              selectedIcon: Icon(Icons.notes_rounded),
              label: 'Тэмдэглэл',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'Профайл',
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardTab extends StatelessWidget {
  const DashboardTab({
    super.key,
    required this.store,
    required this.onOpenCalendar,
  });

  final AppStore store;
  final VoidCallback onOpenCalendar;

  @override
  Widget build(BuildContext context) {
    final sortedTasks = [...store.tasks]
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
    final openTasks = sortedTasks.where((item) => !item.isDone).toList();
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: const Color(0xFF315CFF),
                  child: Text(
                    store.studentName.characters.first,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 19,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Сайн уу, ${store.studentName}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        store.studentId,
                        style: const TextStyle(color: Color(0xFF687086)),
                      ),
                    ],
                  ),
                ),
                IconButton.filledTonal(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_none_rounded),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          sliver: SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF315CFF), Color(0xFF7047EB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Энэ улирал',
                    style: TextStyle(
                      color: Color(0xFFDDE5FF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _summaryValue('${store.subjects.length}', 'Хичээл'),
                      _summaryDivider(),
                      _summaryValue('${store.totalCredits}', 'Кредит'),
                      _summaryDivider(),
                      _summaryValue('${openTasks.length}', 'Хийх ажил'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Ойрын хугацаа',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19),
                  ),
                ),
                TextButton(
                  onPressed: onOpenCalendar,
                  child: const Text('Бүгдийг харах'),
                ),
              ],
            ),
          ),
        ),
        if (openTasks.isEmpty)
          const SliverToBoxAdapter(
            child: _EmptyCard(
              icon: Icons.task_alt_rounded,
              text: 'Бүх ажлаа дуусгалаа!',
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList.separated(
              itemCount: openTasks.length.clamp(0, 3),
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final task = openTasks[index];
                final originalIndex = store.tasks.indexOf(task);
                return TaskCard(
                  task: task,
                  onToggle: () => store.toggleTask(originalIndex),
                );
              },
            ),
          ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 26, 20, 10),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Өнөөдрийн хичээл',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19),
                  ),
                ),
                Text(
                  _weekdayName(DateTime.now().weekday),
                  style: const TextStyle(color: Color(0xFF687086)),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 110),
          sliver: SliverToBoxAdapter(child: TodayClasses(store: store)),
        ),
      ],
    );
  }
}

Widget _summaryValue(String value, String label) => Expanded(
  child: Column(
    children: [
      Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 26,
          fontWeight: FontWeight.w800,
        ),
      ),
      Text(
        label,
        style: const TextStyle(color: Color(0xFFDDE5FF), fontSize: 12),
      ),
    ],
  ),
);

Widget _summaryDivider() =>
    Container(width: 1, height: 38, color: Colors.white24);

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task, required this.onToggle});

  final StudentTask task;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final days = _daysUntil(task.dueDate);
    final urgent = days <= 2 && !task.isDone;
    return Card(
      color: urgent ? const Color(0xFFFFF7DE) : Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onToggle,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: urgent
                      ? const Color(0xFFFFE49A)
                      : const Color(0xFFEDF1FF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  urgent
                      ? Icons.warning_amber_rounded
                      : Icons.assignment_outlined,
                  color: urgent
                      ? const Color(0xFF9A6500)
                      : const Color(0xFF315CFF),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        decoration: task.isDone
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${task.subjectCode} • ${task.type}',
                      style: const TextStyle(
                        color: Color(0xFF687086),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _dueLabel(task.dueDate),
                      style: TextStyle(
                        color: urgent
                            ? const Color(0xFF9A6500)
                            : const Color(0xFF687086),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Checkbox(value: task.isDone, onChanged: (_) => onToggle()),
            ],
          ),
        ),
      ),
    );
  }
}

class TodayClasses extends StatelessWidget {
  const TodayClasses({super.key, required this.store});

  final AppStore store;

  @override
  Widget build(BuildContext context) {
    final day = DateTime.now().weekday - 1;
    final entries = _scheduleFor(store.subjects, day);
    if (entries.isEmpty) {
      return const _EmptyCard(
        icon: Icons.free_breakfast_outlined,
        text: 'Өнөөдөр хичээлгүй',
      );
    }
    return Column(
      children: entries
          .map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ScheduleCard(entry: entry),
            ),
          )
          .toList(),
    );
  }
}

class CalendarTab extends StatefulWidget {
  const CalendarTab({super.key, required this.store});

  final AppStore store;

  @override
  State<CalendarTab> createState() => _CalendarTabState();
}

class _CalendarTabState extends State<CalendarTab> {
  late DateTime selectedDate = _dateOnly(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final start = selectedDate.subtract(
      Duration(days: selectedDate.weekday - 1),
    );
    final dayTasks = widget.store.tasks
        .where((item) => _sameDay(item.dueDate, selectedDate))
        .toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 110),
      children: [
        const Text(
          'Календар',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(
          '${selectedDate.year} оны ${selectedDate.month}-р сар',
          style: const TextStyle(color: Color(0xFF687086)),
        ),
        const SizedBox(height: 22),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (index) {
                final date = start.add(Duration(days: index));
                final selected = _sameDay(date, selectedDate);
                final hasTask = widget.store.tasks.any(
                  (item) => _sameDay(item.dueDate, date) && !item.isDone,
                );
                return InkWell(
                  onTap: () => setState(() => selectedDate = date),
                  borderRadius: BorderRadius.circular(16),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 40,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFF315CFF)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        Text(
                          _shortWeekday(date.weekday),
                          style: TextStyle(
                            fontSize: 11,
                            color: selected
                                ? Colors.white70
                                : const Color(0xFF8A91A3),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${date.day}',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: selected
                                ? Colors.white
                                : const Color(0xFF202538),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: hasTask
                                ? (selected
                                      ? Colors.white
                                      : const Color(0xFFFFB020))
                                : Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          '${selectedDate.day}-ны хийх ажил',
          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        if (dayTasks.isEmpty)
          const _EmptyCard(
            icon: Icons.event_available_rounded,
            text: 'Энэ өдөр хугацаа дуусах ажил алга',
          )
        else
          ...dayTasks.map(
            (task) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TaskCard(
                task: task,
                onToggle: () =>
                    widget.store.toggleTask(widget.store.tasks.indexOf(task)),
              ),
            ),
          ),
        const SizedBox(height: 20),
        const Text(
          'Бүх хугацаа',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        ...([
          ...widget.store.tasks,
        ]..sort((a, b) => a.dueDate.compareTo(b.dueDate))).map(
          (task) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TaskCard(
              task: task,
              onToggle: () =>
                  widget.store.toggleTask(widget.store.tasks.indexOf(task)),
            ),
          ),
        ),
      ],
    );
  }
}

class SubjectsTab extends StatefulWidget {
  const SubjectsTab({super.key, required this.store});

  final AppStore store;

  @override
  State<SubjectsTab> createState() => _SubjectsTabState();
}

class _SubjectsTabState extends State<SubjectsTab> {
  int selectedDay = (DateTime.now().weekday - 1).clamp(0, 4);

  @override
  Widget build(BuildContext context) {
    final schedule = _scheduleFor(widget.store.subjects, selectedDay);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 18, 20, 4),
          child: Text(
            'Хичээлийн хуваарь',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Даваагаас Баасан хүртэл',
            style: TextStyle(color: Color(0xFF687086)),
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          height: 46,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: weekdays.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) => ChoiceChip(
              label: Text(weekdays[index]),
              selected: selectedDay == index,
              onSelected: (_) => setState(() => selectedDay = index),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: schedule.isEmpty
              ? const _EmptyCard(
                  icon: Icons.event_busy_outlined,
                  text: 'Энэ өдөр хичээлгүй',
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 110),
                  itemCount: schedule.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) =>
                      _ScheduleCard(entry: schedule[index]),
                ),
        ),
      ],
    );
  }
}

class _ScheduleEntry {
  const _ScheduleEntry(this.subject, this.period, this.kind);
  final Subject subject;
  final int period;
  final String kind;
}

List<_ScheduleEntry> _scheduleFor(List<Subject> subjects, int day) {
  final items = <_ScheduleEntry>[];
  for (final subject in subjects) {
    if (subject.lectureDay == day && subject.lecturePeriod != null) {
      items.add(_ScheduleEntry(subject, subject.lecturePeriod!, 'Лекц'));
    }
    if (subject.labDay == day && subject.labPeriod != null) {
      items.add(_ScheduleEntry(subject, subject.labPeriod!, 'Лаб'));
    }
    if (subject.practiceDay == day && subject.practicePeriod != null) {
      items.add(_ScheduleEntry(subject, subject.practicePeriod!, 'Дадлага'));
    }
  }
  items.sort((a, b) => a.period.compareTo(b.period));
  return items;
}

class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard({required this.entry});
  final _ScheduleEntry entry;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 5,
              height: 70,
              decoration: BoxDecoration(
                color: entry.subject.color,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.subject.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${entry.subject.code} • ${entry.subject.teacher}',
                    style: const TextStyle(
                      color: Color(0xFF687086),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${entry.period}-р цаг  ${periodTimes[entry.period]}',
                    style: TextStyle(
                      color: entry.subject.color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Chip(
              label: Text(entry.kind),
              side: BorderSide.none,
              backgroundColor: entry.subject.color.withValues(alpha: .10),
            ),
          ],
        ),
      ),
    );
  }
}

class NotesTab extends StatelessWidget {
  const NotesTab({super.key, required this.store});
  final AppStore store;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 110),
      children: [
        const Text(
          'Тэмдэглэл',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        const Text(
          'Лекцийн гол санаагаа товч хадгалаарай.',
          style: TextStyle(color: Color(0xFF687086)),
        ),
        const SizedBox(height: 20),
        if (store.notes.isEmpty)
          const _EmptyCard(
            icon: Icons.note_add_outlined,
            text: 'Тэмдэглэл алга',
          )
        else
          ...store.notes.map(
            (note) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            note.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        Chip(
                          label: Text(note.subjectCode),
                          side: BorderSide.none,
                          backgroundColor: const Color(0xFFEDF1FF),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      note.summary,
                      style: const TextStyle(
                        color: Color(0xFF4F566B),
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${note.updatedAt.month}/${note.updatedAt.day} шинэчилсэн',
                      style: const TextStyle(
                        color: Color(0xFF8A91A3),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key, required this.store, required this.onSignOut});
  final AppStore store;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 40),
      children: [
        const Text(
          'Профайл',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 22),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundColor: const Color(0xFF315CFF),
                  child: Text(
                    store.studentName.characters.first,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 26,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        store.studentName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        store.studentId,
                        style: const TextStyle(color: Color(0xFF687086)),
                      ),
                      Text(
                        '${store.studentId}@must.edu.mn',
                        style: const TextStyle(
                          color: Color(0xFF687086),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _statCard(
                Icons.school_outlined,
                '${store.totalCredits}',
                'Нийт кредит',
                const Color(0xFF315CFF),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _statCard(
                Icons.menu_book_outlined,
                '${store.subjects.length}',
                'Хичээл',
                const Color(0xFF00A982),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'Суралцах зөвлөмж',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF4FF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.auto_awesome_rounded, color: Color(0xFF315CFF)),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Ойрын даалгавраа 25 минутын хэсгүүдэд хувааж хийвэл төвлөрөхөд амархан.',
                  style: TextStyle(height: 1.4, color: Color(0xFF334168)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Card(
          child: Column(
            children: [
              const ListTile(
                leading: Icon(Icons.person_outline),
                title: Text('Хувийн мэдээлэл'),
                trailing: Icon(Icons.chevron_right),
              ),
              const Divider(height: 1, indent: 56),
              const ListTile(
                leading: Icon(Icons.settings_outlined),
                title: Text('Тохиргоо'),
                trailing: Icon(Icons.chevron_right),
              ),
              const Divider(height: 1, indent: 56),
              ListTile(
                onTap: onSignOut,
                leading: const Icon(
                  Icons.logout_rounded,
                  color: Colors.redAccent,
                ),
                title: const Text(
                  'Гарах',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _statCard(IconData icon, String value, String label, Color color) =>
    Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
            ),
            Text(
              label,
              style: const TextStyle(color: Color(0xFF687086), fontSize: 12),
            ),
          ],
        ),
      ),
    );

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(icon, size: 36, color: const Color(0xFF8A91A3)),
            const SizedBox(height: 8),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF687086)),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showTaskForm(BuildContext context, AppStore store) async {
  if (store.subjects.isEmpty) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Эхлээд хичээл нэмнэ үү.')));
    return;
  }
  final formKey = GlobalKey<FormState>();
  final title = TextEditingController();
  String subjectCode = store.subjects.first.code;
  String type = 'Лаборатори';
  DateTime dueDate = DateTime.now().add(const Duration(days: 1));
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
                const Text(
                  'Шинэ даалгавар',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: title,
                  decoration: const InputDecoration(labelText: 'Гарчиг'),
                  validator: (value) => (value?.trim().isEmpty ?? true)
                      ? 'Гарчиг оруулна уу'
                      : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: subjectCode,
                  decoration: const InputDecoration(labelText: 'Хичээл'),
                  items: store.subjects
                      .map(
                        (item) => DropdownMenuItem(
                          value: item.code,
                          child: Text('${item.code} • ${item.name}'),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => subjectCode = value ?? subjectCode,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: type,
                  decoration: const InputDecoration(labelText: 'Төрөл'),
                  items: ['Лаборатори', 'Бие даалт', 'Дасгал', 'Шалгалт']
                      .map(
                        (item) =>
                            DropdownMenuItem(value: item, child: Text(item)),
                      )
                      .toList(),
                  onChanged: (value) => type = value ?? type,
                ),
                const SizedBox(height: 12),
                ListTile(
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: Color(0xFFE7EAF2)),
                  ),
                  leading: const Icon(Icons.event_outlined),
                  title: const Text('Дуусах хугацаа'),
                  subtitle: Text(
                    '${dueDate.year}/${dueDate.month}/${dueDate.day}',
                  ),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: dueDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 730)),
                    );
                    if (picked != null) setModalState(() => dueDate = picked);
                  },
                ),
                const SizedBox(height: 18),
                FilledButton(
                  onPressed: () {
                    if (!(formKey.currentState?.validate() ?? false)) return;
                    store.addTask(
                      StudentTask(
                        title: title.text.trim(),
                        subjectCode: subjectCode,
                        dueDate: dueDate,
                        type: type,
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
  title.dispose();
}

Future<void> showNoteForm(BuildContext context, AppStore store) async {
  if (store.subjects.isEmpty) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Эхлээд хичээл нэмнэ үү.')));
    return;
  }
  final formKey = GlobalKey<FormState>();
  final title = TextEditingController();
  final summary = TextEditingController();
  String subjectCode = store.subjects.first.code;
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => Padding(
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
              const Text(
                'Шинэ тэмдэглэл',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: title,
                decoration: const InputDecoration(labelText: 'Гарчиг'),
                validator: (value) => (value?.trim().isEmpty ?? true)
                    ? 'Гарчиг оруулна уу'
                    : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: subjectCode,
                decoration: const InputDecoration(labelText: 'Хичээл'),
                items: store.subjects
                    .map(
                      (item) => DropdownMenuItem(
                        value: item.code,
                        child: Text(item.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) => subjectCode = value ?? subjectCode,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: summary,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: 'Гол санаа',
                  alignLabelWithHint: true,
                ),
                validator: (value) => (value?.trim().isEmpty ?? true)
                    ? 'Тэмдэглэл оруулна уу'
                    : null,
              ),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: () {
                  if (!(formKey.currentState?.validate() ?? false)) return;
                  store.addNote(
                    StudyNote(
                      title: title.text.trim(),
                      subjectCode: subjectCode,
                      summary: summary.text.trim(),
                      updatedAt: DateTime.now(),
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
  );
  title.dispose();
  summary.dispose();
}

DateTime _dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);
bool _sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;
int _daysUntil(DateTime value) =>
    _dateOnly(value).difference(_dateOnly(DateTime.now())).inDays;

String _dueLabel(DateTime value) {
  final days = _daysUntil(value);
  if (days < 0) return '${-days} хоног хэтэрсэн';
  if (days == 0) return 'Өнөөдөр дуусна';
  if (days == 1) return 'Маргааш дуусна';
  return '$days хоногийн дараа • ${value.month}/${value.day}';
}

String _weekdayName(int day) =>
    day >= 1 && day <= 5 ? weekdays[day - 1] : 'Амралтын өдөр';
String _shortWeekday(int day) =>
    const ['Да', 'Мя', 'Лх', 'Пү', 'Ба', 'Бя', 'Ня'][day - 1];
