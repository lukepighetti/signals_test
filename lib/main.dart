import 'package:flutter/material.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:signals_test/state.dart';

import 'architecture.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // We were able to create a Slot that reacts to Signal / Computed but 
    // not Resource. Also, we keep getting a Solidart exception on hot reload
    // when we're refactoring ResourceBuilder/SignalBuilder to Slot
    return Slot(
      builder: (context) {
        final userProfile = $userProfile.state.value; // this isn't updating
        final userLoggedIn = $userLoggedIn.value;
        final userId = $userId.value;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.title),
          ),
          // can we eliminate SignalBuilder?
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(
                  onPressed: userLoggedIn ? null : loginBob,
                  child: const Text("Login Bob"),
                ),
                FilledButton(
                  onPressed: userLoggedIn ? null : loginAlice,
                  child: const Text("Login Alice"),
                ),
                FilledButton(
                  onPressed: userLoggedIn ? logout : null,
                  child: const Text("Logout"),
                ),
                Text(userId ?? "Logged out"),
                Text(
                  userProfile == null ? "Logged Out" : userProfile.name,
                ),
                Slot(
                  builder: (context) {
                    // This isn't updating
                    final messages = $chatStream.state.value;

                    return Column(
                      children: [
                        if (messages != null)
                          for (final item in messages)
                            Text('${item.username}: ${item.message}')
                      ],
                    );
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
