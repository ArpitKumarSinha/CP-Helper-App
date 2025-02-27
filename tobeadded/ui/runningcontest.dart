// import 'dart:convert';

// import 'package:cp_help/drawer.dart';
// import 'package:cp_help/main.dart';
// import 'package:cp_help/ui/runningcontest.dart';
// import 'package:cp_help/ui/pastcontest.dart';
// import 'package:cp_help/main.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:intl/intl.dart';
// import 'package:url_launcher/url_launcher.dart';

// import 'package:http/http.dart' as http;

// final snackBar = SnackBar(
//   content: Text(
//     'Notification Set for Contest!',
//     style: TextStyle(
//       color: Colors.white,
//     ),
//   ),
//   backgroundColor: Colors.white,
// );

// class Ongoing extends StatefulWidget {
//   const Ongoing({Key? key}) : super(key: key);
//   @override
//   _OngoingState createState() => _OngoingState();
// }

// class _OngoingState extends State<Ongoing> {
//   String readTimestapmDif(int timestamp) {
//     var now = new DateTime.now();
//     var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
//     var diff = now.difference(date);

//     print("Time span : ${diff.inSeconds}");

//     return diff.inSeconds.toString();
//   }

//   late int ContestId;

//   _launchURL(int id) async {
//     Uri url = Uri.parse("https://codeforces.com/contest/" + id.toString());
//     if (await canLaunchUrl(url)) {
//       await launchUrl(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }

//   // lOCAL pUSH NOTIFICATION

//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   late AndroidInitializationSettings androidInitializationSettings;
//   late InitializationSettings initializationSettings;

//   @override
//   void initState() {
//     super.initState();
//     // initializing();
//   }

//   void _showNotifications() async {
//     await notification();
//   }

//   void _showNotificationsAfterSecond(int time) async {
//     print("Time : $time");
//     await notificationAfterSec(time.abs());
//   }

//   Future<void> notification() async {
//     AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails('Channel ID', 'Channel title',
//             priority: Priority.high,
//             importance: Importance.max,
//             ticker: 'test');

//     NotificationDetails notificationDetails =
//         NotificationDetails(android: androidNotificationDetails);
//     await flutterLocalNotificationsPlugin.show(
//         0, 'Hello there', 'You have Upcoming Contests', notificationDetails);
//   }

//   Future<void> notificationAfterSec(int time) async {
//     var timeDelayed = DateTime.now().add(Duration(seconds: time));
//     AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails('second channel ID', 'second Channel title',
//             priority: Priority.high,
//             importance: Importance.max,
//             ticker: 'test');

//     NotificationDetails notificationDetails =
//         NotificationDetails(android: androidNotificationDetails);
//     await flutterLocalNotificationsPlugin.schedule(1, 'Hello Coder!',
//         'Its Contest Time', timeDelayed, notificationDetails);
//   }

//   Future onSelectNotification(String payLoad) async {
//     if (payLoad != null) {
//       print("payLoad : $payLoad");
//     }

//     // await Navigator.push(
//     //   context,
//     //   MaterialPageRoute(
//     //       builder: (context) => User(_textFieldController.text.toString())),
//     // );

//     _launchURL(this.ContestId);

//     // we can set navigator to navigate another screen
//   }

//   Future onDidReceiveLocalNotification(
//       int id, String title, String body, String payload) async {
//     return CupertinoAlertDialog(
//       title: Text(title),
//       content: Text(body),
//       actions: <Widget>[
//         CupertinoDialogAction(
//             isDefaultAction: true,
//             onPressed: () {
//               print("");
//             },
//             child: Text("Okay")),
//       ],
//     );
//   }

