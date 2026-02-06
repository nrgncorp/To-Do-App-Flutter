import 'package:flutter/material.dart';
import 'package:hardware_andro_kurs/app/list_view.dart';
import 'package:hardware_andro_kurs/app/stores/todo_store.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => TodoStore(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        appBarTheme: const AppBarTheme(backgroundColor: Colors.blue),
      ),
      home: ToDoListView(),
    );
  }
}
