import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:women_safety_final_project/child/Dashboard.dart';
import 'package:women_safety_final_project/components/custom_textfield.dart';
import 'package:women_safety_final_project/child/register_child.dart';
import 'package:women_safety_final_project/db/shared_pref.dart';
import 'package:women_safety_final_project/child/bottom_screens/child_home_page.dart';
import 'package:women_safety_final_project/parent/parent_home_screen.dart';
import 'package:women_safety_final_project/utils/constants.dart';
import '../components/PrimaryButton.dart';
import '../components/SecondaryButton.dart';
import '../parent/parent_register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPasswordShown = true;
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool isLoading = false;

  _onSubmit() async {
    _formKey.currentState!.save();
    try {
      setState(() {
        isLoading = true;
      });
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _formData['c_email'].toString().trim(),
        password: _formData['password'].toString().trim(),
      );
      if (userCredential.user != null) {
        setState(() {
          isLoading = false;
        });
        FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get()
            .then(((value) {
          if (value['type'] == 'parent') {
            print(value['type']);
            MySharedPreference.saveUserType('parent');
            goTo(context, ParentHomeScreen());
          } else {
            MySharedPreference.saveUserType('child');
            goTo(context, Dashboard());
          }
        }));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e.code == 'user-not-found') {
        dialogBox(context, 'No user found for that email.');
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        dialogBox(context, 'Wrong password provided for that user.');
        print('Wrong password provided for that user.');
      }
    }
    print(_formData['c_email']);
    print(_formData['password']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              isLoading
                  ? progressIndicator(context)
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Text(
                                //   "User Login",
                                //   style: TextStyle(
                                //       fontSize: 40,
                                //       color: primaryColor,
                                //       fontWeight: FontWeight.bold),
                                // ),
                                Image.asset(
                                  'assets/images/Logo_graphic.png',
                                  height: 200,
                                  width: 200,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomTextField(
                                    hintText: 'Enter Email',
                                    textInputAction: TextInputAction.next,
                                    keyboardtype: TextInputType.emailAddress,
                                    prefix: Icon(Icons.person),
                                    onsave: (email) {
                                      _formData['c_email'] = email ?? "";
                                    },
                                    validate: (email) {
                                      if (email!.isEmpty ||
                                          email.length < 3 ||
                                          !email.contains("@")) {
                                        return "Enter Correct Email";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  CustomTextField(
                                    hintText: 'Enter Password',
                                    isPassword: isPasswordShown,
                                    onsave: (password) {
                                      _formData['password'] = password ?? "";
                                    },
                                    validate: (password) {
                                      if (password!.isEmpty ||
                                          password.length < 4) {
                                        return "Enter Correct Password";
                                      } else {
                                        return null;
                                      }
                                    },
                                    prefix: Icon(Icons.vpn_key_rounded),
                                    suffix: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            isPasswordShown = !isPasswordShown;
                                          });
                                        },
                                        icon: isPasswordShown
                                            ? Icon(Icons.visibility_off)
                                            : Icon(Icons.visibility)),
                                  ),
                                  PrimaryButton(
                                    title: "Login",
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        _onSubmit();
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Forgot Password ?",
                                  style: TextStyle(fontSize: 18),
                                ),
                                SecondaryButton(
                                  title: "Click Here",
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                          SecondaryButton(
                            title: "Register as Child",
                            onPressed: () {
                              goTo(context, RegisterChildScreen());
                            },
                          ),
                          SecondaryButton(
                            title: "Register as Parent",
                            onPressed: () {
                              goTo(context, RegisterParentScreen());
                            },
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
