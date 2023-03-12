import 'package:captions/captions_dao.dart';
import 'package:captions/constants.dart';
import 'package:captions/home_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

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
  late Future<Map<String, Set<String>>> data;
  String input = "";
  Set<String> captions = <String>{};
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = CaptionDAO().loadData();
  }

  @override
  Widget build(BuildContext context) {
    Future<Map<String, Set<String>>> data = CaptionDAO().loadData();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Captions Search'),
        ),
        body: Container(
          padding: const EdgeInsets.all(40.0),
          child: ListView(children: <Widget>[
            TextFormField(
                controller: textController,
                autocorrect: true,
                autofocus: false,
                decoration: const InputDecoration(
                  labelText: 'Search captions',
                  labelStyle: TextStyle(
                    fontSize: 14,
                    fontFamily: 'SFPro',
                  ),
                  border: UnderlineInputBorder(),
                  hintText: 'Enter keywords...',
                ),
                onChanged: (text) => setState(() => input = text)),
            ButtonBar(
                alignment: MainAxisAlignment.end,
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        FocusManager.instance.primaryFocus?.unfocus();
                        captions.clear();

                        if (input.isNotEmpty) {
                          data.then((map) {
                            captions.addAll(CaptionDAO().search(map, input));
                            // if (map.containsKey(input)) {
                            //   captions.addAll(map[input]!);
                            // } else {
                            //   captions.add(Constants.NO_CAPTIONS);
                            // }
                          });
                        } else {
                          captions.add(Constants.EMPTY_KEYWORDS);
                        }
                      });
                    },
                    child: const Text('Search'),
                  ),
                  SizedBox(width: 2),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        FocusManager.instance.primaryFocus?.unfocus();
                        input = "";
                        captions.clear();
                        textController.clear();
                      });
                    },
                    child: const Text('Clear'),
                  )
                ]),
            captions.isNotEmpty? const Divider(height: 50, thickness: 2):Container(),
          Container (
              height: 550.0, //Your custom height
              // padding: const EdgeInsets.all(2),
              child: ListView(
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                children:
                    HomeWidgets.getContainersForCaptions(captions, context),
              ),
            ),
          ]),
        ));
  }
}