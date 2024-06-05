import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:ads_atividade_2/owner/owner_api.dart';
import 'package:ads_atividade_2/owner/add_page.dart';

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
        appBar: AppBar(title: const Text("TaskPad")),
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
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Text(
                              "BirthDate: ${DateFormat('yyyy-MM-dd').format(owner.birthDate)}",
                              style: const TextStyle(fontSize: 16))
                        ])
                      ],
                    ),
                    
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            icon: const Icon(Icons.edit),
                            // onPressed: () => navigateToEdit(owner.id) 
                            onPressed: () {} 
                          ),
                        IconButton(
                            icon: const Icon(Icons.delete), 
                            onPressed: () => ownerProvider.removeOwner(owner.id)
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

  // void navigateToEdit(int ownerId) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => const EditOwnerPage())
  //   );
  // }

  void navigateToAdd() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddOwnerPage())
    );
  }
}
