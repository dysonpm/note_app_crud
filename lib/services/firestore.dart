import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  //get colletion of notes
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('notes');
  //Create add new note
  Future<void> addNote(String note) {
    return notes.add({
      'note': note,
      'timestamp': Timestamp.now(),
    });
  }

  //Read get notes from database
  Stream<QuerySnapshot> getNotesStream() {
    final notesStream =
        notes.orderBy("timestamp", descending: true).snapshots();

    return notesStream;
  }

  //Update update notes given a doc id
  Future<void> updateNotes(String docID, String newNote) {
    return notes.doc(docID).update({
      'note': newNote,
      'timestamp': Timestamp.now(),
    });
  }

  //Delete delte notes given a doc id
  Future<void> deletNote(String docID) {
    return notes.doc(docID).delete();
  }
}
