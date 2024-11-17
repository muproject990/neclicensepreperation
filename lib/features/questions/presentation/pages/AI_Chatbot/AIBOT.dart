import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class AIBOT extends StatefulWidget {
  final String question;

  const AIBOT(this.question, {super.key});

  @override
  _AIBOTState createState() => _AIBOTState();
}

class _AIBOTState extends State<AIBOT> {
  final List<String> messages = [];
  final TextEditingController _controller = TextEditingController();
  final gemini = Gemini.instance;
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _speechText = "";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _sendInitialMessage(); // Automatically send the initial question
  }

  void _sendInitialMessage() {
    final initialMessage = widget.question;
    _addMessage("User: $initialMessage"); // Show user message

    // Stream Gemini's response and update UI as each part arrives
    gemini.streamGenerateContent(initialMessage).listen((value) {
      _addMessage("AI: ${value.output}"); // Append AI response
    }).onError((e) {
      _addMessage("Error: ${e.toString()}"); // Handle errors
    });
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      final userMessage = _controller.text;
      _addMessage("User: $userMessage"); // Show user message
      _controller.clear(); // Clear the text field

      // Stream Gemini's response and update UI as each part arrives
      gemini.streamGenerateContent(userMessage).listen((value) {
        _addMessage("AI: ${value.output}"); // Append AI response
      }).onError((e) {
        _addMessage("Error: ${e.toString()}"); // Handle errors
      });
    }
  }

  void _addMessage(String message) {
    if (mounted) {
      setState(() {
        messages.add(message); // Add message to the list
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatbot'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                bool isUser = messages[index].startsWith("User:");

                return Align(
                  alignment:
                      isUser ? Alignment.centerLeft : Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 8.0,
                    ),
                    child: Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: isUser
                            ? Colors.lightBlue[100]
                            : Colors.lightGreen[100],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0),
                          bottomLeft:
                              isUser ? Radius.zero : Radius.circular(8.0),
                          bottomRight:
                              isUser ? Radius.circular(8.0) : Radius.zero,
                        ),
                      ),
                      child: Text(
                        messages[index]
                            .substring(messages[index].indexOf(":") + 1)
                            .trim(),
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
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
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide(color: Colors.blueAccent),
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 35, 1, 1),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blueAccent),
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
