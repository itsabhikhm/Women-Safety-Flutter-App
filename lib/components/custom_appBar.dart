// ignore_for_file: prefer_const_constructors_in_immutables
import 'package:flutter/material.dart';
import 'package:women_safety_final_project/utils/quotes.dart';
import '../child/settings/settingScreen.dart';

class CustomAppBar extends StatelessWidget {
  final Function getRandomInt;
  final int quoteIndex;
  CustomAppBar({Key? key, required this.getRandomInt, required this.quoteIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        sweetSayings[quoteIndex][0],
        style: TextStyle(
          color: Colors.grey[600],
        ),
      ),
      subtitle: GestureDetector(
        onTap: () {
          getRandomInt(true);
        },
        child: Text(
          sweetSayings[quoteIndex][1],
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width * 0.06),
        ),
      ),
      trailing: Card(
        elevation: 4,
        shape: CircleBorder(),
        child: InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SettingsScreen()));
          },
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Image.asset(
              "assets/settings.png",
              height: 24,
            ),
          ),
        ),
      ),
    );
  }
}
