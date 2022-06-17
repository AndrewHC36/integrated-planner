import 'package:flutter/material.dart';
import 'package:integrated_planner/checklist.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Integrated Planner',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Integrated Planner'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,

                children: const [
                  Text(
                    "Log in",
                    style: TextStyle(
                      fontSize: 36.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text("Text fields...")
                ],
              ),
              color: Colors.blueGrey,
              padding: EdgeInsets.all(5.0),
              margin: EdgeInsets.all(5.0),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  Text(
                    "Sign up",
                    style: TextStyle(
                      fontSize: 36.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text("Text fields...")
                ],
              ),
              color: Colors.grey,
              padding: EdgeInsets.all(5.0),
              margin: EdgeInsets.all(5.0),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => Checklist())
                );
              },
              child: const Text("Next page!"),
            ),
          ],
        ),
      ),
    );
  }
}
