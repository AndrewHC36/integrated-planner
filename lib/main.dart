import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as api;
import 'package:integrated_planner/checklist.dart';
import 'package:http/http.dart' as http;
import 'google_http_client.dart';



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
  static const _scopes = <String>[api.CalendarApi.calendarEventsScope, api.CalendarApi.calendarReadonlyScope];

  @override
  void initState() {
    super.initState();
  }

  Future<http.Client> getHttpClient() async {
    final _googleSignIn = GoogleSignIn(
      scopes: _scopes,
    );

    try {
      GoogleSignInAccount googleUser = (await _googleSignIn.signIn())!;
      var headers = (await googleUser.authHeaders);

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
            Image.asset("logo.png"),
            ElevatedButton(
              onPressed: () async {
                var client = await getHttpClient();
                var calendar = api.CalendarApi(client);

                var calendarList = await calendar.calendarList.list();
                for (var element in calendarList.items!) {
                  log(element.summary!);
                }

                // String calendarId = "primary";
                //
                // api.Event event = api.Event();
                //
                // var start = api.EventDateTime();
                // start.timeZone = "GMT+05:00";
                // start.dateTime = DateTime(2022, 6, 20);
                // var end = api.EventDateTime();
                // end.timeZone = "GMT+05:00";
                // start.dateTime = DateTime(2022, 6, 30);
                //
                // event.summary = "Test";
                // event.start = start;
                // event.end = end;
                //
                // calendar.events.insert(event, calendarId).then((value) {
                //   print("ADDING_________________${value.status}");
                //   if (value.status == "confirmed") {
                //     log('Event added in google calendar');
                //   } else {
                //     log("Unable to add event in google calendar");
                //   }
                // });

                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => Checklist())
                );
              },
              child: const Text("Sign in with Google."),
            ),
          ],
        ),
      ),
    );
  }
}
