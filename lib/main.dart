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
      title: 'Traductor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Traductor(),
    );
  }
}

class Traductor extends StatefulWidget {
  @override
  _TraductorState createState() => _TraductorState();
}

class _TraductorState extends State<Traductor> {
  final TextEditingController _controller = TextEditingController();
  String _translatedText = '';

  void _translate() async {
    final response = await http.post(
      Uri.parse('https://translation.googleapis.com/language/translate/v2'),
      body: {
        'q': _controller.text,
        'source': 'es',
        'target': 'en',
        'format': 'text',
        'key': '@AIzaSyBicvXQazxTfWQvlsHG_DQduaNIXWRmcz0_',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        _translatedText = data['data']['translations'][0]['translatedText'];
      });
    } else {
      throw Exception('Failed to translate text');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Traductor'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Ingresa una palabra en español',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _translate,
              child: Text('Traducir'),
            ),
            SizedBox(height: 16.0),
            Text(
              'Traducción al inglés:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(_translatedText),
          ],
        ),
      ),
    );
  }
}
