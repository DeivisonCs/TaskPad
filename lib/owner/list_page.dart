import 'package:ads_atividade_2/owner/edit_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ads_atividade_2/task/list_page.dart';
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
    Provider.of<OwnerProvider>(context, listen: false).fetchAllOwners();
  }

  @override
  Widget build(BuildContext context) {
    final ownerProvider = Provider.of<OwnerProvider>(context);

    return Scaffold(
        appBar: AppBar(title: const Text("Owners")),
        body: ownerProvider.owners.isEmpty?
          Center(child: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () => navigateToAdd()
          ),)
        :ListView.builder(
              itemCount: ownerProvider.owners.length,
              itemBuilder: (context, index) {
                final owner = ownerProvider.owners[index];

                return ListTile(
                    title: InkWell(
                      onTap: () => navigateToOwnerTasks(owner.id),
                      child: Text(owner.name,
                          style: const TextStyle(
                          fontSize: 20, 
                          fontWeight: FontWeight.bold)
                        ) ,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Text(
                              "BirthDate: ${owner.birthDate}",
                              style: const TextStyle(fontSize: 16))
                        ])
                      ],
                    ),
                    
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => navigateToEdit(owner.id) 
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

  void navigateToEdit(int ownerId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UpdateOwnerPage(ownerId: ownerId))
    );
  }

  void navigateToAdd() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddOwnerPage())
    );
  }

  void navigateToOwnerTasks(int ownerId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ListTasksPage(ownerId: ownerId))
    );
  }
}
