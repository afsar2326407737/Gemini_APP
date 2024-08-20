import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];
  bool _isLoading = false;

  void _handleSubmit() {
    String value = _controller.text;
    if (value.isNotEmpty) {
      _getResponse(value);
      _controller.clear();
    }
  }

  Future<void> _getResponse(String query) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final apiKey = 'AIzaSyB1QI1TwdQPNRDnezeXSXKo17mHK1Bp8pM';
      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
      final content = [Content.text(query)];

      final response = await model.generateContent(content);
      setState(() {
        _messages.add(
          'User: $query',
        );
        _messages.add('Jarvis: ${response.text}');
      });
    } catch (e) {
      setState(() {
        _messages.add('Error: $e');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jarvis',
            style: TextStyle(
              color: Colors.white,
            )),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: const Color.fromARGB(65, 0, 0, 0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 0, 0, 0),
                      borderRadius:
                          BorderRadius.circular(10.0), // Rounded corners
                      border: Border.all(
                          color: const Color.fromARGB(255, 0, 0, 0)), // Border
                    ),
                    child: Text(
                      _messages[index],
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
            if (_isLoading) const CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsets.only(left: 11, right: 11),
              child: Row(
                children: [
                  // Expanded widget ensures that the TextField takes up the remaining space
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onSubmitted: (value) => _handleSubmit(),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Ask me anything...',
                      ),
                    ),
                  ),
                  const SizedBox(
                      width:
                          8.0), // Add some spacing between the TextField and the button
                  ElevatedButton(
                    onPressed: _handleSubmit,
                    child: const Text('>'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: HomePage(),
  ));
}
