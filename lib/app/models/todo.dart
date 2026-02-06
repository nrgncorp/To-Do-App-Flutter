class Todo {
  final int id;
  final String title;
  final String subTitle;
  final int status;
  final int importance;
  final DateTime startDate;
  final DateTime endDate;

  Todo({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.status,
    required this.importance,
    required this.startDate,
    required this.endDate,
  });
}

class Status {
  final int id;
  final String label;
  Status({required this.id, required this.label});
}

class Importance {
  final int id;
  final String label;
  Importance({required this.id, required this.label});
}
