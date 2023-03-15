import 'package:captions/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class HomeWidgets {
  static List<Card> getContainersForCaptions(
      Set<String> captions, BuildContext context) {
    List<Card> containers = <Card>[];
    captions.forEach((caption) {
      try {
        if (caption != null) {
          if (caption == Constants.EMPTY_KEYWORDS ||
              caption == Constants.NO_CAPTIONS) {
            containers.add(Card(
                    color: Colors.red.shade100,
                    child: Padding(
                        padding: EdgeInsets.all(2),
                        child: Text(caption,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 15,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.bold))))
                // getCopyToClipboardButton(caption, context)
                );
          } else {
            containers.add(Card(
                color: Colors.cyan.shade50,
                margin: EdgeInsets.all(3.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Container(
                      //     width: 220,
                      Flexible(
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(6, 4, 0, 4),
                              child: Text(caption,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.bold)))),
                      SizedBox(width: 5),
                      getCopyToClipboardButton(caption, context)
                    ])));
          }
        }
      } catch (e) {
        stderr.writeln('failed to read file: \n${e}');
      }
    });
    return containers;
  }

  static Widget getCopyToClipboardButton(
      String captionOutput, BuildContext context) {
    if (captionOutput.isEmpty ||
        captionOutput == Constants.NO_CAPTIONS ||
        captionOutput == Constants.EMPTY_KEYWORDS) {
      return Container();
    }
    return IconButton(
      iconSize: 20,
      icon: const Icon(
        Icons.copy,
      ),
      onPressed: () {
        Clipboard.setData(ClipboardData(text: captionOutput));
        // setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Copied'),
        ));
      },
      // child: const Text('Copy'),
    );
  }
}
