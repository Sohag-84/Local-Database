// ignore_for_file: prefer_const_constructors, unnecessary_brace_in_string_interps

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hive database"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var box = await Hive.openBox("sohag");
          box.put("name", "Injamul Haq Sohag");
          box.put("age", 24);
          box.put("details", {
            'name': 'Abdullah Al Raiyan',
            'age': '4',
            'address': 'Kishoreganj',
          });

          var address = box.get('details')['address'];
          var name = box.get("name");
          var age = box.get("age");

          log(name);
          log("Age: ${age}");
          log("Address: ${address}");
        },
        child: Icon(Icons.add),
      ),
      
    );
  }
}
