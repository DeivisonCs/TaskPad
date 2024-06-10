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
      appBar: AppBar(title: Text(currentTask.title)),
      body: Column(
        children: [
          Text(taskOwner.name),
          Text(currentTask.description.toString()),
          Text(currentTask.isComplete),
        ],
      )

    );
  }
}
