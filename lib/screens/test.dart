// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, no_leading_underscores_for_local_identifiers, unused_element, unused_local_variable, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:veta/constants.dart';
import 'package:veta/screens/mobile_body.dart';

class UserAppointment extends StatefulWidget {
  const UserAppointment({super.key});

  @override
  State<UserAppointment> createState() => _UserAppointmentState();
}

class _UserAppointmentState extends State<UserAppointment> {
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
                    return MobileScaffold();
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
                    return UserAppointment();
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
                  await FirebaseAuth.instance.signOut();
                  //Phoenix.rebirth(context);
                },
              ),
            )
          ]),
        ),
        body: DefaultTabController(
          length: 3,
          child: Scaffold(
              body: Column(
            children: [
              TabBar(tabs: [
                Tab(
                  child: Text("Pending Appointments",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 19, 13, 200),
                      )),
                ),
                Tab(
                  child: Text("Upcoming Appointments",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 19, 13, 200),
                      )),
                ),
                Tab(
                  child: Text("Completed Appointments",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 19, 13, 200),
                      )),
                )
              ]),
              Expanded(
                  child: TabBarView(
                children: [
                  //tab 1
                  Container(
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('requests')
                            .where('useremail', isEqualTo: user!.email)
                            .where('status', isEqualTo: "Pending")
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
                                  height: 300,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Color.fromARGB(255, 62, 20, 211),
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Your prefer date: " +
                                              snap["date"].toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Your prefer time: " + snap['time'],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                          ),
                                        ),
                                      ),
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
                                                                Text("Height: " +
                                                                    snap['height']
                                                                        .toString()),
                                                                SizedBox(
                                                                    height: 10),
                                                                Text("Weight: " +
                                                                    snap['weight']
                                                                        .toString()),
                                                                SizedBox(
                                                                    height: 10),
                                                                Text("Age: " +
                                                                    snap['age']
                                                                        .toString()),
                                                                SizedBox(
                                                                    height: 10),
                                                                Text("Gender: " +
                                                                    snap['gender']
                                                                        .toString()),
                                                                SizedBox(
                                                                    height: 10),
                                                              ],
                                                            )));
                                                  },
                                                );
                                              },
                                              child: Center(
                                                child: Text('Pet Details',
                                                    style: TextStyle(
                                                        fontSize: 24.0,
                                                        color: Colors.white)),
                                              ))),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Appointment Status: " +
                                              snap['status'].toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
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
                  //tab 2
                  Container(
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('requests')
                            .where('useremail', isEqualTo: user!.email)
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
                                  height: 300,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Color.fromARGB(255, 62, 20, 211),
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Your prefer date: " +
                                              snap["date"].toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Your prefer time: " + snap['time'],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                          ),
                                        ),
                                      ),
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
                                                                Text("Height: " +
                                                                    snap['height']
                                                                        .toString()),
                                                                SizedBox(
                                                                    height: 10),
                                                                Text("Weight: " +
                                                                    snap['weight']
                                                                        .toString()),
                                                                SizedBox(
                                                                    height: 10),
                                                                Text("Age: " +
                                                                    snap['age']
                                                                        .toString()),
                                                                SizedBox(
                                                                    height: 10),
                                                                Text("Gender: " +
                                                                    snap['gender']
                                                                        .toString()),
                                                                SizedBox(
                                                                    height: 10),
                                                              ],
                                                            )));
                                                  },
                                                );
                                              },
                                              child: Center(
                                                child: Text('Pet Details',
                                                    style: TextStyle(
                                                        fontSize: 24.0,
                                                        color: Colors.white)),
                                              ))),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Appointment Status: " +
                                              snap['status'].toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
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
                            .where('useremail', isEqualTo: user!.email)
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
                                  height: 300,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Color.fromARGB(255, 62, 20, 211),
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Your prefer date: " +
                                              snap["date"].toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Your prefer time: " + snap['time'],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                          ),
                                        ),
                                      ),
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
                                                                Text("Height: " +
                                                                    snap['height']
                                                                        .toString()),
                                                                SizedBox(
                                                                    height: 10),
                                                                Text("Weight: " +
                                                                    snap['weight']
                                                                        .toString()),
                                                                SizedBox(
                                                                    height: 10),
                                                                Text("Age: " +
                                                                    snap['age']
                                                                        .toString()),
                                                                SizedBox(
                                                                    height: 10),
                                                                Text("Gender: " +
                                                                    snap['gender']
                                                                        .toString()),
                                                                SizedBox(
                                                                    height: 10),
                                                              ],
                                                            )));
                                                  },
                                                );
                                              },
                                              child: Center(
                                                child: Text('Pet Details',
                                                    style: TextStyle(
                                                        fontSize: 24.0,
                                                        color: Colors.white)),
                                              ))),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Appointment Status: " +
                                              snap['status'].toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
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
                ],
              ))
            ],
          )),
        ));
  }
}
