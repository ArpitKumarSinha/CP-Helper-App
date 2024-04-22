import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ToBeAdded extends StatefulWidget {
  @override
  _RankPageState createState() => _RankPageState();
}

class _RankPageState extends State<ToBeAdded> {
  TextEditingController handleController = TextEditingController();
  List<Map<String, dynamic>> rankList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Organization Rank Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: handleController,
              decoration:
                  InputDecoration(labelText: 'Enter Organization Handle'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                await fetchRankList();
              },
              child: Text('Fetch Rank List'),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: ListView.builder(
                itemCount: rankList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(rankList[index]['name']),
                    subtitle: Text('Rank: ${rankList[index]['rank']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchRankList() async {
    String handle = handleController.text.trim();
    String apiUrl =
        "https://codeforces.com/api/organization.members?handle=$handle";
    http.Response response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      if (data.containsKey('status') &&
          data['status'] == 'OK' &&
          data.containsKey('result')) {
        setState(() {
          rankList = List<Map<String, dynamic>>.from(data['result']['members']);
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(
                  'Failed to fetch rank list. Please check the organization handle.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to fetch rank list. Please try again later.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
