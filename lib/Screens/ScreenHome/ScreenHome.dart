 
import 'package:flutter/material.dart';
import 'package:flutter_01/Services/file_utilities.dart';

import 'components/HealthForm.dart';

class ScreenHome extends StatelessWidget {

  @override
  Widget  build(BuildContext context) {
  return Scaffold(
        appBar: AppBar(
          title: const Text('Health Diary!'),
        ),
        // Change to buildColumn() for the other column example
        body:  Center(child: HealthForm(fileUtils: FileUtils())),
      );
  }
 }