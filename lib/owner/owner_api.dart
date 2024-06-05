import "dart:convert";

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ads_atividade_2/const.dart';

class OwnertoAdd {
  final String name;
  final DateTime birthDate;

  OwnertoAdd({
    required this.name,
    required this.birthDate,
  });
}

class Owner{
  int id;
  final String name;
  final DateTime birthDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Owner({
    required this.id,
    required this.name,
    required this.birthDate,
    required this.createdAt,
    required this.updatedAt,
  });
  
  Owner.withoutId({
    required this.name,
    required this.birthDate,
  })
  : id=-1,
    createdAt=DateTime.now(),
    updatedAt=DateTime.now(); 

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
        id: json['id'],
        name: json['nome'],
        birthDate: DateTime.parse(json['dataNascimento']),
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': name,
        'dataNascimento': birthDate.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String()
      };

  Map<String, dynamic> toJsonToAdd() => {
        'nome': name,
        'dataNascimento': birthDate.toIso8601String(),
      };
}

class OwnerProvider extends ChangeNotifier {
  List<Owner> owners = [];

  Future<void> fetchOwner() async {
    const url = 'http://$localhost:3000/owner/list';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> ownerData = data['responsavel'];

      owners = ownerData.map((item) => Owner.fromJson(item)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load Owners!');
    }
  }

  Future<void> addOwner(Owner owner) async {
    const url = 'http://$localhost:3000/owner/add';
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(owner.toJsonToAdd()),
    );

    if (response.statusCode == 200) {
      owners.add(owner);
      notifyListeners();
    } else {
      throw Exception('Failed to add owner!');
    }
  }

  Future<void> removeOwner(int ownerId) async {
    final url = 'http://$localhost:3000/owner/remove/$ownerId';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      owners.removeWhere((owner) => owner.id == ownerId);
      notifyListeners();
    } else {
      throw Exception('Failed to remove owner!');
    }
  }

  Future<void> updateOwner(int ownerId, Owner newOwnerDatas) async {
    final url = 'http://$localhost:3000/owner/update/$ownerId';
    final response = await http.put(Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(newOwnerDatas.toJson()));

    if (response.statusCode == 200) {
      final ownerIndex = owners.indexWhere((owner) => owner.id == ownerId);
      owners[ownerIndex] = newOwnerDatas;
      notifyListeners();
    } else {
      throw Exception('Failed to update owner!');
    }
  }
}
