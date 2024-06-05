import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ads_atividade_2/owner/owner_api.dart';
import 'package:ads_atividade_2/owner/list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OwnerProvider>(
        create: (_) => OwnerProvider(),
        child: MaterialApp(
            title: 'First App Flutter',
            theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: ElevatedButton(
                child: const Text('Owners'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Consumer<OwnerProvider>(
                                  builder: (context, ownerProvider, child) {
                                return const ListOwnersPage();
                              })));
                },
              )),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: ElevatedButton(
                  child: const Text("Tasks"),
                  onPressed: () {},
                ),
              )
            ],
          ),
        ));
  }
}
