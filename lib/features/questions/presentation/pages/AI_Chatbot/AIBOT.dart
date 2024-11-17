import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class AIBOT extends StatefulWidget {
  final String question;

  const AIBOT({super.key, required this.question});

  @override
  _AIBOTState createState() => _AIBOTState();
}

class _AIBOTState extends State<AIBOT> {
  final List<String> messages = [];
  final TextEditingController _controller = TextEditingController();
  final gemini = Gemini.instance;

  @override
  void initState() {
    super.initState();
    _sendInitialMessage(); // Send the question when the widget is initialized
  }

  void _sendInitialMessage() {
    // Automatically send the question passed to the AIBOT widget
    final initialMessage = widget.question;
    setState(() {
      messages.add(":User  $initialMessage"); // Show user message
    });

    // Stream Gemini's response and update UI as each part arrives
    gemini.streamGenerateContent(initialMessage).listen((value) {
      setState(() {
        // Append AI response as it streams in
        messages.add("AI: ${value.output}");
      });
    }).onError((e) {
      // Display error if streaming fails
      setState(() {
        messages.add("Error: ${e.toString()}");
      });
    });
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        messages.add(":User  ${_controller.text}"); // Show user message
      });

      final userMessage = _controller.text;
      _controller.clear(); // Clear the text field

      // Stream Gemini's response and update UI as each part arrives
      gemini.streamGenerateContent(userMessage).listen((value) {
        setState(() {
          // Append AI response as it streams in
          messages.add("AI: ${value.output}");
        });
      }).onError((e) {
        // Display error if streaming fails
        setState(() {
          messages.add("Error: ${e.toString()}");
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chatbot')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(messages[index]));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Type a message...'),
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
