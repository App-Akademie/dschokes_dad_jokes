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
  Future<String> getJoke() async {
    await Future.delayed(const Duration(milliseconds: 2500), () {});

    final Future<http.Response> responseFuture = http.get(
      Uri.https('icanhazdadjoke.com', '/'),
      // // Get one fixed joke.
      // Uri.https('icanhazdadjoke.com', '/j/FBskq4MRnrc'),
      headers: {'Accept': 'text/plain'},
    );

    final http.Response jokeResponse = await responseFuture;

    final joke = jokeResponse.body;

    log("joke: $joke");

    return joke;
  }

  @override
  Widget build(BuildContext context) {
    // Wird bei jedem Aufruf von "build" neu gesetzt.
    final Future<String> jokeFuture = getJoke();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FutureBuilder(
          future: jokeFuture,
          // Gibt das Widget zurück, das jeweils angezeigt werden soll.
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.connectionState != ConnectionState.waiting) {
              // Future ist fertig, jetzt können wir Daten anzeigen.
              if (snapshot.hasError) {
                return const Icon(
                  Icons.error,
                  color: Colors.red,
                );
              } else if (snapshot.hasData) {
                final String joke = snapshot.data ?? "Got empty text";

                return Text(joke);
              }
            }

            return const Text("Unkonwn case");
          },
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            // Sorgt dafür, dass die "build"-Methode des StatefulWidget noch mal
            // aufgerufen wird. Dadurch wird ein neues Future geholt und der
            // FutureBuilder läuft wieder los, mit dem neuen Future.
            setState(() {});
          },
          child: const Text('Get another joke'),
        ),
      ],
    );
  }
}
