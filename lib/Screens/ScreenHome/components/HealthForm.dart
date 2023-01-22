

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_01/Models/healthrow.dart';
import 'package:flutter_01/Services/file_utilities.dart';
import 'package:intl/intl.dart';


class HealthForm extends StatefulWidget 
{
  final FileUtils fileUtils;

  const HealthForm({super.key,required this.fileUtils});

  @override
  State<HealthForm> createState() => _HealthFormState();
}

class _HealthFormState extends State<HealthForm> {

  final weightController  = TextEditingController();
  final h2oController     = TextEditingController();
  final fatController     = TextEditingController();
  final muscleController  = TextEditingController();
  final bonesController   = TextEditingController();
  final bmiController     = TextEditingController();
  
 
List<List<dynamic>>? _csvViewData;
List<List<dynamic>>? _csvLoadData;
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    weightController.dispose();
    h2oController.dispose();
    fatController.dispose();
    muscleController.dispose();
    bonesController.dispose();
    bmiController.dispose();
    super.dispose();
  }
    @override
    void initState() {
    super.initState();
    widget.fileUtils.initCsv();
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
          buildRow('WEIGHT :','0',weightController),
          buildRow('% H2O :','0',h2oController),
          buildRow('% FAT :','0',fatController),
          buildRow('% MUSCLES :','0',muscleController),
          buildRow('BONES :','0',bonesController),
          buildRow('BMI :','0',bmiController),
           ElevatedButton(  
                    style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue)),
                  
                  child: const Text('Register'),  
                  
                  onPressed: ()
                  {
                 
                         if(!validateInput(weightController) || !validateInput(h2oController) || !validateInput(fatController) || !validateInput(muscleController)
                         || !validateInput(bonesController) || !validateInput(bmiController)
                         )
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
                         buildDialogRow('BONES  ',': '+bonesController.text),     
                         buildDialogRow('BMI  ',': '+bmiController.text),     
                             
                        ]
                        ,),

       
actions: [
              // The "Yes" button
              TextButton(
                  onPressed: () async {


                       //save data
                      final DateTime now = DateTime.now();
                      final DateFormat formatter = DateFormat('yyyy/MM/dd');
                      final String formatted = formatter.format(now);
                      var healthRow = HealthRow(formatted,weightController.text,h2oController.text,fatController.text,muscleController.text,bonesController.text,bmiController.text);
                      await widget.fileUtils.writeHealthCsv(healthRow).then((value) {
                       setState(() {
                       _csvLoadData   = value;
                      //clean current view dataset
                       weightController.text = "";
                       h2oController.text    = "";
                       fatController.text    = "";
                       muscleController.text = "";
                       bonesController.text    = "";
                       bmiController.text = "";
                      _csvViewData?.clear();
                      _csvViewData = null;
                      Navigator.of(context).pop();
                    });
                      });  
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
            ElevatedButton(  
                    style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue)),
                  child: const Text('History'),  
                  
                  onPressed:  () async
                   {
              
                   showLoadingOrCSVDialog();
            
                  if(_csvLoadData!=null) 
                   {
                   _updateViewState(_csvLoadData);
                   }
                  else 
                  {
                   widget.fileUtils.readHealthCsv().then((value) => _updateViewState(value));
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
            Expanded(
            flex: 1,
            child:
            Container()),
          Expanded(
            flex: 2,
            child:
          Text(name,textAlign: TextAlign.right)),
           Expanded(
            flex: 1,
            child:
            Container()),
        Expanded(
            flex: 4,
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
                
           ), Expanded(
            flex: 2,
            child:
            Container()),
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
       
         void showLoadingOrCSVDialog()
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
         child:  _csvViewData == null
            ? const CircularProgressIndicator()
            : DataTable(
                columns: _csvViewData![0]
                    .map(
                      (item) => DataColumn(
                        label: Text(
                          item.toString(),
                        ),
                      ),
                    )
                    .toList(),
                rows: _csvViewData!.skip(1)
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
         
           void _updateViewState(List<List>? value) {

                      

                       setState( ()  
                       {
                       _csvLoadData = value;
                       _csvViewData = _csvLoadData;
                      // _csvLoadData = null;
                       
                       //close current dialog
                       Navigator.of(context).pop();
                       if(_csvViewData!=null)
                       {
                        //show data if any
                        showLoadingOrCSVDialog();
                       }
                    }
                    );
          }

           
}