import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

import 'package:ads_atividade_2/task/task_api.dart';
import 'package:ads_atividade_2/owner/owner_api.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _titleControlle = TextEditingController();
  final TextEditingController _descriptioControlle = TextEditingController();
  String deadline = '';
  int taskOwner = -1;
  String taskStatus = '';

  @override
  Widget build(BuildContext context) {
    final taskCurrentProvider = Provider.of<TaskProvider>(context);
    final ownerCurrentProvider = Provider.of<OwnerProvider>(context);

    return Scaffold(
        appBar: AppBar(title: const Text("Add Task")),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(children: [
                TextField(
                    controller: _titleControlle,
                    decoration: const InputDecoration(labelText: 'Title')),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                    controller: _descriptioControlle,
                    decoration:
                        const InputDecoration(labelText: 'Description')),
                const SizedBox(
                  height: 20,
                ),
                Row(children: [
                  DropdownButton(
                    value: taskOwner == -1 ? null : taskOwner,
                    hint: const Text("Select Owner"),
                    items: ownerCurrentProvider.owners.map((owner) {
                      return DropdownMenuItem(
                          value: owner.id, child: Text(owner.name));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        // Value arrives as an Object
                        taskOwner = int.parse(value.toString());
                      });
                    },
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  DropdownButton(
                    value: taskStatus == '' ? null : taskStatus,
                    hint: const Text("Select Task Status"),
                    items: const [
                      DropdownMenuItem(
                        value: 'true',
                        child: Text("Finished"),
                      ),
                      DropdownMenuItem(
                        value: 'false',
                        child: Text("Pending"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        taskStatus = value!;
                      });
                    },
                  ),
                ]),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const Text("Deadline: "),
                    TextButton(
                      onPressed: () {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime: DateTime.now(), onConfirm: (date) {
                          setState(() {
                            deadline = DateFormat('dd/MM/yyyy').format(date);
                          });
                        });
                      },
                      child: Text(deadline == '' ? 'Select a Date' : deadline),
                    )
                  ],
                ),
                ElevatedButton(
                    onPressed: () {
                      final task = Task.withoutId(
                          idOwner: taskOwner,
                          title: _titleControlle.text,
                          description: _descriptioControlle.text,
                          deadline: deadline,
                          isComplete: taskStatus);

                      taskCurrentProvider.addTask(task).then((_) {
                        Navigator.pop(context);
                        taskCurrentProvider.fetchAllTasks();
                      }).catchError((error) {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text("Failed to add task!"),
                                  content: Text('$error'),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Ok'))
                                  ],
                                ));
                      });
                    },
                    child: const Text("Add Task"))
              ])),
        ));
  }
}
