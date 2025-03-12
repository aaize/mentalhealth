import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class PodcastScreen extends StatefulWidget {
  final Color backgroundColor;

  PodcastScreen({Key? key, required this.backgroundColor}) : super(key: key);

  @override
  _PodcastScreenState createState() => _PodcastScreenState();
}

class _PodcastScreenState extends State<PodcastScreen> {
  final List<Map<String, String>> podcasts = [
    {
      "title": "The Hilarious World of Depression",
      "host": "John Moe",
      "duration": "45 min",
      "audioUrl": "https://www.hilariousworld.org/"
    },
    {
      "title": "Therapy Chat",
      "host": "Laura Reagan, LCSW-C",
      "duration": "45 min",
      "audioUrl": "https://podcasts.apple.com/us/podcast/therapy-chat/id1033011989"
    },
    {
      "title": "The Happiness Lab",
      "host": "Dr. Laurie Santos",
      "duration": "40 min",
      "audioUrl": "https://www.happinesslab.fm/"
    },
    {
      "title": "Unlocking Us",
      "host": "Brené Brown",
      "duration": "50 min",
      "audioUrl": "https://brenebrown.com/podcast/introducing-unlocking-us/"
    },
    {
      "title": "We Can Do Hard Things",
      "host": "Glennon Doyle",
      "duration": "60 min",
      "audioUrl": "https://podcasts.apple.com/us/podcast/we-can-do-hard-things/id1564530722"
    },
    {
      "title": "Where Should We Begin?",
      "host": "Esther Perel",
      "duration": "50 min",
      "audioUrl": "https://podcasts.apple.com/us/podcast/where-should-we-begin-with-esther-perel/id1237931798"
    },
    {
      "title": "The Mental Illness Happy Hour",
      "host": "Paul Gilmartin",
      "duration": "90 min",
      "audioUrl": "https://mentalpod.com/"
    },
    {
      "title": "10% Happier with Dan Harris",
      "host": "Dan Harris",
      "duration": "60 min",
      "audioUrl": "https://www.tenpercent.com/podcast"
    },
    {
      "title": "On Purpose with Jay Shetty",
      "host": "Jay Shetty",
      "duration": "60 min",
      "audioUrl": "https://jayshetty.me/podcast/"
    },
    {
      "title": "The Positive Psychology Podcast",
      "host": "Kristen Truempy",
      "duration": "30 min",
      "audioUrl": "https://positivepsychologypodcast.com/"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: widget.backgroundColor,

      navigationBar: CupertinoNavigationBar(
        border: null,
        middle: Text(
          "Podcasts",
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(CupertinoIcons.back),
        ),
      ),
      child: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: podcasts.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              title: Text(
                podcasts[index]["title"]!,
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
              subtitle: Text(
                "Host: ${podcasts[index]["host"]!} • ${podcasts[index]["duration"]!}",
              ),
              trailing: Icon(CupertinoIcons.play_circle_fill, color: Colors.green),
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => PodcastPlayerScreen(
                      url: podcasts[index]["audioUrl"]!,
                      title: podcasts[index]["title"]!,
                      backgroundColor: widget.backgroundColor,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class PodcastPlayerScreen extends StatefulWidget {
  final String url;
  final String title;
  final Color backgroundColor;

  PodcastPlayerScreen({required this.url, required this.title, required this.backgroundColor});

  @override
  _PodcastPlayerScreenState createState() => _PodcastPlayerScreenState();
}

class _PodcastPlayerScreenState extends State<PodcastPlayerScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.title),
        backgroundColor: widget.backgroundColor,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(CupertinoIcons.back),
        ),
      ),
      child: SafeArea(
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}