class Subject {
  const Subject({
    required this.name,
    required this.instructor,
    required this.schedule,
  });

  final String name;
  final String instructor;
  final String schedule;
}

const List<Subject> allSubjects = [
  Subject(
    name: 'Mobile App Development',
    instructor: 'Mr. Smith',
    schedule: 'Mon/Wed 10:00 - 11:30 AM',
  ),
  Subject(
    name: 'Database Systems',
    instructor: 'Mrs. Garcia',
    schedule: 'Tue/Thu 1:00 - 2:30 PM',
  ),
  Subject(
    name: 'Operating Systems',
    instructor: 'Dr. Lee',
    schedule: 'Fri 8:00 - 11:00 AM',
  ),
];