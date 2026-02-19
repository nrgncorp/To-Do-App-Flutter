import 'package:flutter/material.dart';
import 'package:hardware_andro_kurs/app/models/todo.dart';
import 'package:hardware_andro_kurs/app/stores/todo_store.dart';
import 'package:provider/provider.dart';

class AddTodoView extends StatefulWidget {
  const AddTodoView({super.key, this.isEdit = false, this.id = 0});
  final bool isEdit;
  final int id;

  @override
  State<AddTodoView> createState() => _AddTodoViewState();
}

class _AddTodoViewState extends State<AddTodoView> {
  bool? isLoaded = false;
  Status? selectedStatus;
  int? selectedStatusValue;
  Importance? selectedImportance;
  int? selectedImportanceValue;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
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
    if (widget.isEdit) {
      final todoItem = todoStore.getTodoById(widget.id);
      if (todoItem != null && isLoaded == false) {
        titleController.text = todoItem.title;
        descriptionController.text = todoItem.subTitle;

        selectedStatus = itemStatus.firstWhere((s) => s.id == todoItem.status);
        if (selectedStatus != null) {
          setState(() {
            selectedStatusValue = selectedStatus!.id;
          });
        }

        selectedImportance = itemImportance.firstWhere(
          (i) => i.id == todoItem.importance,
        );
        if (selectedImportance != null) {
          setState(() {
            selectedImportanceValue = selectedImportance!.id;
          });
        }

        selectedStartDate = todoItem.startDate;
        selectedEndDate = todoItem.endDate;
        isLoaded = true;
      }
    } else {
      if (itemStatus.isNotEmpty && selectedStatus == null) {
        selectedStatus = itemStatus.first;
      }
      if (itemImportance.isNotEmpty && selectedImportance == null) {
        selectedImportance = itemImportance.first;
      }
    }

    var inputBgColor = const Color.fromARGB(40, 255, 255, 255);
    const buttonTextStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontSize: 20,
    );
    return Scaffold(
      appBar: AppBar(
        title: widget.isEdit
            ? const Text('Görev Detay', style: buttonTextStyle)
            : const Text('Yeni Görev', style: buttonTextStyle),
      ),
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
                        TextFormFieldWidget(
                          valueController: titleController,
                          name: 'Başlık',
                        ),
                        Spacer(),
                        TextFormFieldWidget(
                          valueController: descriptionController,
                          lineCount: 5,
                          name: 'Açıklama',
                        ),
                        Spacer(),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormFieldMethod<Status>(
                                items: itemStatus,
                                name: 'Durum',
                                initialValue: selectedStatus,
                                labelBuilder: (e) => e.label,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: DropdownButtonFormFieldMethod<Importance>(
                                items: itemImportance,
                                name: 'Önem',
                                initialValue: selectedImportance,
                                labelBuilder: (e) => e.label,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Row(
                          children: [
                            Expanded(
                              child: datePickerMethod(
                                dateValue: selectedStartDate,
                                onDatePicked: (picked) {
                                  setState(() {
                                    selectedStartDate = picked;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: datePickerMethod(
                                dateValue: selectedEndDate,
                                onDatePicked: (picked) {
                                  setState(() {
                                    selectedEndDate = picked;
                                  });
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
                            child: todoDetailButton(
                              isFormValid: isFormValid,
                              widget: widget,
                              formKey: _formKey,
                              todoStore: todoStore,
                              titleController: titleController,
                              descriptionController: descriptionController,
                              selectedStatusValue: selectedStatusValue,
                              selectedImportanceValue: selectedImportanceValue,
                              selectedStartDate: selectedStartDate,
                              selectedEndDate: selectedEndDate,
                              buttonTextStyle: buttonTextStyle,
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

  TextFormField datePickerMethod({
    DateTime? dateValue,
    required Function(DateTime) onDatePicked,
  }) {
    return TextFormField(
      readOnly: true,
      decoration: const InputDecoration(labelText: 'Tarih', filled: true),
      controller: TextEditingController(
        text: dateValue == null
            ? ''
            : '${dateValue.day}.${dateValue.month}.${dateValue.year}',
      ),
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: dateValue ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );

        if (picked != null) {
          onDatePicked(picked);
        }
      },
    );
  }

  DropdownButtonFormField<T> DropdownButtonFormFieldMethod<T>({
    required List<T> items,
    required String Function(T) labelBuilder,
    required String name,
    required T? initialValue,
  }) {
    return DropdownButtonFormField<T>(
      initialValue: initialValue,
      decoration: InputDecoration(labelText: name, filled: true),
      validator: (initialValue) {
        if (initialValue == null) {
          return '$name seçmelisin';
        }
        return null;
      },
      items: items.map((value) {
        return DropdownMenuItem<T>(
          value: value,
          child: Text(labelBuilder(value)),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          if (items is List<Status>) {
            selectedStatus = value as Status;
            selectedStatusValue = selectedStatus!.id;
          } else if (items is List<Importance>) {
            selectedImportance = value as Importance;
            selectedImportanceValue = selectedImportance!.id;
          }
        });
      },
    );
  }
}

class todoDetailButton extends StatelessWidget {
  const todoDetailButton({
    super.key,
    required this.isFormValid,
    required this.widget,
    required GlobalKey<FormState> formKey,
    required this.todoStore,
    required this.titleController,
    required this.descriptionController,
    required this.selectedStatusValue,
    required this.selectedImportanceValue,
    required this.selectedStartDate,
    required this.selectedEndDate,
    required this.buttonTextStyle,
  }) : _formKey = formKey;

  final bool isFormValid;
  final AddTodoView widget;
  final GlobalKey<FormState> _formKey;
  final TodoStore todoStore;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final int? selectedStatusValue;
  final int? selectedImportanceValue;
  final DateTime? selectedStartDate;
  final DateTime? selectedEndDate;
  final TextStyle buttonTextStyle;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
      ),
      onPressed: isFormValid
          ? () {
              if (widget.isEdit) {
                if (_formKey.currentState!.validate()) {
                  // print(
                  //   selectedImportance!.label
                  //       .toString(),
                  // );

                  todoStore.updateById(
                    widget.id,
                    titleController.text.trim(),
                    descriptionController.text.trim(),
                    selectedStatusValue!,
                    selectedImportanceValue!,
                    selectedStartDate!,
                    selectedEndDate!,
                  );
                }
              } else {
                if (_formKey.currentState!.validate()) {
                  context.read<TodoStore>().addJob(
                    titleController.text.trim(),
                    descriptionController.text.trim(),
                    selectedStatusValue!,
                    selectedImportanceValue!,
                    selectedStartDate!,
                    selectedEndDate!,
                  );

                  Navigator.pop(context, true);
                }
              }
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: widget.isEdit
            ? Text('Düzenle', style: buttonTextStyle)
            : Text('Oluştur', style: buttonTextStyle),
      ),
    );
  }
}

class TextFormFieldWidget extends StatelessWidget {
  const TextFormFieldWidget({
    super.key,
    required this.valueController,
    this.lineCount = 1,
    required this.name,
  });

  final TextEditingController valueController;
  final int lineCount;
  final String name;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: valueController,
      decoration: InputDecoration(
        labelText: name,
        fillColor: const Color.fromARGB(40, 255, 255, 255),
        filled: true,
      ),
      minLines: lineCount,
      maxLines: lineCount,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$name boş bırakılamaz';
        }
        return null;
      },
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
