import 'package:flutter/material.dart';
import 'package:hardware_andro_kurs/app/models/todo.dart';

class TodoStore extends ChangeNotifier {
  final List<Todo> _todos = [
    Todo(
      id: 1,
      title: 'Market Alışverişi',
      subTitle: 'Temizlik malzemesi alınacak',
      status: 1,
      importance: 1,
      startDate: DateTime(2024, 1, 15, 10, 0),
      endDate: DateTime(2024, 1, 15, 11, 0),
    ),
    Todo(
      id: 2,
      title: 'Fatura Ödemeleri',
      subTitle: 'Elektrik ve su faturalarını yatır',
      status: 1,
      importance: 2,
      startDate: DateTime(2024, 1, 16, 14, 0),
      endDate: DateTime(2024, 1, 16, 15, 0),
    ),
    Todo(
      id: 3,
      title: 'Doktor Randevusu',
      subTitle: 'Kontrol için hastaneye git',
      status: 1,
      importance: 3,
      startDate: DateTime(2024, 1, 17, 9, 30),
      endDate: DateTime(2024, 1, 17, 10, 30),
    ),
    Todo(
      id: 4,
      title: 'Kitap Okuma',
      subTitle: 'Günde 30 sayfa kitap oku',
      status: 1,
      importance: 1,
      startDate: DateTime(2024, 1, 15, 21, 0),
      endDate: DateTime(2024, 1, 15, 22, 0),
    ),
    Todo(
      id: 5,
      title: 'Spor Yap',
      subTitle: 'Akşam yürüyüşü veya egzersiz',
      status: 1,
      importance: 2,
      startDate: DateTime(2024, 1, 16, 19, 0),
      endDate: DateTime(2024, 1, 16, 20, 0),
    ),
    Todo(
      id: 6,
      title: 'Araba Bakımı',
      subTitle: 'Lastik kontrolü ve temizlik',
      status: 1,
      importance: 3,
      startDate: DateTime(2024, 1, 18, 11, 0),
      endDate: DateTime(2024, 1, 18, 13, 0),
    ),
    Todo(
      id: 7,
      title: 'Arkadaşlarla Buluşma',
      subTitle: 'Haftasonu için plan yap',
      status: 1,
      importance: 1,
      startDate: DateTime(2024, 1, 20, 18, 0),
      endDate: DateTime(2024, 1, 20, 22, 0),
    ),
    Todo(
      id: 8,
      title: 'Ev Temizliği',
      subTitle: 'Haftalık genel temizlik',
      status: 1,
      importance: 2,
      startDate: DateTime(2024, 1, 19, 10, 0),
      endDate: DateTime(2024, 1, 19, 12, 0),
    ),
    Todo(
      id: 9,
      title: 'İngilizce Çalışma',
      subTitle: 'Yeni kelimeler ve gramer',
      status: 1,
      importance: 1,
      startDate: DateTime(2024, 1, 15, 20, 0),
      endDate: DateTime(2024, 1, 15, 21, 0),
    ),
    Todo(
      id: 10,
      title: 'Proje Teslimi',
      subTitle: 'İş projesini tamamla ve gönder',
      status: 1,
      importance: 3,
      startDate: DateTime(2024, 1, 20, 9, 0),
      endDate: DateTime(2024, 1, 20, 17, 0),
    ),
  ];
  final List<Status> _itemStatus = [
    Status(id: 1, label: 'Bekliyor'),
    Status(id: 2, label: 'Devam Ediyor'),
    Status(id: 3, label: 'Tamamlandı'),
    Status(id: 4, label: 'İptal'),
  ];
  final List<Importance> _itemImportance = [
    Importance(id: 1, label: 'Düşük'),
    Importance(id: 2, label: 'Orta'),
    Importance(id: 3, label: 'Yüksek'),
  ];

  List<Todo> get todos => List.unmodifiable(_todos);
  List<Status> get itemStatus => List.unmodifiable(_itemStatus);
  List<Importance> get itemImportance => List.unmodifiable(_itemImportance);

  Todo? updateById(
    int id,
    String title,
    String subTitle,
    int status,
    int importance,
    DateTime startDate,
    DateTime endDate,
  ) {
    final index = _todos.indexWhere((item) => item.id == id);

    if (index == -1) return null;

    _todos[index].title = title;
    _todos[index].subTitle = subTitle;
    _todos[index].status = status;
    _todos[index].importance = importance;
    _todos[index].startDate = startDate;
    _todos[index].endDate = endDate;

    notifyListeners();
    return null;
  }

  Todo? getTodoById(int id) {
    try {
      return _todos.firstWhere((todo) => todo.id == id);
    } catch (e) {
      return null;
    }
  }

  void addJob(
    String title,
    String subTitle,
    int status,
    int importance,
    DateTime startDate,
    DateTime endDate,
  ) {
    final newTodo = Todo(
      id: _todos.length,
      title: title,
      subTitle: subTitle,
      status: status,
      importance: importance,
      startDate: startDate,
      endDate: endDate,
    );
    _todos.add(newTodo);
  }
}
