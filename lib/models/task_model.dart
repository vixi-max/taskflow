
class Task {
  final String id;
  String title;
  String description;
  DateTime? dueDate;
  String category;
  String priority;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.dueDate,
    this.category = 'Personnel',
    this.priority = 'Moyenne',
    this.isCompleted = false,
  });
}
