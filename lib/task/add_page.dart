import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

import 'package:ads_atividade_2/owner/owner_api.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _nameControlle = TextEditingController();
  DateTime birthDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final ownerCurrentProvider = Provider.of<OwnerProvider>(context);

    return Scaffold(
        appBar: AppBar(title: const Text("Add Owner")),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(children: [
                TextField(
                    controller: _nameControlle,
                    decoration: const InputDecoration(labelText: 'Name')),
                Row(
                  children: [
                    const Text("Birth Date: "),
                    TextButton(
                      onPressed: () {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime: DateTime.now(),
                            onConfirm: (date) => birthDate = date);
                      },
                      child: Text(birthDate.toString()),
                    )
                  ],
                ),
                ElevatedButton(
                    onPressed: () {
                      final owner = Owner.withoutId(
                          name: _nameControlle.text, birthDate: DateFormat('yyyy-MM-dd').format(birthDate));

                      ownerCurrentProvider.addOwner(owner)
                        .then((_) {
                          Navigator.pop(context);
                          ownerCurrentProvider.fetchOwner();
                        })
                        .catchError((onError) {

                        });
                    },
                    child: const Text("Add Owner"))
              ])),
        ));
  }
}
