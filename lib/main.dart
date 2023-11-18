import 'package:flutter/material.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:signals_test/state.dart';

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
    // I think we should be able to have a top level widget that automatically
    // subscribes to all of the Signals / Computed / Resources accessed
    // in the initial lines of the build method

    // can we eliminate ResourceBuilder?
    return ResourceBuilder(
      resource: $userProfile,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.title),
          ),
          // can we eliminate SignalBuilder?
          body: SignalBuilder(
            signal: $userLoggedIn,
            builder: (context, userLoggedIn, child) {
              return Center(
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
                    // can we eliminate SignalBuilder?
                    SignalBuilder(
                      signal: $userId,
                      builder: (context, value, child) {
                        return Text(value ?? "Logged out");
                      },
                    ),
                    Text(
                      snapshot.maybeMap(
                        // can we use a sealed class?
                        ready: (x) =>
                            x.value == null ? "Logged Out" : "${x.value?.name}",
                        orElse: () => "Loading",
                      ),
                    ),
                    ResourceBuilder(
                      // can we eliminate ResourceBuilder?
                      resource: $chatStream,
                      builder: (context, snapshot) {
                        final messages = snapshot.value;
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
              );
            },
          ),
        );
      },
    );
  }
}
