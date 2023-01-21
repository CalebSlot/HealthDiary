

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_01/Services/file_utilities.dart';



class HealthForm extends StatefulWidget 
{
  final FileUtils fileUtils;

  const HealthForm({super.key,required this.fileUtils});

  @override
  State<HealthForm> createState() => _HealthFormState();
}

class _HealthFormState extends State<HealthForm> {

  final weightController = TextEditingController();
  final h2oController    = TextEditingController();
  final fatController    = TextEditingController();
  final muscleController = TextEditingController();

 
List<List<dynamic>>? _csvData;
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    weightController.dispose();
    h2oController.dispose();
    fatController.dispose();
    muscleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   
    return buildColumn();
  }

    Widget buildColumn() {
    
      // #docregion Column
    return  Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildRow('WEIGHT   ','0',weightController),
          buildRow('% H2O     ','0',h2oController),
          buildRow('% FAT      ','0',fatController),
          buildRow('% MUSCLES','0',muscleController),
           RaisedButton(  
                  textColor: Colors.white,  
                  color: Colors.blue,  
                  child: const Text('Register'),  
                  
                  onPressed: ()
                  {
                 
                         if(!validateInput(weightController) || !validateInput(h2oController) || !validateInput(fatController) || !validateInput(muscleController))
                          {
                           return;
                         }
                           
                         showDialog(
                         context: context,
                         builder: (context) {
                        return AlertDialog(
                        title: const Text('Confirm your Health Data?',style: TextStyle(backgroundColor: Colors.lightBlue),),
                        // Retrieve the text the that user has entered by using the
                        // TextEditingController.
                        content: Column(mainAxisSize: MainAxisSize.min , mainAxisAlignment: MainAxisAlignment.spaceEvenly,children:
                         [
                         buildDialogRow('WEIGHT  ',': '+weightController.text),
                         buildDialogRow('% H2O  ',': '+h2oController.text),
                         buildDialogRow('% FAT  ',': '+fatController.text),
                         buildDialogRow('% MUSCLES  ',': '+muscleController.text),     
                        ]
                        ,),

       
actions: [
              // The "Yes" button
              TextButton(
                  onPressed: () {
                    // Remove the box
                    setState(() {
                      //save data
                       weightController.text = "";
                       h2oController.text = "";
                       fatController.text = "";
                       muscleController.text = "";
                      _csvData?.clear();
                      _csvData = null;

                    });

                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('Yes')),
              TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('No'))
            ]
                        ,
              );
            },
          );
                  },  
                ),  
           RaisedButton(  
                  textColor: Colors.white,  
                  color: Colors.blue,  
                  child: const Text('History'),  
                  
                  onPressed:  () async {
               
               
                 
                showCSVDialog();
                      
                 
                 if(_csvData==null)
                 {
                   
                   try
                   {
                 
                    _csvData = await widget.fileUtils.processCsv(context);
                       setState( ()  {
                       Navigator.of(context).pop();
                       showCSVDialog();
                      }
                    );
                   }
                   catch(ex)
                   {
                       setState( ()  {
                       Navigator.of(context).pop();
                       
                      });
                   }
                    

                   
                 }
                  },  
                )  ,


        ],
      );
    }
      Widget buildDialogRow(String name,String value)
      {
        return  Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [ 
          Flexible(flex: 1, 
          child: Align(
      alignment: Alignment.centerLeft,
      child: Container(
          child:  Text(name,textAlign: TextAlign.start)
                         ))) ,
                           Flexible(flex: 1, 
          child: 
          Align(
      alignment: Alignment.centerLeft,
      child: Container(
          child: Text(value,textAlign: TextAlign.start)))),],);
      }
      Widget buildRow(String name,String value,TextEditingController fieldController) =>
      // #docregion Row
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(flex: 2, 
          child: Text(name,textAlign: TextAlign.left)),
          Flexible(
            flex: 8,
            child:
                  TextField(  
                    controller: fieldController,
                     keyboardType: TextInputType.numberWithOptions(signed:false,decimal:true),
            inputFormatters: [
    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}'))
],
                    decoration:  InputDecoration(  
                      border: OutlineInputBorder(),  
                      labelText: value,  
                      hintText: 'Enter Your $name',  
                    ),  
                  ),  
                
          ),  
        ],
      );
      
       bool validateInput(TextEditingController controller) {
         String value = controller.text;
         if(value.isEmpty) {
           return false;
         }
                         
                         if(value.startsWith('0'))
                          {
                            if(value.length==1 || value == '0.' || value == '0.0') {
                              return false;
                            }

                          }

                         if(value.endsWith('.'))
                           {
                            controller.text = value.substring(0,value.length-1);
                           }

                          return true;
       }
       
         void showCSVDialog()
          {

   showDialog(
                         context: context,
                         builder: (context) {
                        return AlertDialog(
                        title: const Text('How are you doing?',style: TextStyle(backgroundColor: Colors.lightBlue),),

                        //scrollable: true,
                        content: 
                       SingleChildScrollView(
       scrollDirection: Axis.vertical,
        child: SingleChildScrollView (
         scrollDirection: Axis.horizontal,
         child:  _csvData == null
            ? const CircularProgressIndicator()
            : DataTable(
                columns: _csvData![0]
                    .map(
                      (item) => DataColumn(
                        label: Text(
                          item.toString(),
                        ),
                      ),
                    )
                    .toList(),
                rows: _csvData!
                    .map(
                      (csvrow) => DataRow(
                        cells: csvrow
                            .map(
                              (csvItem) => DataCell(
                                Text(
                                  csvItem.toString(),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    )
                    .toList()
              ),
      ),
                          )   ,
                        
              );
            },
          );
         }
}