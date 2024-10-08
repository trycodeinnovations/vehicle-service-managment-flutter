import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Chatbot extends StatefulWidget {
  @override
  _ChatbotState createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> _messages = [];

  @override
  void initState() {
    super.initState();
    _messages.add({
      'text':
          "Hello! I'm Zia, your virtual assistant. How can I help you today?",
      'sender': 'Bot',
    });
  }

  void _sendMessage() {
    final userMessage = _controller.text;
    if (userMessage.isNotEmpty) {
      setState(() {
        // Add user message
        _messages.add({'text': userMessage, 'sender': 'User'});

        // Clear the text field
        _controller.clear();

        // Generate and add bot response
        String botResponse = _generateDynamicResponse(userMessage);
        _messages.add({'text': botResponse, 'sender': 'Bot'});
      });
    }
  }

  String _generateDynamicResponse(String query) {
    if (query.contains('service') || query.contains('offer')) {
      return "We offer a variety of services including oil changes, tire services, and sound system installations.";
    } else if (query.contains('book')) {
      return "You can book a service through the app's service section. Just select the service you want!";
    } else if (query.contains('promotions') || query.contains('discount')) {
      return "Check out our promotions in the 'Promotions' section of the app for the latest offers!";
    } else if (query.contains('last service')) {
      return "You can view your last service details in the 'Last Service' section on the homepage.";
    } else if (query.contains('help')) {
      return "I'm here to help with information on services, promotions, and booking appointments. Ask me anything!";
    } else if (query.contains('who are you') ||
        query.contains('what is your name')) {
      return "I'm Zia, your virtual assistant designed to help you with your queries.";
    } else if (query.contains('what can you do')) {
      return "I can assist you with booking services, checking promotions, and answering questions about our offerings.";
    } else {
      return "I’m sorry, I didn’t quite understand that. Could you ask something else about our services?";
    }
  }

  void _clearChat() {
    setState(() {
      _messages.clear(); // Clear the chat messages
      _messages.add({
        'text':
            "Hello! I'm Zia, your virtual assistant. How can I help you today?",
        'sender': 'Bot', // Add the initial bot message again
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              height: 400,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        return Align(
                          alignment: message['sender'] == 'User'
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: message['sender'] == 'User'
                                  ? Colors.blue
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              message['text']!,
                              style: GoogleFonts.poppins(
                                color: message['sender'] == 'User'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: 'Type your message...',
                            border: OutlineInputBorder(),
                            contentPadding: const EdgeInsets.all(10),
                          ),
                          onSubmitted: (value) => _sendMessage(),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _sendMessage,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ).whenComplete(() {
          _clearChat(); // Clear the chat when the modal is closed
        });
      },
      child: Image.asset("assets/images/robot-assistant.png"),
    );
  }
}
