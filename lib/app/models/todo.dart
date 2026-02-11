class Todo {
  int id;
  String title;
  String subTitle;
  int status;
  int importance;
  DateTime startDate;
  DateTime endDate;

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
