import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as api;
import 'package:integrated_planner/checklist.dart';
import 'package:http/http.dart' as http;
import 'google_http_client.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
  static const _scopes = <String>[api.CalendarApi.calendarEventsScope, api.CalendarApi.calendarReadonlyScope];
  late String uid;
  GoogleSignIn? _googleSignIn;

  Future<http.Client> getHttpClient() async {
    log("1");
    log("A");
    _googleSignIn = GoogleSignIn(
      scopes: _scopes,
    );

    try {
      log("2");
      GoogleSignInAccount? googleUser = await _googleSignIn!.signInSilently();
      googleUser ??= (await _googleSignIn!.signIn())!;
      log("3");
      var headers = (await googleUser.authHeaders);
      uid = googleUser.id;
      final baseClient = new http.Client();
      final authenticateClient = AuthenticateClient(headers, baseClient);
      return authenticateClient;
    } catch (error) {
      print(error);
      rethrow;
    }
  }

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
            Image.asset(
              "logo.png",
              height: 200,
              width: 200,
            ),
            SizedBox(height: 100,),
            ElevatedButton(
              onPressed: () async {
                var db = FirebaseFirestore.instance;

                var client = await getHttpClient();  // also sets uid
                var calendar = api.CalendarApi(client);

                await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => Checklist(
                      uid: uid,
                      db: db,
                      calendar: calendar,
                    ))
                );

                client.close();
                _googleSignIn!.signOut();
              },
              child: const Text("Sign in with Google."),
            ),
          ],
        ),
      ),
    );
  }
}
