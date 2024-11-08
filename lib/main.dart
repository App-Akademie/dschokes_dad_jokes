import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dad Jokes',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dad Jokes'),
        ),
        body: const Center(
          child: DschokeScreen(),
        ),
      ),
    );
  }
}

class DschokeScreen extends StatefulWidget {
  const DschokeScreen({super.key});

  @override
  State<DschokeScreen> createState() => _DschokeScreenState();
}

class _DschokeScreenState extends State<DschokeScreen> {
  String joke = "";

  @override
  void initState() {
    super.initState();
    fetchJoke();
  }

  void fetchJoke() async {
    setState(() {
      joke = 'Loading joke...';
    });

    final Future<http.Response> responseFuture = http.get(
      Uri.https('icanhazdadjoke.com', '/'),
      headers: {'Accept': 'text/plain'},
    );

    final http.Response response = await responseFuture;

    if (response.statusCode == 200) {
      setState(() {
        // Sicherstellen, dass die Textzeichen passen.
        joke = utf8.decode(response.bodyBytes);
        log("Joke loaded: $joke");
      });
    } else {
      setState(() {
        joke = 'Failed to load joke';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            joke,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: fetchJoke,
          child: const Text('Get another joke'),
        ),
      ],
    );
  }
}
