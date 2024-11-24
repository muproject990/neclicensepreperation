import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class AIBOT extends StatefulWidget {
  final String question;
  final String query;
  final String answer;

  const AIBOT(this.question, this.answer, [this.query = '', Key? key])
      : super(key: key);

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
    _sendInitialMessage();
  }

  void _sendInitialMessage() {
    final initialMessage = widget.query.isNotEmpty
        ? "${widget.question}  ${widget.answer}   \n Ans: ${widget.query} \n Explain "
        : widget.question;

    _addMessage("User: $initialMessage");

    gemini.streamGenerateContent(initialMessage).listen((value) {
      _addMessage("AI: ${value.output}");
    }).onError((e) {
      _addMessage("Error: ${e.toString()}");
    });
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      final userMessage = _controller.text;
      _addMessage("User: $userMessage");
      _controller.clear();

      gemini.streamGenerateContent(userMessage).listen((value) {
        _addMessage("AI: ${value.output}");
      }).onError((e) {
        _addMessage("Error: ${e.toString()}");
      });
    }
  }

  void _addMessage(String message) {
    if (mounted) {
      setState(() {
        messages.add(message);
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
