import 'package:flutter/material.dart';
import 'package:myapp/pages/index.dart';
import 'package:myapp/themes/color.dart';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 255, 255)),

      cardColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      // useMaterial3: true,
      primaryColor: primary
    ),
    home: IndexPage(),
  )
);