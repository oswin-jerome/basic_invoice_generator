import 'package:basic_invoice_generator/pages/companydetails.dart';
import 'package:basic_invoice_generator/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox("company");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xff56C7A0),
        accentColor: Color(0xffF15692),
      ),
      home: HomePage(),
    );
  }
}
