import 'package:flutter/material.dart';
import 'package:hardware_andro_kurs/app/models/todo.dart';
import 'package:hardware_andro_kurs/app/stores/todo_store.dart';
import 'package:provider/provider.dart';

class AddTodoView extends StatefulWidget {
  const AddTodoView({super.key});

  @override
  State<AddTodoView> createState() => _AddTodoViewState();
}

class _AddTodoViewState extends State<AddTodoView> {
  Status? selectedStatus;
  Importance? selectedImportance;
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  @override
  Widget build(BuildContext context) {
    final todoStore = context.watch<TodoStore>();
    final itemStatus = todoStore.itemStatus;
    final itemImportance = todoStore.itemImportance;

    return Scaffold(
      appBar: AppBar(title: Text('Yeni Görev')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Başlık',
                        fillColor: const Color.fromARGB(40, 255, 255, 255),
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Açıklama',
                        fillColor: const Color.fromARGB(40, 255, 255, 255),
                        filled: true,
                      ),
                      minLines: 5,
                      maxLines: 5,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<Status>(
                            value: selectedStatus,
                            decoration: const InputDecoration(
                              labelText: 'Durum',
                              filled: true,
                            ),
                            items: itemStatus.map((status) {
                              return DropdownMenuItem<Status>(
                                value: status,
                                child: Text(status.label),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedStatus = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: DropdownButtonFormField<Importance>(
                            value: selectedImportance,
                            decoration: const InputDecoration(
                              labelText: 'Önem',
                              filled: true,
                            ),
                            items: itemImportance.map((imp) {
                              return DropdownMenuItem<Importance>(
                                value: imp,
                                child: Text(imp.label),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedImportance = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: 'Tarih',
                              filled: true,
                            ),
                            controller: TextEditingController(
                              text: selectedStartDate == null
                                  ? ''
                                  : '${selectedStartDate!.day}.${selectedStartDate!.month}.${selectedStartDate!.year}',
                            ),
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate:
                                    selectedStartDate ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );

                              if (picked != null) {
                                setState(() {
                                  selectedStartDate = picked;
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: 'Tarih',
                              filled: true,
                            ),
                            controller: TextEditingController(
                              text: selectedEndDate == null
                                  ? ''
                                  : '${selectedEndDate!.day}.${selectedEndDate!.month}.${selectedEndDate!.year}',
                            ),
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: selectedEndDate ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );

                              if (picked != null) {
                                setState(() {
                                  selectedEndDate = picked;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            onPressed: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'Oluştur',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
