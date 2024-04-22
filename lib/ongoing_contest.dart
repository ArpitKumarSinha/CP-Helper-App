import 'dart:convert';

import 'package:cp_help/drawer.dart';
import 'package:cp_help/home.dart';
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
      color: Colors.white,
    ),
  ),
  backgroundColor: const Color.fromARGB(10, 255, 255, 255),
);

class Ongoing extends StatefulWidget {
  const Ongoing({Key? key}) : super(key: key);
  @override
  _OngoingState createState() => _OngoingState();
}

class _OngoingState extends State<Ongoing> {
  String readTimestapmDif(int timestamp) {
    var now = new DateTime.now();
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = now.difference(date);

    print("Time span : ${diff.inSeconds}");

    return diff.inSeconds.toString();
  }

  late int ContestId;

  _launchURL(int id) async {
    String url = "https://codeforces.com/contest/" + id.toString();
    if (await canLaunch(url)) {
      await launch(url);
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
  var count = 0;
  var destn = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: Text(
          'ONGOING CONTESTS',
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
                child: CircularProgressIndicator(),
              );
            } else {
              // throw "Could Not launch this ";

              return ListView.builder(
                  itemCount: snapshot.data['result'].length,
                  itemBuilder: (context, index) {
                    if (snapshot.data['result'][index]['phase'] == "CODING") {
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
                                        color: Colors.white, fontSize: 15.0),
                                    softWrap: true,
                                  ),
                                  Text(
                                    "Type",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                    ),
                                    softWrap: true,
                                  ),
                                  Text(
                                    "Duration",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                    ),
                                    softWrap: true,
                                  ),
                                  Text(
                                    "Start",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                    ),
                                    softWrap: true,
                                  ),
                                ],
                              ),
                              VerticalDivider(),
                              Column(
                                children: <Widget>[
                                  Text(":"),
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
                                        fontSize: 15.0,
                                      ),
                                      softWrap: true,
                                    ),
                                    Text(
                                      snapshot.data['result'][index]['type'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15.0,
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
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    Text(
                                      startTime(snapshot.data['result'][index]
                                          ['startTimeSeconds']),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          onTap: () {
                            _launchURL(snapshot.data['result'][index]['id']);
                            ScaffoldMessenger.of(context).showSnackBar;
                          },
                        ),
                      );
                    } else {
                      print("Total Count: ${count}");
                      count++;

                      return Column(
                        mainAxisAlignment: MainAxisAlignment
                            .center, //Center Column contents vertically,
                        crossAxisAlignment: CrossAxisAlignment
                            .center, //Center Column contents horizontally,
                        children: [
                          Center(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(0, 200, 0, 0),
                              child: count == destn
                                  ? Text(
                                      'There is no ongoing contest!',
                                      style: TextStyle(color: Colors.grey),
                                    )
                                  : Container(),
                            ),
                          )
                        ],
                      );
                    }
                  });
            }
            ;
          }),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 46, 46, 47),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list_alt,
              color: Colors.white,
            ),
            label: 'Upcoming',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.update,
              color: Colors.white,
            ),
            label: 'Previous',
          ),
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
              MaterialPageRoute(builder: (context) => home()),
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
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => OngoingContests()),
            // );
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
