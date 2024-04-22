import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';

class cp_profiles extends StatefulWidget {
  @override
  _CpProfilesPageState createState() => _CpProfilesPageState();
}

class _CpProfilesPageState extends State<cp_profiles> {
  TextEditingController handleController = TextEditingController();
  bool isLoading = false;
  Map<String, dynamic>? userData;
  List<FlSpot> ratingSpots = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CP Profiles'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: handleController,
                decoration:
                    InputDecoration(labelText: 'Enter Codeforces Handle'),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: isLoading ? null : fetchUserData,
                child: Text('Fetch Data'),
              ),
              SizedBox(height: 20.0),
              if (isLoading)
                CircularProgressIndicator()
              else if (userData != null && ratingSpots.isNotEmpty)
                buildUserProfile()
              else
                Text('Enter a Codeforces handle and click "Fetch Data"'),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUserProfile() {
    String? avatarUrl = userData!['titlePhoto'];
    String handle = userData!['handle'] ?? 'N/A';
    String firstName = userData!['firstName'] ?? 'N/A';
    String lastName = userData!['lastName'] ?? 'N/A';
    String country = userData!['country'] ?? 'N/A';
    String city = userData!['city'] ?? 'N/A';
    int rating = userData!['rating'] ?? 0;
    int maxRating = userData!['maxRating'] ?? 0;
    String Rank = userData!['maxRank'] ?? 'N/A';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (avatarUrl != null)
          Container(
            width: 100.0,
            height: 100.0,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: NetworkImage(avatarUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        SizedBox(height: 20.0),
        Text('Handle: $handle'),
        Text('First Name: $firstName'),
        Text('Last Name: $lastName'),
        Text('Country: $country'),
        Text('City: $city'),
        Text('Rating: $rating'),
        Text('Max Rating: $maxRating'),
        Text('Max Rank: $Rank'),
        SizedBox(height: 20.0),
        buildRatingChart(),
      ],
    );
  }

  void fetchUserData() async {
    setState(() {
      isLoading = true;
      ratingSpots.clear();
    });

    String handle = handleController.text.trim();
    String userApiUrl = "https://codeforces.com/api/user.info?handles=$handle";
    String ratingApiUrl =
        "https://codeforces.com/api/user.rating?handle=$handle";

    // Fetch user data
    http.Response userDataResponse = await http.get(Uri.parse(userApiUrl));
    if (userDataResponse.statusCode == 200) {
      Map<String, dynamic> data = json.decode(userDataResponse.body);
      if (data.containsKey('status') &&
          data['status'] == 'OK' &&
          data.containsKey('result')) {
        setState(() {
          userData = data['result'][0];
        });
      }
    }

    // Fetch rating data
    http.Response ratingDataResponse = await http.get(Uri.parse(ratingApiUrl));
    if (ratingDataResponse.statusCode == 200) {
      List<dynamic> ratingData = json.decode(ratingDataResponse.body)['result'];
      for (var data in ratingData) {
        double rating = data['newRating'].toDouble();
        int timestamp = data['ratingUpdateTimeSeconds'];
        ratingSpots.add(FlSpot(timestamp.toDouble(), rating));
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  Widget buildRatingChart() {
    return SizedBox(
      height: 200.0,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: ratingSpots,
              isCurved: true,
              color: Colors.blue,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                  show: true, color: Colors.lightBlue.withOpacity(0.3)),
            ),
          ],
        ),
      ),
    );
  }
}
