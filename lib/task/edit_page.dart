import 'package:ads_atividade_2/owner/owner_api.dart';
import 'package:ads_atividade_2/task/task_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditTaskPage extends StatefulWidget {
  final int taskId;

  const EditTaskPage({super.key, required this.taskId});

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  @override
  void initState() {
    super.initState();

    Provider.of<TaskProvider>(context, listen: false).fetchAllTasks();
    Provider.of<OwnerProvider>(context, listen: false).fetchAllOwners();
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String taskDeadline = '';
  String taskStatus = '';
  int taskOwnerId = -1;

  @override
  Widget build(BuildContext context) {
    final currentTaskProvider = Provider.of<TaskProvider>(context);
    final Task taskToUpdate = currentTaskProvider.tasks
        .firstWhere((task) => task.id == widget.taskId);

    if (_titleController.text == '') {
      _titleController.text = taskToUpdate.title;
    }
    if (_descriptionController.text == '') {
      _descriptionController.text = taskToUpdate.description!;
    }
    if (taskStatus == '') taskStatus = taskToUpdate.isComplete;
    if (taskOwnerId == -1) taskOwnerId = taskToUpdate.idOwner;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Task')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(children: [
                DropdownButton(
                  value: taskStatus,
                  hint: const Text("Task Status"),
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
                  const Text('Deadline: '),
                  TextButton(
                      onPressed: () {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true, onConfirm: (date) {
                          setState(() {
                            taskDeadline =
                                DateFormat('yyyy-MM-dd').format(date);
                          });
                        });
                      },
                      child: Text(taskDeadline == ''
                          ? taskToUpdate.deadline
                          : taskDeadline))
                ],
              ),
              ElevatedButton(
                  onPressed: () {
                    DateTime parsedDeadline = DateTime.parse(
                        taskDeadline == '' ? taskToUpdate.deadline : taskDeadline);

                    final task = Task.withoutId(
                        idOwner: taskOwnerId,
                        title: _titleController.text,
                        description: _descriptionController.text,
                        deadline: DateFormat('dd/MM/yyyy').format(parsedDeadline),
                        isComplete: taskStatus);

                    currentTaskProvider
                        .updateTask(widget.taskId, task)
                        .then((_) {
                      Navigator.pop(context);
                      currentTaskProvider.fetchAllTasks();
                    }).catchError((error) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text("Failed to update task!"),
                                content: Text('$error'),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Ok'))
                                ],
                              ));
                    });
                  },
                  child: const Text("Update Task"))
            ],
          ),
        ),
      ),
    );
  }
}
