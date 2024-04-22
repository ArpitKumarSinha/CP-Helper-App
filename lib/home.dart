import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:cp_help/contests.dart';

class home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CP HELPER',
            style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          HomeButton(title: 'Contests', route: '/home'),
          HomeButton(
              title: 'Problem of the Day', route: '/problem_of_the_day.dart'),
          HomeButton(title: 'CP Profiles', route: '/cp_profiles.dart'),
          HomeButton(title: 'Resources', route: '/resources.dart'),
          HomeButton(title: 'Submission Bell', route: '/submission_bell.dart'),
          HomeButton(title: 'To Be Added', route: '/to_be_added.dart'),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}

class HomeButton extends StatelessWidget {
  final String title;
  final String route;

  HomeButton({required this.title, required this.route});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 12.0),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, route);
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => Home()));
        },
        child: Card(
          margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
          color: Color.fromARGB(255, 28, 10, 49),
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

Future<Map<String, dynamic>> contestInfo() async {
  String url = "https://codeforces.com/api/contest.list";
  http.Response data = await http.get(Uri.parse(url));
  return json.decode(data.body);
}

String startTime(timestamp) {
  var format = DateFormat('EEE dMMMM y HH:mm a');
  var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  var time = format.format(date);
  return time;
}

String duration(timestamp) {
  double h, min = 0;
  if (timestamp % 3600 == 0)
    h = (timestamp / 3600);
  else {
    h = timestamp % 3600;
    timestamp = timestamp - (timestamp * h);
    min = timestamp;
  }

  return h.toString() + 'hr ' + min.toString() + 'min';
}
