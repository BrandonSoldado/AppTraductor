import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Translator App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TranslationPage(),
    );
  }
}

class TranslationPage extends StatefulWidget {
  @override
  _TranslationPageState createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage> {
  final String _apiKey = '@AIzaSyBicvXQazxTfWQvlsHG_DQduaNIXWRmcz0_';
  final String _url = 'https://translation.googleapis.com/language/translate/v2';

  String _translatedText = '';
  TextEditingController _textController = TextEditingController();

  void _translate() async {
    String text = _textController.text.trim();
    if (text.isEmpty) return;

    String target = 'en'; // English
    String url = '$_url?key=$_apiKey&q=$text&target=$target';

    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      setState(() {
        _translatedText = jsonResponse['data']['translations'][0]['translatedText'];
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Translator App')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Enter text in Spanish...',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _translate,
              child: Text('Translate'),
            ),
            SizedBox(height: 20),
            Text('Translated Text:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(_translatedText),
          ],
        ),
      ),
    );
  }
}
