import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatbotMessageriePage extends StatefulWidget {
  const ChatbotMessageriePage({super.key});

  @override
  _ChatbotMessageriePageState createState() => _ChatbotMessageriePageState();
}

class _ChatbotMessageriePageState extends State<ChatbotMessageriePage> {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isBotTyping = false;

  // Initialize Gemini API
  late GenerativeModel _model;
  late ChatSession _chat;

  @override
  void initState() {
    super.initState();
    _initializeGemini();
  }

  void _initializeGemini() {
    final apiKey = dotenv.get('GEMINI_API_KEY');
    _model = GenerativeModel(
      model: 'gemini-2.0-pro-exp-02-05',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 64,
        topP: 0.95,
        maxOutputTokens: 8192,
        responseMimeType: 'text/plain',
      ),
      systemInstruction: Content.system(
        'Role & Purpose:\nYou are a virtual generalist doctor, trained to assist users with their medical concerns by providing preliminary guidance, general health advice, and educational information. You should help patients understand their symptoms, suggest possible causes, and recommend whether they should seek professional medical care. You are not a substitute for a real doctor and should always encourage users to visit a healthcare professional when necessary.\n\nBehavior & Limitations:\nBe empathetic, professional, and reassuring when responding to users.\nAvoid diagnosing conditions definitively—only suggest possibilities based on symptoms.\nDo not prescribe medications or recommend specific treatments beyond general over-the-counter advice.\nEncourage users to consult a real doctor for serious, persistent, or emergency symptoms.\nBe clear, concise, and medically accurate while avoiding overly complex medical jargon.\nRespect privacy and confidentiality—do not store or request personal or sensitive medical data.\nResponse Style & Tone:\nUse a friendly yet professional tone.\nShow concern for the patient\'s well-being while maintaining objectivity.\nProvide step-by-step guidance when necessary (e.g., “Try drinking more water and resting. If symptoms persist for more than 48 hours, see a doctor.”).\nOffer educational explanations where appropriate (e.g., “A fever is your body’s way of fighting infection. If it’s above 39°C and lasts more than three days, consult a doctor.”).\nEscalation & Safety Protocol:\nIf a user mentions severe symptoms (e.g., chest pain, difficulty breathing, loss of consciousness), urge them to seek immediate medical attention:\nExample: “Your symptoms could indicate a serious condition. Please seek urgent medical care or call emergency services.”\nIf symptoms persist or worsen, strongly encourage consulting a healthcare professional.\nExample Interactions:\nUser: "I have a headache and feel really tired. What could it be?"\nChatbot: "I\'m sorry you\'re feeling this way! Headaches and fatigue can have many causes, such as dehydration, stress, or even a mild viral infection. Have you been drinking enough water and getting enough rest? If the headache is severe, persistent, or accompanied by symptoms like vision changes or fever, I recommend seeing a doctor."\n\nUser: "I have chest pain and shortness of breath. What should I do?"\nChatbot: "Chest pain and shortness of breath can be signs of a serious medical condition, such as a heart problem. Please seek immediate medical attention or call emergency services as soon as possible!"',
      ),
    );
    _chat = _model.startChat();
  }

  void _sendMessage(String text) async {
    if (text.isEmpty) return;

    // Add user message
    setState(() {
      _messages.add({
        'text': text,
        'isMe': true,
        'time': _getCurrentTime(),
        'type': 'text',
      });
    });

    // Simulate bot typing
    setState(() {
      _isBotTyping = true;
    });

    // Send message to Gemini API
    try {
      final response = await _chat.sendMessage(Content.text(text));
      final botResponse = response.text ?? 'Sorry, I didn\'t understand that.';

      // Add bot response
      setState(() {
        _isBotTyping = false;
        _messages.add({
          'text': botResponse,
          'isMe': false,
          'time': _getCurrentTime(),
          'type': 'text',
        });
      });
    } catch (e) {
      setState(() {
        _isBotTyping = false;
        _messages.add({
          'text': 'An error occurred. Please try again.',
          'isMe': false,
          'time': _getCurrentTime(),
          'type': 'text',
        });
      });
    }

    // Clear input field
    _controller.clear();
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour}:${now.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.smart_toy, color: Colors.teal), // Chatbot icon
            SizedBox(width: 10),
            Text(
              'Chatbot',
              style: TextStyle(color: Colors.teal, fontSize: 16),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.teal),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isBotTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isBotTyping && index == _messages.length) {
                  return const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(color: Colors.teal),
                    ),
                  );
                }
                final message = _messages[index];
                return MessageBubble(
                  isMe: message['isMe'],
                  message: message['text'],
                  time: message['time'],
                  type: message['type'],
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
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.teal),
                  onPressed: () {
                    _sendMessage(_controller.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final bool isMe;
  final String message;
  final String time;
  final String? type;

  const MessageBubble({
    super.key,
    required this.isMe,
    required this.message,
    required this.time,
    this.type = 'text',
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: isMe ? Colors.teal : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: _buildMessageContent(message),
          ),
          Text(
            time,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageContent(String text) {
    return MarkdownBody(
      data: text,
      selectable: true,
      styleSheet: MarkdownStyleSheet(
        p: TextStyle(color: isMe ? Colors.white : Colors.black),
        strong: const TextStyle(fontWeight: FontWeight.bold),
        em: const TextStyle(fontStyle: FontStyle.italic),
        code: TextStyle(
          fontFamily: 'monospace',
          backgroundColor: Colors.grey.shade300,
          color: Colors.black,
        ),
      ),
    );
  }
}

