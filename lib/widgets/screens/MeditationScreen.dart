import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(const MeditationApp(backgroundColor: Color(0xFF2A0944)));
}

class MeditationApp extends StatelessWidget {
  final Color backgroundColor;

  const MeditationApp({Key? key, required this.backgroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: CupertinoThemeData(
        brightness: Brightness.dark,
        primaryColor: backgroundColor,
      ),
      home: MeditationScreen(backgroundColor: backgroundColor),
    );
  }
}

class MeditationScreen extends StatelessWidget {
  final Color backgroundColor;

  const MeditationScreen({Key? key, required this.backgroundColor}) : super(key: key);

  final List<Map<String, String>> _sessions = const [
    {
      "title": "Morning Calm",
      "duration": "10 mins",
      "image": "https://images.unsplash.com/photo-1506126613408-eca07ce68773?ixlib=rb-1.2.1&auto=format&fit=crop&w=1951&q=80",
      "audio": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
    },
    {
      "title": "Deep Relaxation",
      "duration": "15 mins",
      "image": "https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?ixlib=rb-1.2.1&auto=format&fit=crop&w=1940&q=80",
      "audio": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3",
    },
    {
      "title": "Evening Serenity",
      "duration": "20 mins",
      "image": "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0?auto=format&fit=crop&w=1950&q=80",
      "audio": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3",
    },
    {
      "title": "Stress Relief",
      "duration": "12 mins",
      "image": "https://images.unsplash.com/photo-1494172961521-33799ddd43a5?auto=format&fit=crop&w=1950&q=80",
      "audio": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3",
    },
    {
      "title": "Inner Peace",
      "duration": "18 mins",
      "image": "https://images.unsplash.com/photo-1520975916090-3105956dac38?auto=format&fit=crop&w=1950&q=80",
      "audio": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3",
    },
    {
      "title": "Mindful Breathing",
      "duration": "8 mins",
      "image": "https://images.unsplash.com/photo-1512453979798-5ea266f8880c?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1950&q=80",
      "audio": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3",
    },
  ];


  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: backgroundColor,
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          "Meditation",
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w400,
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        border: null,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(CupertinoIcons.back,size: 23,)),
        backgroundColor: backgroundColor,
      ),
      child: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _sessions.length,
          itemBuilder: (context, index) {
            final session = _sessions[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.black.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => MeditationPlayerScreen(
                          session: session,
                          backgroundColor: backgroundColor,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                session["title"]!,
                                style: GoogleFonts.roboto(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                session["duration"]!,
                                style: GoogleFonts.roboto(
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Hero(
                          tag: session["image"]!,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: session["image"]!,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey[800],
                                child: const Center(
                                  child: CupertinoActivityIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey[800],
                                child: const Icon(
                                  CupertinoIcons.exclamationmark_triangle,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}



class MeditationPlayerScreen extends StatefulWidget {
  final Map<String, String> session;
  final Color backgroundColor;

  const MeditationPlayerScreen({
    Key? key,
    required this.session,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  _MeditationPlayerScreenState createState() => _MeditationPlayerScreenState();
}

class _MeditationPlayerScreenState extends State<MeditationPlayerScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _setupAudioPlayer();
  }

  void _setupAudioPlayer() {
    _audioPlayer.onDurationChanged.listen((duration) {
      if (mounted) setState(() => _duration = duration);
    });

    _audioPlayer.onPositionChanged.listen((position) {
      if (mounted) setState(() => _position = position);
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) setState(() => _isPlaying = state == PlayerState.playing);
    });
  }

  void _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(widget.session["audio"]!));
    }
  }

  String _formatDuration(Duration duration) {
    return "${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return CupertinoPageScaffold(
      backgroundColor: widget.backgroundColor,
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          widget.session["title"]!,
          style: GoogleFonts.roboto(fontWeight: FontWeight.w400, color: Colors.white,fontSize: 20),
        ),
        backgroundColor: widget.backgroundColor,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(CupertinoIcons.back,size: 23,)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildImage(screenWidth),
            const SizedBox(height: 30),
            _buildTitle(screenWidth),
            const SizedBox(height: 30),
            _buildSlider(screenWidth),
            const SizedBox(height: 20),
            _buildPlayPauseButton(screenWidth),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(double screenWidth) {
    return Hero(
      tag: widget.session["image"]!,
      child: Container(
        width: screenWidth * 0.8,
        height: screenWidth * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 2,
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: CachedNetworkImage(
            imageUrl: widget.session["image"]!,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.grey[800],
              child: const Center(child: CupertinoActivityIndicator()),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[800],
              child: const Icon(
                CupertinoIcons.exclamationmark_triangle,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(double screenWidth) {
    return Column(
      children: [
        Text(
          widget.session["title"]!,
          style: TextStyle(
            fontSize: screenWidth * 0.07,
            fontWeight: FontWeight.bold,
            color: Colors.white,
              decoration: TextDecoration.none
          ),
        ),
        const SizedBox(height: 10),
        Text(
          widget.session["duration"]!,
          style: TextStyle(
            fontSize: screenWidth * 0.05,
            color: Colors.white.withOpacity(0.8),
              decoration: TextDecoration.none
          ),
        ),
      ],
    );
  }

  Widget _buildSlider(double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          CupertinoSlider(
            value: (_duration.inSeconds > 0)
                ? (_position.inSeconds / _duration.inSeconds).clamp(0.0, 1.0)
                : 0.0,
            min: 0,
            max: 1,

            activeColor: Colors.white,
            thumbColor: Colors.white,
            onChanged: (value) async {
              if (_duration.inSeconds > 0) {
                await _audioPlayer.seek(
                  Duration(seconds: (value * _duration.inSeconds).toInt()),
                );
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatDuration(_position),
                    style: TextStyle(fontSize: 14, color: Colors.white,
                    decoration: TextDecoration.none)),
                Text("-" + _formatDuration(_duration - _position),
                    style: TextStyle(fontSize: 14, color: Colors.white,decoration: TextDecoration.none)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayPauseButton(double screenWidth) {
    return CupertinoButton(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.2,
        vertical: screenWidth * 0.05,
      ),
      onPressed: _togglePlayPause,
      child: Icon(
        _isPlaying ? CupertinoIcons.pause_fill : CupertinoIcons.play_fill,
        size: screenWidth * 0.08,
        color: widget.backgroundColor,
      ),
    );
  }
}


