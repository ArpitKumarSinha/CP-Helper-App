import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:url_launcher/url_launcher.dart';

class Resources extends StatelessWidget {
  final List<Map<String, dynamic>> resourcesList = [
    {
      'type': 'PDF',
      'title': 'Guide to Competetive Programming',
      'assetPath': 'assets/gtcp.pdf'
    },
    {
      'type': 'PDF',
      'title': 'Competetive Programming Handbook',
      'assetPath': 'assets/cph.pdf'
    },
    {
      'type': 'Link',
      'title': 'CSES Problem Set',
      'url': 'https://cses.fi/problemset/'
    },
    {
      'type': 'Link',
      'title': 'CP Algorithms',
      'url': 'https://cp-algorithms.com/'
    },
    {
      'type': 'Link',
      'title': 'Codeforces ITMO Course',
      'url': 'https://codeforces.com/edu/course/2'
    },
    {
      'type': 'Link',
      'title': 'Project Euler',
      'url': 'https://projecteuler.net/'
    },
    {
      'type': 'Link',
      'title': 'Geeks for Geeks',
      'url': 'https://www.geeksforgeeks.org/'
    },
    {
      'type': 'Link',
      'title': 'STL by Luv',
      'url':
          'https://youtube.com/playlist?list=PLauivoElc3gh3RCiQA82MDI-gJfXQQVnn&si=xiSsJFO0WYLPdxBx'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resources'),
      ),
      body: ListView.builder(
        itemCount: resourcesList.length,
        itemBuilder: (context, index) {
          final resource = resourcesList[index];
          return ListTile(
            title: Text(resource['title']),
            onTap: () async {
              if (resource['type'] == 'PDF') {
                navigateToPDFViewer(context, resource['assetPath']);
              } else if (resource['type'] == 'Link') {
                final urli = Uri.parse(resource['url']);
                launchUrl(urli);
              }
            },
          );
        },
      ),
    );
  }

  void navigateToPDFViewer(BuildContext context, String assetPath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFViewerScreen(assetPath: assetPath),
      ),
    );
  }

  // void launchURL(String url) async {
  //   Uri urli = Uri.parse(url);
  //   if (await canLaunchUrl(urli)) {
  //     await launchUrl(urli);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  // Future<void> _launchUrl(Uri _url) async {
  //   if (!await launchUrl(_url)) {
  //     throw Exception('Could not launch $_url');
  //   }
  // }
}

class PDFViewerScreen extends StatelessWidget {
  final String assetPath;

  const PDFViewerScreen({required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: PDF().fromAsset(assetPath),
    );
  }
}
