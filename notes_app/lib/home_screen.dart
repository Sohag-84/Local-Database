// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_app/models/notes_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final titleController = TextEditingController();
  final descriptionCotroller = TextEditingController();

  addNotes() {
    Box<NotesModel> note = Hive.box<NotesModel>('notes');
    var data = NotesModel(
      title: titleController.text,
      description: descriptionCotroller.text,
    );
    note.add(data);
    data.save();
    titleController.clear();
    descriptionCotroller.clear();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes app"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _showDialog();
        },
        child: const Icon(Icons.add),
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Hive.box<NotesModel>('notes').listenable(),
        builder: (context, Box<NotesModel> box, child) {
          if (box.values.isEmpty) {
            return Center(
              child: Text("Notes are empty"),
            );
          }
          return ListView.builder(
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              var data = box.getAt(index);
              return Card(
                color: Colors.green.withOpacity(0.3),
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 15,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        data!.title.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        data.description.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showDialog() async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Notes"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: "Enter title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: descriptionCotroller,
                  decoration: InputDecoration(
                    hintText: "Enter description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cencel"),
            ),
            TextButton(
              onPressed: () {
                addNotes();
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
