import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

import 'package:ads_atividade_2/owner/owner_api.dart';

class UpdateOwnerPage extends StatefulWidget {
  final int ownerId;

  const UpdateOwnerPage({super.key, required this.ownerId});

  @override
  State<UpdateOwnerPage> createState() => _UpdateOwnerPageState();
}

class _UpdateOwnerPageState extends State<UpdateOwnerPage> {
  late final int ownerToUpdateId;

  @override
  void initState() {
    super.initState();
    Provider.of<OwnerProvider>(context, listen: false).fetchAllOwners();
    ownerToUpdateId = widget.ownerId;
  }

  String birthDate = '';
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ownerCurrentProvider = Provider.of<OwnerProvider>(context);
    final currentOwner = ownerCurrentProvider.owners
        .firstWhere((owner) => owner.id == ownerToUpdateId);

    if (_nameController.text == '') _nameController.text = currentOwner.name;

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Owner")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              TextField(
                  controller: _nameController,
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
                          birthDate = DateFormat('yyyy-MM-dd').format(date);
                        });
                      });
                    },
                    child: Text(
                        birthDate == '' ? currentOwner.birthDate : birthDate),
                  )
                ],
              ),
              ElevatedButton(
                  onPressed: () {
                    DateTime parsedBirthDate = DateTime.parse(
                        birthDate == '' ? currentOwner.birthDate : birthDate);
                    final newOwnerDatas = Owner.withoutId(
                        name: _nameController.text,
                        birthDate:
                            DateFormat('dd-MM-yyyy').format(parsedBirthDate));

                    ownerCurrentProvider
                        .updateOwner(currentOwner.id, newOwnerDatas)
                        .then((_) {
                      Navigator.pop(context);
                      ownerCurrentProvider.fetchAllOwners();
                    }).catchError((error) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text("Failed to edit owner!"),
                                content: Text('$error'),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Ok"))
                                ],
                              ));
                    });
                  },
                  child: const Text("Edit Owner"))
            ],
          ),
        ),
      ),
    );
  }
}
