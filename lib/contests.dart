// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:cp_help/drawer.dart';
import 'package:cp_help/ongoing_contest.dart';
import 'package:cp_help/previous_contests.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:http/http.dart' as http;

final snackBar = SnackBar(
  content: Text(
    'Notification Set for Contest!',
    style: TextStyle(
      color: Colors.black,
    ),
  ),
  backgroundColor: Colors.blue,
);

class Home extends StatefulWidget {
  // const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String readTimestapmDif(int timestamp) {
    var now = new DateTime.now();
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = now.difference(date);

    print("Time span : ${diff.inSeconds}");

    return diff.inSeconds.toString();
  }

  late int ContestId;

  _launchURL(int id) async {
    Uri url = Uri.parse("https://codeforces.com/contest/" + id.toString());
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    // initializing();
  }

  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _handle1Controller = TextEditingController();
  TextEditingController _handle2Controller = TextEditingController();
  int bal = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: Text(
          'UPCOMING CONTESTS',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [],
      ),
      drawer: MyDrawer(),
      // ignore: unnecessary_new
      body: new FutureBuilder(
          future: contestInfo(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: Text('Loading....'),
              );
            } else {
              // throw "Could Not launch this ";

              return ListView.builder(
                  itemCount: snapshot.data['result'].length,
                  itemBuilder: (context, index) {
                    if (snapshot.data['result'][index]['phase'] == "BEFORE") {
                      bal = index;
                      print("check: $bal");
                      return Container(
                        margin: const EdgeInsets.all(10.0),
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 28, 10, 49),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 2,
                              offset: Offset(2, 1),
                            ),
                          ],
                        ),
                        child: InkWell(
                          child: Row(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  Text(
                                    "Name",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12.0),
                                    softWrap: true,
                                  ),
                                  Text(
                                    "Type",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                    ),
                                    softWrap: true,
                                  ),
                                  Text(
                                    "Duration",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                    ),
                                    softWrap: true,
                                  ),
                                  Text(
                                    "Start",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13.0,
                                    ),
                                    softWrap: true,
                                  ),
                                ],
                              ),
                              VerticalDivider(),
                              Column(
                                children: <Widget>[
                                  Text(":"),
                                  // SizedBox(height: ,),
                                  Text(":"),
                                  Text(":"),
                                  Text(":"),
                                ],
                              ),
                              VerticalDivider(),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      snapshot.data['result'][index]['name'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13.0,
                                      ),
                                      softWrap: true,
                                    ),
                                    Text(
                                      snapshot.data['result'][index]['type'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13.0,
                                      ),
                                    ),
                                    Text(
                                      // duration(snapshot.data['result'][index]
                                      //     ['durationSeconds']),
                                      ((snapshot.data['result'][index]
                                                      ['durationSeconds']) /
                                                  (60 * 60))
                                              .toString() +
                                          " hr",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13.0,
                                      ),
                                    ),
                                    Text(
                                      startTime(snapshot.data['result'][index]
                                          ['startTimeSeconds']),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // VerticalDivider(),
                              // IconButton(
                              //     iconSize: 30,
                              //     color: Colors.blue,
                              //     onPressed: () {
                              //       int duration = (snapshot.data['result']
                              //           [index]['durationSeconds']);
                              //       int min1 = 60;
                              //       int minutesT = duration ~/ min1;
                              //       print("Minutes: ${minutesT}");
                              //       String title1 =
                              //           snapshot.data['result'][index]['name'];
                              //       print(title1);
                              //       DateTime start = (snapshot.data['result']
                              //           [index]['startTimeSeconds']);
                              //       print(start);
                              //       var date =
                              //           DateTime.fromMillisecondsSinceEpoch(
                              //               snapshot.data['result'][index]
                              //                       ['startTimeSeconds'] *
                              //                   1000);
                              //     },
                              //     icon: Icon(Icons.date_range))
                            ],
                          ),
                          onTap: () {
                            _launchURL(snapshot.data['result'][index]['id']);
                            // ignore: deprecated_member_use
                            ScaffoldMessenger.of(context).showSnackBar;
                          },
                        ),
                      );
                    } else {
                      return Container();
                    }
                  });
            }
            ;
          }),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 28, 10, 49),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.list_alt,
                color: Colors.white,
              ),
              label: ('Upcoming')),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.update,
                color: Colors.white,
              ),
              label: 'Previous'),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.timer,
              color: Colors.white,
            ),
            label: 'Ongoing',
          ),
        ],
        onTap: (value) {
          if (value == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
          } else if (value == 1) {
            // print("h, bal $bal");
            bal++;
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PreviousContests(this.bal)),
            );
          } else if (value == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Ongoing()),
            );
          }
          ;
        },
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
  var format = new DateFormat('EEE dMMMM y HH:mm a');
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
