
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FileUtils
{

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/mytext.txt');
  }
  
Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
Future<File> writeTextFile(String myText) async {
  final file = await _localFile;
  return file.writeAsString('$myText');
}

Future<String> readTextFile() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      return "No Data";
    }
  }
  
Future<List<List<dynamic>>> processCsv(BuildContext context) async {
    var result = null;
    
    try
    {
    result = await DefaultAssetBundle.of(context).loadString(
       "${(kDebugMode && kIsWeb)?"":"assets/"}data/test.csv",
    );
    // ignore: empty_catches
    }  catch (ex)
    {
      try
      {
        result = await DefaultAssetBundle.of(context).loadString(
       "data/test.csv");
      }
       catch (ex)
       {
            return [];
       }
    } 
    return const CsvToListConverter().convert(result, eol: "\n");
}
}