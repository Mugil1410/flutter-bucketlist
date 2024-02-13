import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MaterialApp(
     debugShowCheckedModeBanner: false,
    home: BucketList(),
  ));
}

class BucketList extends StatefulWidget {
  @override
  _BucketListState createState() => _BucketListState();
}

class _BucketListState extends State<BucketList> {
  final List<Map<String, dynamic>> _listItems = <Map<String, dynamic>>[];
  final TextEditingController _textFieldController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bucket List'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bucket.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          itemCount: _listItems.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_listItems[index]['item']),
              subtitle: Text('Finish before: ${DateFormat('dd/MM/yyyy').format(_listItems[index]['date'])}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _displayDialog(context, index);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _listItems.removeAt(index);
                      });
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _displayDialog(context);
        },
        child: Icon(Icons.add),backgroundColor: Color.fromARGB(255, 55, 208, 255),
      ),
    );
  }

  _displayDialog(BuildContext context, [int? index]) {
    _textFieldController.clear();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add to Bucket List'),
          content: Column(
            children: <Widget>[
              TextFormField(
                controller: _textFieldController,
                decoration: InputDecoration(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                },
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Text('Select Date'),
              ),
              SizedBox(height: 8),
            ],
          ),
          actions: <Widget>[
            TextButton (
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton (
              child: Text('SAVE'),
              onPressed: () {
                setState(() {
                  if (index != null) {
                    _listItems[index] = {
                      'item': _textFieldController.text,
                      'date': _selectedDate,
                    };
                  } else {
                    _listItems.add({
                      'item': _textFieldController.text,
                      'date': _selectedDate,
                    });
                  }
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }
}
