import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class savedLogsWidget extends StatefulWidget{
  @override
  savedLogsWidgetState createState() => savedLogsWidgetState();
}

class savedLogsWidgetState extends State <savedLogsWidget> {
  //Get the file
  String textFromFile;
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    final name= '2.txt';
    return File('$path/$name');
  }

  Future<void> printSavedLogs() async {
    try {
      final file = await _localFile;

      // Read the file.
      String cont = await file.readAsString();

      textFromFile=cont;
    } catch (e) {
      // If encountering an error, return 0.
      textFromFile= e.toString();
    }
    setState(() {
    });
  }

  Future<File> deleteFile() async {
    final file = await _localFile;
    return file.writeAsString('');
  }

  @override
  Widget build(BuildContext context){
    printSavedLogs();
    return Expanded(
        flex: 1,
      child: Stack(
        children: [
          new SingleChildScrollView(
            scrollDirection: Axis.vertical,//.horizontal
            child: new Text('$textFromFile',
              style: new TextStyle(
                fontSize: 16.0, color: Colors.black,
              ),
            ),
          ),
          Positioned(
            bottom: 10,
              right: 0,
              child:ElevatedButton(
                  onPressed: () => deleteFile(),
                  child: Text("Delete logs")
              )
          )
        ],
      )
      );
  }
}

