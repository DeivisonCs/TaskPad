import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

import 'package:ads_atividade_2/owner/owner_api.dart';

class AddOwnerPage extends StatefulWidget {
  const AddOwnerPage({super.key});

  @override
  State<AddOwnerPage> createState() => _AddOwnerPageState();
}

class _AddOwnerPageState extends State<AddOwnerPage> {
  final TextEditingController _nameControlle = TextEditingController();
  // DateTime birthDate = DateTime.now();
  String birthDate = '';

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
                          minTime: DateTime.utc(2015, 1, 1),
                          maxTime: DateTime.now(), onConfirm: (date) {
                            setState(() {
                              birthDate = DateFormat('dd/MM/yyyy').format(date);
                            });
                          });
                      },
                      child: Text(birthDate==''?'Select a Date':birthDate),
                    )
                  ],
                ),
                ElevatedButton(
                    onPressed: () {
                      final owner = Owner.withoutId(
                          name: _nameControlle.text, birthDate: birthDate);

                      ownerCurrentProvider.addOwner(owner).then((_) {
                        Navigator.pop(context);
                        ownerCurrentProvider.fetchAllOwners();
                      }).catchError((error) {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text("Failed to add owner!"),
                                  content: Text('$error'),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Ok'))
                                  ],
                                ));
                      });
                    },
                    child: const Text("Add Owner"))
              ])),
        ));
  }
}
