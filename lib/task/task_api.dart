import "dart:convert";

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ads_atividade_2/const.dart';

class Task {
  int id;
  final int idOwner;
  final String title;
  final String? description;
  final String deadline;
  final String isComplete;
  final DateTime createdAt;
  final DateTime updatedAt;

  Task({
    required this.id,
    required this.idOwner,
    required this.title,
    required this.description,
    required this.deadline,
    required this.isComplete,
    required this.createdAt,
    required this.updatedAt,
  });

  Task.withoutId(
      {required this.idOwner,
      required this.title,
      required this.deadline,
      required this.isComplete,
      this.description = ''})
      : id = -1,
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'],
        idOwner: json['responsavelId'],
        title: json['titulo'],
        description: json['descricao'],
        isComplete: json['isComplete'].toString(),
        deadline: json['dataLimite'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'responsavelId': idOwner,
        'titulo': title,
        'descricao': description,
        'isComplete': isComplete,
        'dataLimite': deadline,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String()
      };

  Map<String, dynamic> toJsonToAdd() => {
        'responsavelId': idOwner,
        'titulo': title,
        'descricao': description,
        'isComplete': isComplete,
        'dataLimite': deadline,
      };
}

class TaskProvider extends ChangeNotifier {
  List<Task> tasks = [];

  Future<void> fetchAllTasks() async {
    const url = 'http://$localhost:3000/task/list';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> ownerData = data['tarefas'];

      tasks = ownerData.map((item) => Task.fromJson(item)).toList();
      notifyListeners();
    } else {
      final errorBody = json.decode(response.body);
      final errorMessage = errorBody['message'];
      throw Exception('Failed to load tasks! \n Error: $errorMessage');
    }
  }

  Future<void> fetchOwnerTasks(int ownerId) async {
    final url = 'http://$localhost:3000/task/list?from=$ownerId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> taskData = data['tarefas'];

      tasks = taskData.map((task) => Task.fromJson(task)).toList();
      notifyListeners();
    } else {
      final errorBody = json.decode(response.body);
      final errorMessage = errorBody['message'];
      throw Exception('Failed to load tasks! \n Error: $errorMessage');
    }
  }

  Future<void> fetchCompletedTask() async {
    const url = 'http://$localhost:3000/task/list?isComplete=true';
    final response = await http.get(Uri.parse(url));

    if(response.statusCode==200){
      final data = json.decode(response.body);
      final List<dynamic> ownerData = data['tarefas'];

      tasks = ownerData.map((item) => Task.fromJson(item)).toList();
      notifyListeners();
    } else {
      final errorBody = json.decode(response.body);
      final errorMessage = errorBody['message'];
      throw Exception('Failed to load tasks! \n Error: $errorMessage');
    }
  }

  Future<void> fetchPendingTask() async {
    const url = 'http://$localhost:3000/task/list?isComplete=false';
    final response = await http.get(Uri.parse(url));

    if(response.statusCode==200){
      final data = json.decode(response.body);
      final List<dynamic> ownerData = data['tarefas'];

      tasks = ownerData.map((item) => Task.fromJson(item)).toList();
      notifyListeners();
    } else {
      final errorBody = json.decode(response.body);
      final errorMessage = errorBody['message'];
      throw Exception('Failed to load tasks! \n Error: $errorMessage');
    }
  }

  Future<void> addTask(Task newTask) async {
    const url = 'http://$localhost:3000/task/add';
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(newTask.toJsonToAdd()),
    );

    if (response.statusCode == 201) {
      tasks.add(newTask);
      notifyListeners();
    } else {
      final errorBody = json.decode(response.body);
      final errorMessage = errorBody['message'];
      throw Exception('Failed to add task! \n Error: $errorMessage');
    }
  }

  Future<void> removeTask(int taskId) async {
    final url = 'http://$localhost:3000/task/remove/$taskId';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      tasks.removeWhere((task) => task.id == taskId);
      notifyListeners();
    } else {
      final errorBody = json.decode(response.body);
      final errorMessage = errorBody['message'];
      throw Exception('Failed to remove task!  \n Error: $errorMessage');
    }
  }

  Future<void> updateTask(int taskId, Task newTaskDatas) async {
    final url = 'http://$localhost:3000/task/update/$taskId';
    final response = await http.put(Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(newTaskDatas.toJson()));

    if (response.statusCode == 200) {
      final taskIndex = tasks.indexWhere((task) => task.id == taskId);
      tasks[taskIndex] = newTaskDatas;
      notifyListeners();
    } else {
      final errorBody = json.decode(response.body);
      final errorMessage = errorBody['message'];
      throw Exception('Failed to update task! \n Error: $errorMessage');
    }
  }

  Future<void> completeTask(int taskId) async {
    final url = 'http://$localhost:3000/task/update/$taskId';

    Map<String, String> newStatus = {'isComplete': 'true'};

    final response = await http.put(Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(newStatus));

    if (response.statusCode == 200) {
      fetchAllTasks();
    } else {
      final errorBody = json.decode(response.body);
      final errorMessage = errorBody['message'];
      throw Exception('Failed to update task! \n Error: $errorMessage');
    }
  }
}
