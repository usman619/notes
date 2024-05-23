import 'package:flutter/material.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({super.key});

  @override
  State<NewNoteView> createState() => _NewNotesViewState();
}

class _NewNotesViewState extends State<NewNoteView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Notes', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple,
      ),
      body: const Center(
        child: Text('Create a new note here...'),
      ),
    );
  }
}
