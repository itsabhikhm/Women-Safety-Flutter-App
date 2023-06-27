import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home_widgets/live_safe/BusStationCard.dart';
import 'home_widgets/live_safe/HospitalCard.dart';
import 'home_widgets/live_safe/PharmacyCard.dart';
import 'home_widgets/live_safe/PoliceStationCard.dart';

class LiveSafe extends StatelessWidget {
  const LiveSafe({super.key});

  static Future<void> openMap(String location) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$location';

    try {
      await launch(googleUrl);
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'something went wrong! call emergency number');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Container(
        height: 90,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          children: [
            PoliceStationCard(onMapFunction: openMap),
            HospitalCard(onMapFunction: openMap),
            PharmacyCard(onMapFunction: openMap),
            BusStationCard(onMapFunction: openMap),
          ],
        ),
      ),
    );
  }
}
