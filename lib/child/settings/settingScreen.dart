import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:women_safety_final_project/child/bottom_screens/profile_page.dart';
import 'package:women_safety_final_project/child/child_login_screen.dart';
import 'package:women_safety_final_project/components/About.dart';
import 'package:women_safety_final_project/components/ChangePin.dart';
import 'package:women_safety_final_project/utils/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool switchValue = false;
  Future<int> checkPIN() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int pin = (prefs.getInt('pin') ?? -1111);
    print('User $pin .');
    return pin;
  }

  @override
  void initState() {
    super.initState();
    checkService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFCFE),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              "Settings",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.w900),
            ),
          ),
          FutureBuilder(
              future: checkPIN(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChangePinScreen(pin: snapshot.data!),
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      child: Center(
                        child: Image.asset("assets/pin.png"),
                      ),
                    ),
                    title: Text(snapshot.data == -1111
                        ? "Create SOS pin"
                        : "Change SOS pin"),
                    subtitle:
                        Text("SOS PIN is required to switch OFF the SOS alert"),
                    trailing: CircleAvatar(
                      radius: 7,
                      backgroundColor:
                          snapshot.data == -1111 ? Colors.red : Colors.white,
                      child: Center(
                        child: Card(
                            color: snapshot.data == -1111
                                ? Colors.orange
                                : Colors.white,
                            shape: CircleBorder(),
                            child: SizedBox(
                              height: 5,
                              width: 5,
                            )),
                      ),
                    ),
                  );
                } else {
                  return SizedBox();
                }
              }),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Notifications",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Expanded(child: Divider())
            ],
          ),
          SwitchListTile(
            onChanged: (val) {
              setState(() {
                switchValue = val;
                // controllSafeShake(val);
              });
            },
            value: switchValue,
            secondary: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: Center(
                  child: Image.asset(
                "assets/shake.png",
                height: 24,
              )),
            ),
            title: Text("Safe Shake"),
            subtitle: Text("Switch ON to listen for device shake"),
          ),
          Divider(
            indent: 40,
            endIndent: 40,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Application",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Expanded(child: Divider())
            ],
          ),
          ListTile(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfilePage()));
            },
            title: Text("Edit Profile"),
            leading: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: Center(
                  child: Image.asset(
                "assets/Profile.png",
                height: 24,
              )),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AboutUs()));
            },
            title: Text("About Us"),
            leading: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: Center(
                  child: Image.asset(
                "assets/info.png",
                height: 24,
              )),
            ),
          ),
          ListTile(
            onTap: () async {
              try {
                await FirebaseAuth.instance.signOut();
                goTo(context, LoginScreen());
              } on FirebaseAuthException catch (e) {
                dialogBox(context, e.toString());
              }
            },
            title: Text("Log Out"),
            leading: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: Center(
                  child: Image.asset(
                "assets/logout.png",
                height: 24,
              )),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> checkService() async {
    bool running = await FlutterBackgroundService().isServiceRunning();
    setState(() {
      switchValue = running;
    });

    return running;
  }

  void controllSafeShake(bool val) async {
    if (val) {
      FlutterBackgroundService.initialize(onStart);
    } else {
      FlutterBackgroundService().sendData(
        {"action": "stopService"},
      );
  //
}
  }