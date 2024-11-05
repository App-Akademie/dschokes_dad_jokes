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
  // Future mit einem Defaultwert.
  Future<String> jokeFuture = Future.value("None yet.");

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder(
            future: jokeFuture,
            // Gibt das Widget zurück, das jeweils angezeigt werden soll.
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const CircularProgressIndicator();
              } else if (snapshot.connectionState == ConnectionState.done) {
                // Future ist fertig, jetzt können wir Daten anzeigen.
                if (snapshot.hasError) {
                  return const Icon(
                    Icons.error,
                    color: Colors.red,
                  );
                } else if (snapshot.hasData) {
                  final String joke = snapshot.data ?? "Got empty text";

                  return Text(
                    joke,
                    style: const TextStyle(fontSize: 18),
                  );
                }
              }

              return const Text("Unkonwn case");
            },
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              // Sorgt dafür, dass ein neuer Joke für das Future gesetzt wird.
              // Durch das 'build' bekommt der FutureBuilder das auch mit.
              setState(() {
                jokeFuture = getJoke();
              });
            },
            child: const Text('Get another joke'),
          ),
        ],
      ),
    );
  }
}

// Holt einen Joke und gibt diesen zurück.
Future<String> getJoke() async {
  await Future.delayed(const Duration(milliseconds: 2500), () {});

  final Future<http.Response> responseFuture = http.get(
    Uri.https('icanhazdadjoke.com', '/'),
    headers: {'Accept': 'text/plain'},
  );

  final http.Response jokeResponse = await responseFuture;

  final jokeBytes = jokeResponse.bodyBytes;

  // Sicherstellen, dass die Antwort richtig umgewandelt wird.
  final joke = utf8.decode(jokeBytes);

  log("joke: $joke");

  return joke;
}
