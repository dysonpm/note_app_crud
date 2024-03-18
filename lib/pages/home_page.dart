import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:note_app_crud/services/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// firestore
final FirestoreService firestoreService = FirestoreService();

// Text controller
final TextEditingController textController = TextEditingController();

class _HomePageState extends State<HomePage> {
  // open a dialog vox to add a note
  void openNoteBox({String? docID}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        //text user input
        content: TextField(
          controller: textController,
        ),
        actions: [
          //button
          ElevatedButton(
            onPressed: () {
              // add a new note
              if (docID == null) {
                firestoreService.addNote(textController.text);
              }

              //update an existing note
              else {
                firestoreService.updateNotes(docID, textController.text);
              }

              // clear the text controller
              textController.clear();

              // close the box
              Navigator.pop(context);
            },
            child: Text("Add"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notes")),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNotesStream(),
        builder: (context, snapshot) {
          // if we have data, get all the docs
          if (snapshot.hasData) {
            List notesList = snapshot.data!.docs;

            // display as a list
            return ListView.builder(
              itemCount: notesList.length,
              itemBuilder: (context, index) {
                // get each individual doc
                DocumentSnapshot document = notesList[index];
                String docID = document.id;
                // get note from each doc
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String notesText = data['note'];
                // display as a list tile
                return ListTile(
                    title: Text(notesText),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // update
                        IconButton(
                          onPressed: () => openNoteBox(docID: docID),
                          icon: const Icon(Icons.settings),
                        ),

                        // delete
                        IconButton(
                          onPressed: () => firestoreService.deletNote(docID),
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ));
              },
            );
          }
          // if  there is  no Data returns
          else {
            return const Text("No notes...");
          }
        },
      ),
    );
  }
}
