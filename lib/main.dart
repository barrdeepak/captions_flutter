import 'package:captions/captions_dao.dart';
import 'package:captions/constants.dart';
import 'package:captions/home_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  ScrollController _scrollController = ScrollController();
  bool _showBackToTopButton =false;

  @override
  void initState() {
    // TODO: implement initState
    data = CaptionDAO().loadData();
    super.initState();
  }

  void _scrollToTop() {
    setState(() {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        curve: Curves.fastLinearToSlowEaseIn,
        duration: const Duration(milliseconds: 1000),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Captions Search'),
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(30,60,30,10),
          child: ListView(controller: _scrollController, children: <Widget>[
            TextFormField(
                textInputAction: TextInputAction.search,
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
                onChanged: (text) => setState(() => input = text),
              onFieldSubmitted: (text) => setState(()  => doSearch())
            ),

            ButtonBar(
                alignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        doSearch();
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
                        _showBackToTopButton =false;
                      });
                    },
                    child: const Text('Clear'),
                  )
                ]),
            captions.isNotEmpty? const Divider(height: 30, thickness: 2):Container(),
          SingleChildScrollView (
              // height: 550.0, //Your custom height
              // padding: const EdgeInsets.all(2),
              child: ListView(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                children:
                    HomeWidgets.getContainersForCaptions(captions, context),
              ),
            ),
            _showBackToTopButton?IconButton(
              // elevation: 8.0,
              onPressed: () {_scrollToTop();},
              color: Colors.blue,
              iconSize: 50,
              icon: const Icon(Icons.keyboard_double_arrow_up_rounded)
            )
            :Container()
          ]),
        ));
  }

  void doSearch() {
    FocusManager.instance.primaryFocus?.unfocus();
    captions.clear();

    if (input.isNotEmpty) {
      data.then((map) {
        captions.addAll(CaptionDAO().search(map, input));
        if(captions.length>5)
          _showBackToTopButton = true;
      });
    } else {
      captions.add(Constants.EMPTY_KEYWORDS);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose(); // dispose the controller
    super.dispose();
  }
}