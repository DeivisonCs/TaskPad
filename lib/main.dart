import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:ads_atividade_2/owner_api.dart';

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
          useMaterial3: true
        ),
        home: const MyHomePage(title: "TaskPad")
      )
    );
  }
}

// class Header extends StatelessWidget {
//     const Header({super.key})

//     @override
//       Widget build(BuildContext context) {
//         return Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//                 const Text(
//                     "TaskPad",
//                     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),

//                 IconButton(
//                     icon: const Icon(Icons.menu),
//                     onPressed: () {
//                         Navigator.pushNamed(context, routeName)  // Adicionar página menu
//                     }
//                 )
//             ],
//         );
//     }
// }

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<OwnerProvider>(context, listen: false).fetchOwner();
  }

  @override
  Widget build(BuildContext context) {
    final ownerProvider = Provider.of<OwnerProvider>(context);

    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
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
