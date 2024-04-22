import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class potd extends StatefulWidget {
  @override
  _ProblemOfTheDayPageState createState() => _ProblemOfTheDayPageState();
}

class _ProblemOfTheDayPageState extends State<potd> {
  double _selectedRating = 800; // Default selected rating
  String _selectedTag = 'implementation'; // Default selected tag
  List<dynamic> _problems = []; // List to store fetched problems

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Problem of the Day'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Slider(
              value: _selectedRating,
              min: 800,
              max: 4000,
              divisions: 32, // Divisions for each 100 rating points
              label: _selectedRating.round().toString(),
              onChanged: (value) {
                setState(() {
                  _selectedRating = value;
                });
              },
            ),
            SizedBox(height: 20.0),
            DropdownButton<String>(
              value: _selectedTag,
              items: <String>[
                'implementation',
                'math',
                'dp',
                // Add more tags as needed
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _selectedTag = value!;
                });
              },
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                fetchProblems();
              },
              child: Text('Fetch Problems'),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: ListView.builder(
                itemCount: _problems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_problems[index]['name']),
                    subtitle: Text('Rating: ${_problems[index]['points']}'),
                    onTap: () async {
                      // String problemUrl = _problems[index]['url'];
                      var contestId = _problems[index]['contestId'];
                      var id = _problems[index]['index'];
                      var url =
                          'https://codeforces.com/problemset/problem/$contestId/$id';
                      // Open the URL (implement this based on your app's navigation)
                      print('Opening problem URL: $url');
                      final urli = Uri.parse(url);
                      launchUrl(urli);
                      // Navigate to the Codeforces problem URL
                      // You can use a package like url_launcher to open the URL
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void fetchProblems() async {
    String apiUrl =
        "https://codeforces.com/api/problemset.problems?tags=$_selectedTag&minRating=${_selectedRating.toInt()}&maxRating=${_selectedRating.toInt()}";
    http.Response response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      if (data.containsKey('result') && data['result'] != null) {
        setState(() {
          _problems = data['result']['problems'];
        });
      } else {
        // Handle error or no problems found
      }
    } else {
      // Handle API request error
    }
  }
}
