import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final Color backgroundColor;

  WebViewScreen({required this.url,required this.backgroundColor});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize the controller
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        backgroundColor: widget.backgroundColor,
        border: null,
        middle: Text('Article',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w400,
          fontSize: 20,
          color: Colors.white
        ),),

      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
