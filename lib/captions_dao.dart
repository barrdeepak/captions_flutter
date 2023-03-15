import 'package:captions/constants.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CaptionDAO {
  final String dataUrl =
      "https://raw.githubusercontent.com/barrdeepak/captions_flutter/master/data/captions.psv";

  Future<Map<String, Set<String>>> loadData() async {
    var map = new Map<String, Set<String>>();
    try {
      String contents = await http.read(Uri.parse(dataUrl));
      LineSplitter.split(contents).forEach((line) {
        List<String> parts = line.split("|");
        List<String> keywords = parts[0].split(",");
        keywords.forEach((keyword) {
          keyword = keyword.trim();
        if (map[keyword] == null) {
          map[keyword] = <String>{};
        }
        Set<String> captionList = map[keyword]!;
        captionList.add(parts[1].trim());
        });
      });
      print("Loaded ${map.length} keywords and data");
      map.forEach((key, value) {
        print(key);
      });
    } catch (e) {
      stderr.writeln('Failed to initialize data: \n${e}');
    }

    return map;
  }

  Set<String> search(Map<String, Set<String>> map, String input) {
     List<String> keywords = input.toLowerCase().split(RegExp('(\\s)|(,)|(;)|(\\.)'));
     Set<String> captions = <String>{};
     keywords.forEach((keyword) {
       captions.addAll(searchForKeyword(map, keyword));
     });

     if(captions.isEmpty) {
       captions.add(Constants.NO_CAPTIONS);
     }
       List<String> list = captions.toList();
       list.shuffle();
       return list.take(Constants.MAX_RESULTS).toSet();
  }

  Set<String> searchForKeyword(Map<String, Set<String>> map, String keyword) {
    Set<String> result = <String>{};
    print("Keyword is $keyword");
    if (map.containsKey(keyword)) {
      result.addAll(map[keyword]!);
    }
    print("result size is ${result.length} for keyword $keyword");
    return result;
  }

}
