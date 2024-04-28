import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:leakagedetection/local_notification.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DatabaseReference dbref = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (Timer t) => checkValues());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Leakage Detections System'),
        backgroundColor: Colors.lightBlueAccent,
        elevation: 6,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          LocalNotification.simpleNotification(
              title: "Alert", body: "warning...", payload: "payload");
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            Expanded(
              child: FirebaseAnimatedList(
                query: dbref,
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Flow Data",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        color: Colors.orange[50],
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Flow In: ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12,
                                      color: Colors.black87),
                                ),
                                Text(snapshot
                                    .child('flow_rate_1')
                                    .value
                                    .toString()),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "Flow Out: ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12,
                                      color: Colors.black87),
                                ),
                                Text(snapshot
                                    .child('flow_rate_2')
                                    .value
                                    .toString()),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "TDS Value",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Container(
                        color: Colors.blue[50],
                        child: ListTile(
                          title: Text(
                              snapshot.child('tds_value').value.toString()),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Temperature",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Container(
                        color: Colors.green[50],
                        child: ListTile(
                          title: Text(
                              snapshot.child('temperature').value.toString()),
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        color: Colors.red[50],
                        child: Row(
                          children: [
                            Text('Leakage Detected:'),
                            SizedBox(
                              child: Text(snapshot
                                  .child('leakage_data')
                                  .child('is_leakage_detected')
                                  .value
                                  .toString()),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void checkValues() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

// Get the Stream
    Stream<DatabaseEvent> stream = ref.onValue;

// Subscribe to the stream!
    stream.listen((DatabaseEvent event) {
      print('Snapshot: ${event.snapshot.child('data/temperature').value}');

      String str_myobject =
          event.snapshot.child('data/temperature').value.toString();

      int int_myobject = int.parse(str_myobject);

      if (int_myobject >= 35) {
        print(int_myobject);
        LocalNotification.simpleNotification(
            title: "Alert",
            body: "Temperature is too high",
            payload: "payload");
      }
    });
  }
}
