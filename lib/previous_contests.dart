// import 'compare.dart';
import 'package:cp_help/drawer.dart';
import 'package:cp_help/ongoing_contest.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
// import './user.dart';
import 'package:url_launcher/url_launcher.dart';

class PreviousContests extends StatefulWidget {
  int bal = 0;
  PreviousContests(int bal) {
    this.bal = bal;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    // throw UnimplementedError();
    return PreviousContestsState(bal);
  }
}

class PreviousContestsState extends State {
  late int bal;
  PreviousContestsState(int bal) {
    this.bal = bal++;
  }

  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _handle1Controller = TextEditingController();
  TextEditingController _handle2Controller = TextEditingController();

  _launchURL(int id) async {
    Uri url = Uri.parse("https://codeforces.com/contest/" + id.toString());
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // throw UnimplementedError();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: Text(
          "Previous Contests",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        // leading: Image.asset(
        //   "assets/images/cf.png",
        //   height: 25.0,
        //   // width: 20.0,
        // ),
        actions: [],
      ),
      drawer: MyDrawer(),
      body: FutureBuilder(
          future: contestInfo(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Center(child: CircularProgressIndicator());
            } else {
              // throw "Could launch this ";
              return ListView.builder(
                  itemCount: snapshot.data['result'].length,
                  // ignore: missing_return
                  itemBuilder: (context, index) {
                    index += bal + 1;
                    print("bal : $bal");
                    if (snapshot.data['result'][index]['phase'] == "FINISHED") {
                      print("Index : $index");
                      return Container(
                        margin: const EdgeInsets.all(10.0),
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 28, 10, 49), //purple
                          // color: Color.fromARGB(255, 18, 27, 63),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 2,
                              offset:
                                  Offset(2, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        child: InkWell(
                          child: Row(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: <Widget>[
                                  Text(
                                    "Name",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                    ),
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
                          onTap: () =>
                              _launchURL(snapshot.data['result'][index]['id']),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  });
            }
          }),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 28, 10, 49),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.list_alt,
                color: Colors.white,
              ),
              label: 'Upcoming',
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.update,
                color: Colors.white,
              ),
              label: 'Previous',
              backgroundColor: Colors.blueGrey),
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
            Navigator.pop(context);
          } else if (value == 1) {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) => PreviousContests(this.bal)),
            // );
          } else if (value == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Ongoing()),
            );
          }
        },
      ),
    );
  }
}

Future<Map<String, dynamic>> contestInfo() async {
  String url = "https://codeforces.com/api/contest.list";
  http.Response data = await http.get(Uri.parse(url));
  print(data.runtimeType);
  print(data);
  return json.decode(data.body);
}

String startTime(timestamp) {
  var format = DateFormat('EEE dMMMM y HH:mm a');
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
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
