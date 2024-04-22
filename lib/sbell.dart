import 'dart:async';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SubmissionBell extends StatefulWidget {
  @override
  _SubmissionBellPageState createState() => _SubmissionBellPageState();
}

class _SubmissionBellPageState extends State<SubmissionBell> {
  TextEditingController handleController = TextEditingController();
  Color pageColor = Colors.white;
  String statusText = '';
  bool isRunning = false;
  AudioCache audioCache = AudioCache();
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void dispose() {
    handleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submission Bell'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: handleController,
              decoration: InputDecoration(labelText: 'Enter Codeforces Handle'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: isRunning ? null : startBell,
              child: Text('Start'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: stopBell,
              child: Text('Stop'),
            ),
            SizedBox(height: 20.0),
            Container(
              height: 100.0,
              color: pageColor,
              alignment: Alignment.center,
              child: Text(
                statusText,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void startBell() {
    setState(() {
      isRunning = true;
      statusText = 'Checking for submissions...';
    });

    Timer.periodic(Duration(seconds: 10), (Timer timer) {
      if (!isRunning) {
        timer.cancel();
      } else {
        checkSubmissions();
      }
    });
  }

  void stopBell() {
    setState(() {
      isRunning = false;
      statusText = '';
    });
  }

  int prev = 0, curr = 0;
  String previos_verdict = "", cur_verdict = "";
  final player = AudioPlayer();
  void checkSubmissions() async {
    String handle = handleController.text;
    if (handle.isEmpty) {
      setState(() {
        statusText = 'Please enter a Codeforces handle.';
      });
      return;
    }

    String apiUrl = "https://codeforces.com/api/user.status?handle=$handle";
    http.Response response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      if (data.containsKey('status') &&
          data['status'] == 'OK' &&
          data.containsKey('result')) {
        // print(data['id']);
        // print("Fuck this shit");
        List<dynamic> submissions = data['result'];
        if (submissions.isNotEmpty) {
          String verdict = submissions[0]['verdict'];
          // print(submissions[0]['id']);
          // print("Fuck this shit");
          // print(verdict);
          curr = submissions[0]['id'];
          // print(curr);
          // print(prev);
          // print(previos_verdict);
          // print(verdict);
          if (curr == prev && previos_verdict == verdict) {
            return;
          }
          prev = curr;
          previos_verdict = verdict;
          if (verdict == 'OK') {
            setState(() {
              pageColor = Colors.green;
              statusText = 'Submission Accepted!';
            });
            playSound('ping.mp3');
          } else {
            setState(() {
              pageColor = Colors.red;
              statusText = 'Submission Wrong!';
            });
            playSound('buzzer.mp3');
          }
        } else {
          setState(() {
            statusText = 'No recent submissions.';
          });
        }
      } else {
        setState(() {
          statusText = 'Error fetching submissions.';
        });
      }
    } else {
      setState(() {
        statusText = 'Error fetching submissions.';
      });
    }
  }

  Future<void> playSound(String audioPath) async {
    await player.stop();
    await player.play(AssetSource(audioPath));
  }

  Future<void> pauseSound() async {
    await player.stop();
  }
}
