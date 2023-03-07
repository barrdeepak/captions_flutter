import 'package:captions/data.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  _State createState() {
    return _State();
  }
}

class _State extends State<MyApp> {

  Map data = CaptionData().getData();
  String _value ="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Captions Finder'),
      ),
      body: Container(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children:  <Widget>[
            const TextField(
              autocorrect: true,
              autofocus: false,
              decoration: InputDecoration(
                labelText:'Search captions',
                labelStyle: TextStyle(
                  fontSize: 20,
                  fontFamily: 'SFPro',
                ),
                border: UnderlineInputBorder(),
                hintText: 'Enter some keywords',
              ),
            ),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  _value = data["sun"];
                });
              },
              child: const Text('Submit'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _value = "coffee";
                });
              },
              child: const Text('Clear'),
            ),
            Text(
              _value
            )
          ],
        ),
      ),
    );
  }
}