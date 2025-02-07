import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('notesBox');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quick Notes',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: NotesPage(),
    );
  }
}

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final _notesBox = Hive.box('notesBox');
  final TextEditingController _controller = TextEditingController();

  void _addNote() {
    if (_controller.text.isNotEmpty) {
      _notesBox.add(_controller.text);
      _controller.clear();
      setState(() {});
    }
  }

  void _deleteNote(int index) {
    _notesBox.deleteAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quick Notes')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Enter note'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addNote,
                )
              ],
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _notesBox.listenable(),
              builder: (context, box, _) {
                return ListView.builder(
                  itemCount: _notesBox.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_notesBox.getAt(index)),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteNote(index),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
