import 'package:cp_help/home.dart';
import 'package:cp_help/potd.dart';
import 'package:cp_help/cp_profiles.dart';
import 'package:cp_help/resources.dart';
import 'package:cp_help/ToBeAdded.dart';
import 'package:cp_help/sbell.dart';
import 'package:cp_help/contests.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:intl/intl.dart';
// import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());
final ThemeData theme = ThemeData();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cp_Help',
      initialRoute: '/',
      routes: {
        '/home': (context) => Home(),
        '/problem_of_the_day.dart': (context) => potd(),
        '/cp_profiles.dart': (context) => cp_profiles(),
        '/resources.dart': (context) => Resources(),
        '/submission_bell.dart': (context) => SubmissionBell(),
        '/to_be_added.dart': (context) => ToBeAdded(),
      },
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(secondary: Colors.black),
      ),
      home: home(),
    );
  }
}
