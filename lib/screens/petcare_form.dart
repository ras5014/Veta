import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:veta/constants.dart';

import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:intl/intl.dart'; // For Calendor

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:veta/constants.dart';
import 'package:geocoding/geocoding.dart' as geoCoding;

class PetCareForm extends StatefulWidget {
  const PetCareForm({Key? key}) : super(key: key);

  @override
  State<PetCareForm> createState() => _PetCareFormState();
}

class _PetCareFormState extends State<PetCareForm> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  late GoogleMapController newGoogleMapController;
  final Set<Polyline> _polyLine = {};

  Position? currentPosition;
  var geolocator = Geolocator();
  double bottomPaddingofMap = 0;

  late LatLng destination;
  late LatLng source;

  Set<Marker> markers = {};
  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLatPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        new CameraPosition(target: latLatPosition, zoom: 14);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Future<String> showGoogleAutoComplete() async {
    const kGoogleApiKey = "AIzaSyCGdkjJ8ZIZzupMHqv-OoeD9n3PY4WQnP4";

    Prediction? p = await PlacesAutocomplete.show(
      offset: 0,
      radius: 1000,
      strictbounds: false,
      region: "in",
      language: "en",
      context: context,
      mode: Mode.overlay,
      apiKey: kGoogleApiKey,
      types: ["(cities)"],
      hint: "Search City",
      components: [new Component(Component.country, "in")],
    );
    return p!.description!;
  }

  void drawPolyLine(String placeId) {
    _polyLine.clear();
    _polyLine.add(Polyline(
      polylineId: PolylineId(placeId),
      visible: true,
      points: [source, destination],
      color: Colors.purple,
      width: 5,
    ));
  }

  TextEditingController dateInput = TextEditingController();
  TextEditingController address = TextEditingController();

  final _formDateKey = GlobalKey<FormState>();
  final _formAddressKey = GlobalKey<FormState>();
  final _formPetKey = GlobalKey<FormState>();
  final _formOptionKey = GlobalKey<FormState>();

  final List<String> pet = [
    'Dog',
    'Cat',
    'Horse',
    'Cow',
    'Buffelow',
    'Bird',
    'Goat'
  ];
  final List<String> option = [
    'Grooming',
    'Training',
  ];

  String? selectedPet;
  String? selectedOption;

  DateTime _datetime = DateTime.now();
  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    ).then((value) {
      setState(() {
        _datetime = value!;
        dateInput.text = DateFormat('yyyy-MM-dd').format(_datetime);
      });
    });
  }

  Future book() async {
    if (_formDateKey.currentState!.validate() &&
        _formPetKey.currentState!.validate() &&
        _formOptionKey.currentState!.validate()) {
      loadSlotRequest();
    }
  }

  Future loadSlotRequest() async {
    await FirebaseFirestore.instance.collection('groomingsandtraining').add({
      'useremail': user!.email,
      'address': address.text.trim(),
      'pet': selectedPet,
      'option': selectedOption,
      'date': "${_datetime.day} / ${_datetime.month} / ${_datetime.year}"
    });
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            content: Container(
                height: 150,
                child: Column(children: [
                  Text(
                    "Your booking request has been sent to our team. We will call you for furthus update",
                  ),
                ])));
      },
    );
    //const Mobil
  }

  @override
  void initState() {
    dateInput.text = "";
    //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text("Booking For Grooming and Training"),
        backgroundColor: Colors.black54, //background color of app bar
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Hello again Message!
                Text(
                  'Welcome',
                  style: GoogleFonts.bebasNeue(
                    fontSize: 52,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Book Your Sllot with your details!',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 25),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Form(
                    key: _formDateKey,
                    child: TextFormField(
                      readOnly: true,
                      controller: dateInput,
                      onTap: _showDatePicker,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'Appointment Date',
                        prefixIcon: Icon(Icons.calendar_month),
                        contentPadding: EdgeInsets.all(20.0),
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                      validator: (fname) {
                        if (fname == null || fname.isEmpty) {
                          return 'Please enter date';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Form(
                    key: _formPetKey,
                    child: DropdownButtonFormField2(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.all(20.0),
                        hintText: 'Select Pet',
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black45,
                      ),
                      buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      items: pet
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        // Do Smoething here
                        setState(() {
                          selectedPet = value.toString();
                        });
                      },
                      onSaved: (value) {
                        selectedPet = value.toString();
                      },
                    ),
                  ),
                ),

                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Form(
                    key: _formOptionKey,
                    child: DropdownButtonFormField2(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.all(20.0),
                        hintText: 'Select Option',
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black45,
                      ),
                      buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      items: option
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        // Do Smoething here
                        setState(() {
                          selectedOption = value.toString();
                        });
                      },
                      onSaved: (value) {
                        selectedOption = value.toString();
                      },
                    ),
                  ),
                ),

                SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Form(
                    //key: ,
                    child: TextFormField(
                      readOnly: true,
                      onTap: () async {
                        String selectedPlace = await showGoogleAutoComplete();
                        address.text = selectedPlace;
                        List<geoCoding.Location> locations =
                            await geoCoding.locationFromAddress(selectedPlace);
                        source = LatLng(locations.first.latitude,
                            locations.first.longitude);
                        setState(() {
                          markers.add(Marker(
                              markerId: MarkerId(selectedPlace),
                              infoWindow: InfoWindow(
                                title: 'Source: $selectedPlace',
                              ),
                              position: source));
                        });
                        newGoogleMapController.animateCamera(
                            CameraUpdate.newCameraPosition(
                                CameraPosition(target: source, zoom: 14)));
                      },
                      controller: address,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'Search source location',
                        prefixIcon: Icon(Icons.search), // Adds Email Icon
                        contentPadding: EdgeInsets.all(12.0),
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: book,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Book',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