//   TextEditingController _textFieldController = TextEditingController();
//   TextEditingController _handle1Controller = TextEditingController();
//   TextEditingController _handle2Controller = TextEditingController();
//   int bal = 0;
//   var count = 0;
//   var destn = 1;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: Colors.black),
//         backgroundColor: Colors.white,
//         title: Text(
//           'ONGOING CONTEST',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 20.0,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//         actions: [
//           Image(
//             image: AssetImage("assets/images/cf.png"),
//           ),
//         ],
//       ),
//       drawer: MyDrawer(),
//       // ignore: unnecessary_new
//       body: new FutureBuilder(
//           future: contestInfo(),
//           builder: (BuildContext context, AsyncSnapshot snapshot) {
//             if (snapshot.data == null) {
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             } else {
//               // throw "Could Not launch this ";

//               return ListView.builder(
//                   itemCount: snapshot.data['result'].length,
//                   itemBuilder: (context, index) {
//                     if (snapshot.data['result'][index]['phase'] == "CODING") {
//                       bal = index;
//                       print("check: $bal");
//                       return Container(
//                         margin: const EdgeInsets.all(10.0),
//                         padding: const EdgeInsets.all(10.0),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.5),
//                               spreadRadius: 3,
//                               blurRadius: 2,
//                               offset: Offset(2, 1),
//                             ),
//                           ],
//                         ),
//                         child: InkWell(
//                           child: Row(
//                             children: <Widget>[
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 // ignore: prefer_const_literals_to_create_immutables
//                                 children: [
//                                   Text(
//                                     "Name",
//                                     style: TextStyle(
//                                         color: Colors.black, fontSize: 15.0),
//                                     softWrap: true,
//                                   ),
//                                   Text(
//                                     "Type",
//                                     style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 15.0,
//                                     ),
//                                     softWrap: true,
//                                   ),
//                                   Text(
//                                     "Duration",
//                                     style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 15.0,
//                                     ),
//                                     softWrap: true,
//                                   ),
//                                   Text(
//                                     "Start",
//                                     style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 15.0,
//                                     ),
//                                     softWrap: true,
//                                   ),
//                                 ],
//                               ),
//                               VerticalDivider(),
//                               Column(
//                                 children: <Widget>[
//                                   Text(":"),
//                                   Text(":"),
//                                   Text(":"),
//                                   Text(":"),
//                                 ],
//                               ),
//                               VerticalDivider(),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: <Widget>[
//                                     Text(
//                                       snapshot.data['result'][index]['name'],
//                                       style: TextStyle(
//                                         color: Colors.blue,
//                                         fontWeight: FontWeight.w700,
//                                         fontSize: 15.0,
//                                       ),
//                                       softWrap: true,
//                                     ),
//                                     Text(
//                                       snapshot.data['result'][index]['type'],
//                                       style: TextStyle(
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.w700,
//                                         fontSize: 15.0,
//                                       ),
//                                     ),
//                                     Text(
//                                       // duration(snapshot.data['result'][index]
//                                       //     ['durationSeconds']),
//                                       ((snapshot.data['result'][index]
//                                                       ['durationSeconds']) /
//                                                   (60 * 60))
//                                               .toString() +
//                                           " hr",
//                                       style: TextStyle(
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.w700,
//                                         fontSize: 15.0,
//                                       ),
//                                     ),
//                                     Text(
//                                       startTime(snapshot.data['result'][index]
//                                           ['startTimeSeconds']),
//                                       style: TextStyle(
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.w700,
//                                         fontSize: 15.0,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             ],
//                           ),
//                           onTap: () {
//                             // _showNotificationsAfterSecond(int.parse(
//                             //   readTimestapmDif(snapshot.data['result'][index]
//                             //   ['startTimeSeconds'])
//                             // ));
//                             _launchURL(snapshot.data['result'][index]['id']);
//                             // ignore: deprecated_member_use
//                             Scaffold.of(context).showSnackBar(snackBar);
//                           },
//                         ),
//                       );
//                     } else {
//                       print("Total Count: ${count}");
//                       count++;

//                       return Column(
//                         mainAxisAlignment: MainAxisAlignment
//                             .center, //Center Column contents vertically,
//                         crossAxisAlignment: CrossAxisAlignment
//                             .center, //Center Column contents horizontally,
//                         children: [
//                           Center(
//                             child: Container(
//                               padding: EdgeInsets.fromLTRB(0, 200, 0, 0),
//                               child: count == destn
//                                   ? Text(
//                                       'There is no ongoing contest!',
//                                       style: TextStyle(color: Colors.grey),
//                                     )
//                                   : Container(),
//                             ),
//                           )
//                         ],
//                       );
//                       // return Stack(
//                       //   children: [
//                       //     Column(
//                       //       child: Container(

//                       //         child: count==destn?Text('There is no Ongoing Contest!',style: TextStyle(color: Colors.grey),):Text(""),
//                       //       ),

//                       //     ),

//                       //   ],
//                       // );
//                       // return Stack(
//                       //   children: [
//                       //     Container(

//                       //     ),
//                       //     showDialog(context: context, builder: builder)
//                       //   ]
//                       //   );
//                     }
//                   });
//             }
//             ;
//           }),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.list_alt,
//               color: Colors.red,
//             ),
//             title: Text(
//               "UPCOMING",
//               style: TextStyle(color: Colors.black, fontSize: 12),
//             ),
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.update,
//               color: Colors.blue,
//             ),
//             title: Text("PREVIOUS",
//                 style: TextStyle(
//                   color: Colors.black,
//                 )),
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.timer,
//               color: Colors.green,
//             ),
//             title: Text("ONGOING",
//                 style: TextStyle(
//                   color: Colors.black,
//                 )),
//           ),
//         ],
//         onTap: (value) {
//           if (value == 0) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => HomePage()),
//             );
//           } else if (value == 1) {
//             // print("h, bal $bal");
//             bal++;
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => PreviousContests(this.bal)),
//             );
//           } else if (value == 2) {
//             // Navigator.push(
//             //   context,
//             //   MaterialPageRoute(builder: (context) => OngoingContests()),
//             // );
//           }
//           ;
//         },
//       ),
//     );
//   }
// }

// Future<Map<String, dynamic>> contestInfo() async {
//   String url = "https://codeforces.com/api/contest.list";
//   http.Response data = await http.get(Uri.parse(url));
//   return json.decode(data.body);
// }

// String startTime(timestamp) {
//   var format = new DateFormat('EEE dMMMM y HH:mm a');
//   var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
//   var time = format.format(date);
//   return time;
// }

// String duration(timestamp) {
//   double h, min = 0;
//   if (timestamp % 3600 == 0)
//     h = (timestamp / 3600);
//   else {
//     h = timestamp % 3600;
//     timestamp = timestamp - (timestamp * h);
//     min = timestamp;
//   }

//   return h.toString() + 'hr ' + min.toString() + 'min';
// }
