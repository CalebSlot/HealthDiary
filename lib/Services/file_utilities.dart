
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../Models/healthrow.dart';
import 'constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
class FileUtils
{
  



   Future<String?> _readWebFile(String fileName) async
   {
   SharedPreferences sharedPreferences = await getSharedPreferencesInstance();
   String? fileContent = null;
        if(sharedPreferences.containsKey(fileName))
        {
           fileContent = 'DATE,WEIGHT,%H20,%FAT,%MUSCLES,BONES,BMI';
           fileContent='$fileContent\n${sharedPreferences.getString(fileName)}';

        }
    
    return fileContent;
   }

    Future<String?> _writeWebFile(String fileName,HealthRow row) async
   {
     SharedPreferences sharedPreferences = await getSharedPreferencesInstance();
     String? fileContent = null;

        if(sharedPreferences.containsKey(fileName))
        {
           String allCsv = sharedPreferences.getString(fileName);
           allCsv = '$allCsv\n${row.toCsv()}';
           sharedPreferences.setString(fileName,allCsv);
          
        }
        else
        {
           sharedPreferences.setString(fileName,row.toCsv());
        }
       
    return _readWebFile(fileName);
   }

  Future<File> _getLocalFile(String file) async {
    final path = await _localPath;
    return File('$path/$file');
  }
  
Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
Future<File> _writeTextFile(String fileName,String fileText,{FileMode fileMode = FileMode.append}) async {
  final file = await _getLocalFile(fileName);
  return file.writeAsString(fileText,mode : fileMode);
}

Future<String?> _readTextFile(String fileName) async {
    try 
    {
      final file = await _getLocalFile(fileName);
      String contents = await file.readAsString();
      return contents;
    } catch (e) 
    {
      return null;
    }
  }
  
Future<List<List<dynamic>>?> readHealthCsv() async 
{
    String? fileContent = null;
    if(!kIsWeb)
      {
     fileContent = await _readTextFile(csv_name);

   }
   else
   {
    fileContent = await _readWebFile(csv_name);
   }

    if(fileContent == null)
    {
      return null;
    }

    return const CsvToListConverter().convert(fileContent, eol: "\n");
}

Future<List<List<dynamic>>?> writeHealthCsv(HealthRow health) async
{


 String? fileContent = null;

   try 
    {
      if(!kIsWeb)
      {
       File file = await _writeTextFile(csv_name,health.toCsv());
       fileContent = await file.readAsString();
      }
      else
      {
           fileContent = await _writeWebFile(csv_name,health);
      }
    } catch (e) 
    {
      return null;
    }

return const CsvToListConverter().convert(fileContent, eol: "\n");

}
  static Future<SharedPreferences> getSharedPreferencesInstance() async
   {
    return await SharedPreferences.getInstance();
   }

  void initCsv()
  {
      if(!kIsWeb)
      {
        
      }
      else
      {
        getSharedPreferencesInstance().then((value) => value.clear());
      }
  }

}
  
