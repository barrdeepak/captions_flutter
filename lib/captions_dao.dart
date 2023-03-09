import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class CaptionData {
  Map getDummyData() {
    var map = new Map();
    map["sun"] = [];
    List list = map["sun"];
    list.add("sunset is best");
    list.add("Good morning sunshine");
    list.add("Thousand suns");
    // map["sunset"] = "Sunsets are best";
    // map["coffee"] = "I am yet to wake up. Coffee please.";
    return map;
  }

  Future<Map<String, List<String>>> getDataFromFile() async {
    var map = new Map<String, List<String>>();

    // print(await http.read('https://example.com/foobar.txt'));
    try {
      // String text = await rootBundle.loadString('assets/captions.psv');
      // var contents = file.readAsLinesSync();
      String contents = await http.read(Uri.parse(
          'https://raw.githubusercontent.com/barrdeepak/captions_flutter/master/assets/captions.psv'));
      // var response = "";
      map["sun"] = <String>[];
      List<String>? list = map["sun"];
      list?.add("sunset is best22222 : ${contents.length}");
      list?.add(contents);
      print(contents);
    } catch (e) {
      stderr.writeln('failed to read file: \n${e}');
    }
    return map;
  }

  Future<Map<String, List<String>>> loadDataFromURL() async {
    var map = new Map<String, List<String>>();
    try {
      String contents = await http.read(Uri.parse(
          'https://raw.githubusercontent.com/barrdeepak/captions_flutter/master/assets/captions.psv'));
      LineSplitter.split(contents).forEach((line) {
        List<String> parts = line.split("|");
        if (map[parts[0]] == null) {
          map[parts[0]] = <String>[];
        }
        List<String> captionList = map[parts[0]]!;
        captionList.add(parts[1]);
      });
      map.forEach((key, value) {
        print("key-");
        print(key);
        print("values-");
        value.forEach((element) {print(element);});
      });
    } catch (e) {
      stderr.writeln('failed to read file: \n${e}');
    }
    return map;
  }

  String returnResponse(String s) {
    return s;
  }
}
