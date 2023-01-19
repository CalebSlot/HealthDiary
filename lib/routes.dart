import 'package:flutter/material.dart';

import 'Screens/ScreenHome/ScreenHome.dart';

final Map<String,WidgetBuilder> routes = <String,WidgetBuilder> {
  "/": (BuildContext context) => ScreenHome(),
};