import 'package:flutter/material.dart';

import 'emergencies/AmbulenceEmergency.dart';
import 'emergencies/FireBrigadeEmergency.dart';
import 'emergencies/WomenHelplineEmergency.dart';
import 'emergencies/policeemergency.dart';

class Emergency extends StatelessWidget {
  const Emergency({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 180,
      child: ListView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          PoliceEmergency(),
          WomenHelplineEmergency(),
          AmbulenceEmergency(),
          FireBrigadeEmergency(),
        ],
      ),
    );
  }
}
