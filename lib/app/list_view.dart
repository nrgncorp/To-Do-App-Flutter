import 'package:flutter/material.dart';
import 'package:hardware_andro_kurs/app/screens/add_todo_view.dart';
import 'package:hardware_andro_kurs/app/stores/todo_store.dart';
// import 'package:hardware_andro_kurs/app/models/todo.dart';
import 'package:provider/provider.dart';

class ToDoListView extends StatefulWidget {
  const ToDoListView({super.key});

  @override
  State<ToDoListView> createState() => _ToDoListViewState();
}

class _ToDoListViewState extends State<ToDoListView> {
  @override
  Widget build(BuildContext context) {
    final todoStore = context.watch<TodoStore>();
    final items = todoStore.todos;
    final itemStatus = todoStore.itemStatus;
    final itemImportance = todoStore.itemImportance;

    return Scaffold(
      appBar: AppBar(title: Text('To-Do App')),
      body: Column(
        children: [
          Container(
            height: 50,
            color: const Color.fromARGB(131, 0, 0, 0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: itemStatus.length,
              itemBuilder: (BuildContext item, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll<Color>(
                        Colors.blue,
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      itemStatus[index].label,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (BuildContext item, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 10),
                  child: ListItem(
                    id: items[index].id,
                    title: items[index].title,
                    subTitle: items[index].subTitle,
                    status: items[index].status,
                    importanceId: items[index].importance,
                    importance:
                        itemImportance[items[index].importance - 1].label,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => const AddTodoView()));

          if (result == true) {
            setState(() {}); // sadece build tetiklemek için
          }
        },
        backgroundColor: Colors.blue,
        shape: CircleBorder(),
        child: Icon(Icons.add),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  const ListItem({
    super.key,
    required this.id,
    required this.title,
    required this.subTitle,
    required this.status,
    required this.importanceId,
    required this.importance,
  });

  final int id;
  final String title;
  final String subTitle;
  final int status;
  final int importanceId;
  final String importance;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      tileColor: const Color.fromARGB(255, 33, 70, 85),
      title: Text(title),
      subtitle: Text(subTitle),
      trailing: Text(importance),
      onTap: () {},
    );
  }
}
