import 'package:flutter/material.dart';

import 'subjects.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  late List<Subject> subjects;

  @override
  void initState() {
    super.initState();
    subjects = List<Subject>.from(allSubjects);
  }

  Future<void> _showSubjectActions(int index, Subject subject) async {
    final action = await showModalBottomSheet<_SubjectAction>(
      context: context,
      builder: (context) => const _SubjectActionsSheet(),
    );
    if (action == null || !mounted) {
      return;
    }

    if (action == _SubjectAction.edit) {
      final updatedSubject = await showDialog<Subject>(
        context: context,
        builder: (context) => _AddSubjectDialog(initialSubject: subject),
      );
      if (updatedSubject != null && mounted) {
        setState(() => subjects[index] = updatedSubject);
      }
    } else {
      final shouldDelete = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete subject?'),
          content: Text('Delete "${subject.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        ),
      );
      if (shouldDelete == true && mounted) {
        setState(() => subjects.removeAt(index));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Student Dashboard'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: () {
              debugPrint('Logout clicked');
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 34,
                    backgroundImage: AssetImage('web/icons/student.avif'),
                    backgroundColor: Color(0xFFE8DEF8),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Miko Velez',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'ID: 555255\nBSIT 3RD YEAR',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Card(
                margin: EdgeInsets.zero,
                color: colorScheme.surfaceVariant,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.email_outlined),
                      title: Text('miko.velez@gmail.com'),
                      dense: true,
                    ),
                    ListTile(
                      leading: Icon(Icons.phone_outlined),
                      title: Text('+63 912 345 6789'),
                      dense: true,
                    ),
                    ListTile(
                      leading: Icon(Icons.home_outlined),
                      title: Text('123 Matina, Davao City, Philippines'),
                      dense: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Subjects',
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  for (final entry in subjects.asMap().entries)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Card(
                        margin: EdgeInsets.zero,
                        color: colorScheme.surfaceVariant,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          title: Text(entry.value.name),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Instructor: ${entry.value.instructor}'),
                                Text('Schedule: ${entry.value.schedule}'),
                              ],
                            ),
                          ),
                          onLongPress: () =>
                              _showSubjectActions(entry.key, entry.value),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add subject',
        onPressed: () async {
          debugPrint('Add Subject Clicked!');
          final subject = await showDialog<Subject>(
            context: context,
            builder: (context) => const _AddSubjectDialog(),
          );
          if (subject != null && context.mounted) {
            setState(() => subjects.add(subject));
          }
        },
        backgroundColor: const Color(0xFFDDC9FF),
        foregroundColor: const Color(0xFF3F2B61),
        child: const Icon(Icons.add),
      ),
    );
  }
}


class _AddSubjectDialog extends StatefulWidget {
  const _AddSubjectDialog({this.initialSubject});

  final Subject? initialSubject;

  @override
  State<_AddSubjectDialog> createState() => _AddSubjectDialogState();
}

class _AddSubjectDialogState extends State<_AddSubjectDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _instructorController;
  late final TextEditingController _scheduleController;

  @override
  void initState() {
    super.initState();
    final subject = widget.initialSubject;
    _nameController = TextEditingController(text: subject?.name);
    _instructorController = TextEditingController(text: subject?.instructor);
    _scheduleController = TextEditingController(text: subject?.schedule);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _instructorController.dispose();
    _scheduleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.initialSubject == null ? 'Add Subject' : 'Edit Subject',
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Subject name'),
                validator: _requiredFieldValidator,
              ),
              TextFormField(
                controller: _instructorController,
                decoration: const InputDecoration(labelText: 'Instructor'),
                validator: _requiredFieldValidator,
              ),
              TextFormField(
                controller: _scheduleController,
                decoration: const InputDecoration(labelText: 'Schedule'),
                validator: _requiredFieldValidator,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) {
              return;
            }
            Navigator.of(context).pop(
              Subject(
                name: _nameController.text.trim(),
                instructor: _instructorController.text.trim(),
                schedule: _scheduleController.text.trim(),
              ),
            );
          },
          child: Text(widget.initialSubject == null ? 'Add' : 'Save'),
        ),
      ],
    );
  }

  String? _requiredFieldValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }
}

enum _SubjectAction { edit, delete }

class _SubjectActionsSheet extends StatelessWidget {
  const _SubjectActionsSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: const Text('Edit'),
            onTap: () => Navigator.of(context).pop(_SubjectAction.edit),
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('Delete'),
            onTap: () => Navigator.of(context).pop(_SubjectAction.delete),
          ),
        ],
      ),
    );
  }
}