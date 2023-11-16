import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:http/http.dart' as http;
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SpeechToText _speechToText = SpeechToText();
  String _searchQuery = "";
  String _searchResult = "";

  bool _speechEnabled = false;


  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void startListening() {
    _speechToText.listen(
      onResult: (result) {
        setState(() {
          _searchQuery = result.recognizedWords;
        });
      },
    );
    setState(() {
      _speechEnabled = true;
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0037FF),
        title: Text(
          'Quranee',
          style: TextStyle(
            color: Color(0xFFFFFFFF),
          ),
        ),
      ),
      body: 
      Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                _speechToText.isListening
                    ? "listening..."
                    : _speechEnabled
                    ? "Tap the microphone to start listening..."
                    : "Speech not available",
                style: TextStyle(fontSize: 20.0 , color: Color(0xFFFFFFFF)),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Text(
                  _searchResult,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w300,color: Color(0xFFFFFFFF)
                  ),
                ),
              ),
            ),
            if (_speechToText.isNotListening)
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 100,
                ),
              )
          ],
        ),
      ),backgroundColor: Color(0xFF194993),
      floatingActionButton: FloatingActionButton(
        onPressed: _speechToText.isListening ? _stopListening : _startListening,
        tooltip: 'Listen',
        child: Icon(
          _speechToText.isNotListening ? Icons.mic_off : Icons.mic,
          color: Color(0xFFFFFFFF) ,
        ),
        backgroundColor: Color(0xFF000000),
      ),
    );
  }


}
