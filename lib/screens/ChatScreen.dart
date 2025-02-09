import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark().copyWith(
      textTheme: GoogleFonts.robotoTextTheme(),
    ),
    home: ChatScreen(),
  ));
}

class OpenAIService {
  final String apiKey = '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'; // Your API key

  Future<String> getResponse(String userMessage) async {
    final url = Uri.parse('https://api.openai.com/v1/chat/completions'); // Endpoint for chat models

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey', // Use the provided API key here
        },
        body: json.encode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {'role': 'user', 'content': userMessage}
          ],
          'max_tokens': 150,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        return responseBody['choices'][0]['message']['content'].trim();
      } else if (response.statusCode == 429) {
        throw Exception('Quota exceeded. Please check your plan and try again later.');
      } else {
        throw Exception('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Failed to fetch AI response: $e');
    }
  }
}


class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final OpenAIService _openAIService = OpenAIService();

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;

    String userMessage = _controller.text;

    // Add user message to chat
    setState(() {
      _messages.add({"sender": "user", "message": userMessage});
    });

    // Fetch AI response
    String aiResponse = await _openAIService.getResponse(userMessage);

    // Add AI response to chat
    setState(() {
      _messages.add({"sender": "ai", "message": aiResponse});
    });

    // Clear text input
    _controller.clear();
  }

  Widget _buildMessage(Map<String, String> message) {
    return Align(
      alignment:
      message['sender'] == 'user' ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: message['sender'] == 'user' ? Colors.blueAccent : Colors.grey[800],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: message['sender'] == 'user'
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              message['message']!,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 5),
            Text(
              'Just now',
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with AI'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Handle settings if needed
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessage(_messages[index]);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
