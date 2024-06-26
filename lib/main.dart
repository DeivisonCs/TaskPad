import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ads_atividade_2/owner/owner_api.dart';
import 'package:ads_atividade_2/owner/list_page.dart';
import 'package:ads_atividade_2/task/task_api.dart';
import 'package:ads_atividade_2/task/list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<OwnerProvider>(create: (_)=> OwnerProvider()),
        ChangeNotifierProvider<TaskProvider>(create: (_)=> TaskProvider())
      ],
      child: MaterialApp(
          title: 'TaskPad',
          theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
              useMaterial3: true),
          home: const MyHomePage()));
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("TaskPad")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton.icon(
                icon: const Icon(Icons.account_circle_outlined, size: 45),
                label: const Text('Owners', style: TextStyle(fontSize: 30)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Consumer<OwnerProvider>(
                                  builder: (context, ownerProvider, child) {
                                return const ListOwnersPage();
                              })));
                },
              ),
              const SizedBox(height: 25),
              ElevatedButton.icon(
                  icon: const Icon(Icons.assignment_turned_in_outlined, size: 45),
                  label: const Text("Tasks", style: TextStyle(fontSize: 30)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Consumer<TaskProvider>(
                                  builder: (context, taskProvider, child) {
                                    return const ListTasksPage(ownerId: -1);
                                  },
                                )));
                  },
                ),
            ],
          ),
        ));
  }
}