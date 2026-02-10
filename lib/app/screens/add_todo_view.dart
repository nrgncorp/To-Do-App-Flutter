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
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool get isFormValid {
    return titleController.text.trim().isNotEmpty &&
        descriptionController.text.trim().isNotEmpty &&
        selectedStatus != null &&
        selectedImportance != null &&
        selectedStartDate != null &&
        selectedEndDate != null;
  }

  @override
  Widget build(BuildContext context) {
    final todoStore = context.watch<TodoStore>();
    final itemStatus = todoStore.itemStatus;
    final itemImportance = todoStore.itemImportance;
    if (itemStatus.isNotEmpty && selectedStatus == null) {
      selectedStatus = itemStatus.first;
    }

    if (itemImportance.isNotEmpty && selectedImportance == null) {
      selectedImportance = itemImportance.first;
    }

    var inputBgColor = const Color.fromARGB(40, 255, 255, 255);
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        TextFormField(
                          controller: titleController,
                          decoration: InputDecoration(
                            labelText: 'Başlık',
                            fillColor: inputBgColor,
                            filled: true,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Başlık boş bırakılamaz';
                            }
                            return null;
                          },
                        ),
                        Spacer(),
                        TextFormField(
                          controller: descriptionController,
                          decoration: InputDecoration(
                            labelText: 'Açıklama',
                            fillColor: const Color.fromARGB(40, 255, 255, 255),
                            filled: true,
                          ),
                          minLines: 5,
                          maxLines: 5,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Açıklama boş bırakılamaz';
                            }
                            return null;
                          },
                        ),
                        Spacer(),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<Status>(
                                value: selectedStatus,
                                decoration: const InputDecoration(
                                  labelText: 'Durum',
                                  filled: true,
                                ),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Durum seçmelisin';
                                  }
                                  return null;
                                },
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
                                validator: (value) {
                                  if (value == null) {
                                    return 'Durum seçmelisin';
                                  }
                                  return null;
                                },
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
                        Spacer(),
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
                                    initialDate:
                                        selectedEndDate ?? DateTime.now(),
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
                        Spacer(),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 20,
                        left: 10,
                        right: 10,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                              ),
                              onPressed: isFormValid
                                  ? () {
                                      if (_formKey.currentState!.validate()) {
                                        context.read<TodoStore>().addJob(
                                          titleController.text.trim(),
                                          descriptionController.text.trim(),
                                          selectedStatus!.id,
                                          selectedImportance!.id,
                                          selectedStartDate!,
                                          selectedEndDate!,
                                        );

                                        Navigator.pop(context, true);
                                      }
                                    }
                                  : null,
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

class Spacer extends StatelessWidget {
  const Spacer({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 10);
  }
}
