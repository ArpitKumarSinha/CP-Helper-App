// import 'package:cf_appapp/utilities/constants.dart';
import 'package:cp_help/home.dart';
// import 'package:cf_app/ui/ongoing_contest.dart';
// import 'package:cf_app/ui/previous_contest.dart';
// import 'package:cf_app/ui/cf_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: Container(
        // color: kPrimaryColor,
        // color: Colors.blue,
        child: ListView(
          children: [
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => home()),
                );
              },
              leading: const Icon(
                CupertinoIcons.home,
                color: Colors.white,
              ),
              title: const Text(
                "Home",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Text(
              "Cp_Help By Gsharp",
              style: TextStyle(color: Colors.white),
            ),
            // ListTile(
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => SingleUserInputPage()),
            //     );
            //   },
            //   leading: const Icon(
            //     CupertinoIcons.profile_circled,
            //     color: Colors.black,
            //   ),
            //   title: const Text(
            //     "Search User",
            //     textScaleFactor: 1.2,
            //     style: const TextStyle(color: Colors.black),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
