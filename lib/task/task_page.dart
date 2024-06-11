import 'package:ads_atividade_2/components/colored_circle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ads_atividade_2/owner/owner_api.dart';
import 'package:ads_atividade_2/task/task_api.dart';

class TaskPage extends StatefulWidget {
  final int taskId;

  const TaskPage({super.key, required this.taskId});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  void initState() {
    super.initState();

    Provider.of<TaskProvider>(context, listen: false).fetchAllTasks();
    Provider.of<OwnerProvider>(context, listen: false).fetchAllOwners();
  }

  @override
  Widget build(BuildContext context) {
    final taskprovider = Provider.of<TaskProvider>(context);
    final ownerProvider = Provider.of<OwnerProvider>(context);
    final Task currentTask = taskprovider.tasks.firstWhere((task) => task.id == widget.taskId);
    final Owner taskOwner = ownerProvider.owners.firstWhere((owner) => owner.id == currentTask.idOwner);

    return Scaffold(
      appBar: AppBar(title: const Text("TaskPad")),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20), 
            Text(currentTask.title, style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold 
            )),
            Text("Owner: ${taskOwner.name}", style: const TextStyle(
              fontSize: 15
            )),
            const SizedBox(height: 80),

            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 10),
                Text("Description: ", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 40),
                Text(currentTask.description.toString()),
                const SizedBox(height: 80), 
              ]
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 20),
                const Text('Status: ', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 13),
                ColoredCircle(color: currentTask.isComplete=='true'?Colors.green:Colors.red),
                const SizedBox(width: 7),
                Text(currentTask.isComplete=='true'?"Completed":"Pending"),
            ]),

            const SizedBox(height: 80), 
                currentTask.isComplete=="false"?
                ElevatedButton(
                  onPressed: () => {
                    taskprovider.completeTask(currentTask.id)
                      .then((_) => {
                          showDialog(
                            context: context, 
                            builder: (context) => AlertDialog(
                              title: const Text("Task Completed!"),
                              content: Text("Task '${currentTask.title}' succesfully completed!"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Ok"),
                                )
                              ],
                            )
                            )
                      }).catchError((error) => {
                        showDialog(
                            context: context, 
                            builder: (context) => AlertDialog(
                              title: const Text("Failed to Completed Task!"),
                              content: Text(error),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Ok"),
                                )
                              ],
                            )
                            )
                      })
                  },child: const Text("Complete Task")
                  ):const Row()
          ],
        ),
      )
    );
  }
}
