import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:ads_atividade_2/owner/owner_api.dart';


class ListOwnersPage extends StatefulWidget {
  const ListOwnersPage({super.key});

  @override
  State<ListOwnersPage> createState() => _ListOwnersPageState();
}

class _ListOwnersPageState extends State<ListOwnersPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<OwnerProvider>(context, listen: false).fetchOwner();
  }

  @override
  Widget build(BuildContext context) {
    final ownerProvider = Provider.of<OwnerProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text("TaskPad")
        ),
        body: ownerProvider.owners.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: ownerProvider.owners.length,
                itemBuilder: (context, index) {
                  final owner = ownerProvider.owners[index];

                  return ListTile(
                    title: Text(owner.name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        "BirthDate: ${DateFormat('yyyy-MM-dd').format(owner.birthDate)}",
                        style: const TextStyle(fontSize: 16)),
                  );
                },
              ));
  }
}
