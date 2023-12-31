// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, no_leading_underscores_for_local_identifiers, unused_element, unused_local_variable, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:veta/constants.dart';
import 'package:veta/screens/agora_call.dart';
import 'package:veta/screens/doctor_prescribe.dart';
import 'package:veta/screens/mobile_body.dart';
import 'package:veta/screens/doctor_dash.dart';

class DoctorAppointment extends StatefulWidget {
  const DoctorAppointment({super.key});

  @override
  State<DoctorAppointment> createState() => _DoctorAppointmentState();
}

class _DoctorAppointmentState extends State<DoctorAppointment> {
  Future showpetdetails(pettype, height, weight, age, gender) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            content: Container(
                child: Column(
          children: [
            Text("Pet: " + pettype),
            SizedBox(height: 10),
            Text("Height: " + height),
            SizedBox(height: 10),
            Text("Weight: " + weight),
            SizedBox(height: 10),
            Text("Age: " + age),
            SizedBox(height: 10),
            Text("Gender: " + gender),
            SizedBox(height: 10),
          ],
        )));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: myAppBar,
        backgroundColor: defaultBackgroundColor,
        drawer: Drawer(
          backgroundColor: Colors.grey[300],
          child: Column(children: [
            DrawerHeader(
              child:
                  ImageIcon(AssetImage('./assets/images/logo.png'), size: 160),
            ),
            //child: ImageIcon(AssetImage('assets/images/logo.png'), size: 160)),
            Padding(
              padding: tilePadding,
              child: ListTile(
                leading: Icon(Icons.home),
                title: Text(
                  'D A S H B O A R D',
                  style: drawerTextColor,
                ),
                onTap: (() {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return DoctorScaffold();
                  }));
                }),
              ),
            ),
            Padding(
              padding: tilePadding,
              child: ListTile(
                leading: Icon(Icons.account_box),
                title: Text(
                  'M Y  A P P O I N T M E N T S',
                  style: drawerTextColor,
                ),
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return DoctorAppointment();
                  }));
                },
              ),
            ),
            Padding(
              padding: tilePadding,
              child: ListTile(
                leading: Icon(Icons.logout),
                title: Text(
                  'L O G O U T',
                  style: drawerTextColor,
                ),
                onTap: () async {
                  await FirebaseFirestore.instance
                      .collection('doctors')
                      .where('email', isEqualTo: user!.email)
                      .get()
                      .then((QuerySnapshot results) async {
                    //doctor_firstname = results.docs[0]['firstname'];
                    await FirebaseFirestore.instance
                        .collection('doctors')
                        .doc(results.docs[0].id)
                        .update({
                      "isLoggedin": "Offline",
                    });
                  });
                  await FirebaseAuth.instance.signOut();
                  Phoenix.rebirth(context);
                },
              ),
            )
          ]),
        ),
        body: DefaultTabController(
          length: 2,
          child: Scaffold(
              body: Column(
            children: [
              TabBar(tabs: [
                Tab(
                  child: Text("Upcoming",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 19, 13, 200),
                      )),
                ),
                Tab(
                  child: Text("Completed",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 19, 13, 200),
                      )),
                )
              ]),
              Expanded(
                  child: TabBarView(
                children: [
                  //tab 2
                  Container(
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('requests')
                            .where('doctorid', isEqualTo: user!.email)
                            .where('status', isEqualTo: "Upcoming")
                            //.orderBy('date', descending: true)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }

                          return ListView(
                            children: snapshot.data!.docs.map((snap) {
                              return Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Container(
                                  height: 280,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey[900],
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image(
                                                  image: AssetImage(
                                                      'assets/images/dateV.png'),
                                                  height: 22,
                                                  width: 22,
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  snap["prefer_date"]
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image(
                                                  image: AssetImage(
                                                      'assets/images/timeV.png'),
                                                  height: 22,
                                                  width: 22,
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  snap['prefer_time'],
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                        content: Container(
                                                            height: 250,
                                                            child: Column(
                                                              children: [
                                                                Text("Pet: " +
                                                                    snap['pet_type']
                                                                        .toString()),
                                                                SizedBox(
                                                                    height: 10),
                                                                Text("Breed: " +
                                                                    snap['breed']
                                                                        .toString()),
                                                                SizedBox(
                                                                    height: 10),
                                                                Text("Height: " +
                                                                    snap['height']
                                                                        .toString() +
                                                                    " feet"),
                                                                SizedBox(
                                                                    height: 10),
                                                                Text("Weight: " +
                                                                    snap['weight']
                                                                        .toString() +
                                                                    " kg"),
                                                                SizedBox(
                                                                    height: 10),
                                                                Text("Age: " +
                                                                    snap['age']
                                                                        .toString() +
                                                                    ' years'),
                                                                SizedBox(
                                                                    height: 10),
                                                                Text("Gender: " +
                                                                    snap['gender']
                                                                        .toString()),
                                                                SizedBox(
                                                                    height: 10),
                                                                ElevatedButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          context,
                                                                          true), // passing true
                                                                  child: Text(
                                                                      'Ok'),
                                                                ),
                                                              ],
                                                            )));
                                                  },
                                                );
                                              },
                                              child: Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    Image(
                                                      image: AssetImage(
                                                          'assets/images/details.png'),
                                                      height: 22,
                                                      width: 22,
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text('Pet Details',
                                                        style: TextStyle(
                                                            fontSize: 14.0,
                                                            color:
                                                                Colors.white)),
                                                  ],
                                                ),
                                              ))),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image(
                                              image: AssetImage(
                                                  'assets/images/veterinary.png'),
                                              height: 22,
                                              width: 22,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              snap["username"],
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.deepPurple,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 40, vertical: 10),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              // Create the SelectionScreen in the next step.
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const AgoraCall()),
                                            );
                                          },
                                          child: Text(
                                            "Start Video Call",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.deepPurple,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 40, vertical: 10),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              // Create the SelectionScreen in the next step.
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DoctorPrescribe(
                                                        appointmentid: snap.id,
                                                      )),
                                            );
                                          },
                                          child: Text(
                                            "Prescribe",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }),
                  ),
                  //tab 3
                  Container(
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('requests')
                            .where('doctorid', isEqualTo: user!.email)
                            .where('status', isEqualTo: "Completed")
                            //.orderBy('date', descending: true)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }

                          return ListView(
                            children: snapshot.data!.docs.map((snap) {
                              return Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey[900],
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image(
                                                  image: AssetImage(
                                                      'assets/images/dateV.png'),
                                                  height: 22,
                                                  width: 22,
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  snap["prefer_date"]
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image(
                                                  image: AssetImage(
                                                      'assets/images/timeV.png'),
                                                  height: 22,
                                                  width: 22,
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  snap['prefer_time'],
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                        content: Container(
                                                            height: 250,
                                                            child: Column(
                                                              children: [
                                                                Text("Pet: " +
                                                                    snap['pet_type']
                                                                        .toString()),
                                                                SizedBox(
                                                                    height: 10),
                                                                Text("Breed: " +
                                                                    snap['breed']
                                                                        .toString()),
                                                                SizedBox(
                                                                    height: 10),
                                                                Text("Height: " +
                                                                    snap['height']
                                                                        .toString() +
                                                                    " feet"),
                                                                SizedBox(
                                                                    height: 10),
                                                                Text("Weight: " +
                                                                    snap['weight']
                                                                        .toString() +
                                                                    " kg"),
                                                                SizedBox(
                                                                    height: 10),
                                                                Text("Age: " +
                                                                    snap['age']
                                                                        .toString() +
                                                                    ' years'),
                                                                SizedBox(
                                                                    height: 10),
                                                                Text("Gender: " +
                                                                    snap['gender']
                                                                        .toString()),
                                                                SizedBox(
                                                                    height: 10),
                                                                ElevatedButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          context,
                                                                          true), // passing true
                                                                  child: Text(
                                                                      'Ok'),
                                                                ),
                                                              ],
                                                            )));
                                                  },
                                                );
                                              },
                                              child: Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    Image(
                                                      image: AssetImage(
                                                          'assets/images/details.png'),
                                                      height: 22,
                                                      width: 22,
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text('Pet Details',
                                                        style: TextStyle(
                                                            fontSize: 14.0,
                                                            color:
                                                                Colors.white)),
                                                  ],
                                                ),
                                              ))),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image(
                                              image: AssetImage(
                                                  'assets/images/veterinary.png'),
                                              height: 22,
                                              width: 22,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              snap["username"],
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }),
                  ),
                ],
              ))
            ],
          )),
        ));
  }
}
