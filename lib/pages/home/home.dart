import 'package:event_booking_app/pages/home/fragment/event-fragment.dart';
import 'package:event_booking_app/pages/home/fragment/iconbar-fragment.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String location = "Loading...";

  @override
  void initState() {
    super.initState();
    _getLastKnownLocation();
  }

  Future<void> _getLastKnownLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Mengecek layanan lokasi
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          location = "Location services are disabled";
        });
        return;
      }

      // Mengecek izin akses lokasi
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            location = "Location permissions are denied";
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          location = "Location permissions are permanently denied";
        });
        return;
      }

      // Mengambil lokasi terakhir yang diketahui
      Position? position = await Geolocator.getLastKnownPosition();
      if (position != null) {
        await _getAddressFromLatLong(position.latitude, position.longitude);
      } else {
        setState(() {
          location = "No last known location found";
        });
      }
    } catch (e) {
      setState(() {
        location = "Error: $e";
      });
    }
  }

  Future<void> _getAddressFromLatLong(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];

      setState(() {
        location =
            "${place.locality}, ${place.country}"; // Contoh: Jakarta, Indonesia
      });
    } catch (e) {
      setState(() {
        location = "Failed to get address";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double widthQ = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20),
            width: widthQ,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xffe3e6ff),
                  Color(0xfff1f3ff),
                  Colors.white,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                    ),
                    Text(
                      location,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, User',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'There are 300+ event\naround your location',
                      style: TextStyle(
                        color: Color(0xff6351ec),
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(left: 10, top: 5),
                  width: widthQ,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search an event',
                      suffixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconBarFragment(
                        imagePath: "assets/images/music.png",
                        text: "Music",
                        onPressed: () {}),
                    IconBarFragment(
                        imagePath: "assets/images/music.png",
                        text: "Clothing",
                        onPressed: () {}),
                    IconBarFragment(
                        imagePath: "assets/images/music.png",
                        text: "Festival",
                        onPressed: () {}),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Upcoming Events',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        'See All',
                        style: TextStyle(
                          color: Color(0xff6351ec),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                //event list
                Column(
                  children: [
                ListView.builder(
                  itemCount: 3,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Eventfragment(
                            onPressed: () {},
                            imageEvent: 'assets/images/event.jpg',
                            textDate: 'Aug\n24',
                            textName: 'Dua Lipa',
                                textLocation: 'Jakarta, Indonesia',
                            textPrice: 'Rp. 1.000.000',
                          ),
                        ),
                            SizedBox(
                              height: 10,
                            ),
                      ],
                    );
                  },
                ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
