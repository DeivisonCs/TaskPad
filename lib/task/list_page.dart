import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:ads_atividade_2/task/task_api.dart';
import 'package:ads_atividade_2/task/add_page.dart';

class ListTasksPage extends StatefulWidget {
  const ListTasksPage({super.key});

  @override
  State<ListTasksPage> createState() => _ListTasksPageState();
}

class _ListTasksPageState extends State<ListTasksPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<TaskProvider>(context, listen: false).fetchTask();
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
        appBar: AppBar(title: const Text("TaskPad")),
        body: taskProvider.tasks.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: taskProvider.tasks.length,
              itemBuilder: (context, index) {
                final task = taskProvider.tasks[index];

                return ListTile(
                    title: Text(task.title,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Text(
                              "Deadline: ${DateFormat('yyyy-MM-dd').format(task.deadline)}",
                              style: const TextStyle(fontSize: 16))
                        ])
                      ],
                    ),
                    
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            icon: const Icon(Icons.edit),
                            // onPressed: () => navigateToEdit(task.id) 
                            onPressed: () {} 
                          ),
                        IconButton(
                            icon: const Icon(Icons.delete), 
                            onPressed: () => taskProvider.removeTask(task.id)
                          )
                      ],
                    )
                  );
              },
            ),

        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => navigateToAdd()
        ),
      );
  }

  // void navigateToEdit(int taskId) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => const EditTaskPage())
  //   );
  // }

  void navigateToAdd() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTaskPage())
    );
  }
}
