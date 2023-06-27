import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:women_safety_final_project/child/child_login_screen.dart';
import 'package:women_safety_final_project/model/user_model.dart';
import '../components/PrimaryButton.dart';
import '../components/SecondaryButton.dart';
import '../components/custom_textfield.dart';
import '../utils/constants.dart';

class RegisterChildScreen extends StatefulWidget {
  @override
  State<RegisterChildScreen> createState() => _RegisterChildScreenState();
}

class _RegisterChildScreenState extends State<RegisterChildScreen> {
  bool isPasswordShown = true;
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  final _formData = Map<String, Object>();

  _onSubmit() async {
    _formKey.currentState!.save();
    if (_formData['password'] != _formData['r_password']) {
      dialogBox(context, 'password and retype password should be equal');
    } else {
      progressIndicator(context);
      try {
        setState(() {
          isLoading = true;
        });
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _formData['c_email'].toString(),
                password: _formData['password'].toString());
        if (userCredential.user != null) {
          setState(() {
            isLoading = true;
          });
          final v = userCredential.user!.uid;
          DocumentReference<Map<String, dynamic>> db =
              FirebaseFirestore.instance.collection('users').doc(v);

          final user = UserModel(
            name: _formData['name'].toString(),
            phone: _formData['phone'].toString(),
            childEmail: _formData['c_email'].toString(),
            parentEmail: _formData['g_email'].toString(),
            id: v,
            type: 'child',
          );
          final jsonData = user.toJson();
          await db.set(jsonData).whenComplete(() {
            goTo(context, LoginScreen());
            setState(() {
              isLoading = false;
            });
          });
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
          dialogBox(context, 'The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
          dialogBox(context, 'The account already exists for that email.');
        }
        setState(() {
          isLoading = false;
        });
      } catch (e) {
        print(e);
        setState(() {
          isLoading = false;
        });
        dialogBox(context, e.toString());
      }
    }
    // print(_formData['email']);
    // print(_formData['password']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Stack(
            children: [
              isLoading
                  ? progressIndicator(context)
                  : SingleChildScrollView(
                      child: Column(children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Register As Child",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 40,
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              Image.asset(
                                'assets/images/Logo_graphic.png',
                                height: 150,
                                width: 150,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.75,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomTextField(
                                  hintText: 'Enter Name',
                                  textInputAction: TextInputAction.next,
                                  keyboardtype: TextInputType.name,
                                  prefix: Icon(Icons.person),
                                  onsave: (name) {
                                    _formData['name'] = name ?? "";
                                  },
                                  validate: (name) {
                                    if (name!.isEmpty || name.length < 3) {
                                      return "Enter Correct Name";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                CustomTextField(
                                  hintText: 'Enter Phone',
                                  textInputAction: TextInputAction.next,
                                  keyboardtype: TextInputType.phone,
                                  prefix: Icon(Icons.phone),
                                  onsave: (phone) {
                                    _formData['phone'] = phone ?? "";
                                  },
                                  validate: (phone) {
                                    if (phone!.isEmpty || phone.length < 10) {
                                      return "Enter Correct Phone";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
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
                                  hintText: 'Enter Guardian Email',
                                  textInputAction: TextInputAction.next,
                                  keyboardtype: TextInputType.emailAddress,
                                  prefix: Icon(Icons.person),
                                  onsave: (g_email) {
                                    _formData['g_email'] = g_email ?? "";
                                  },
                                  validate: (g_email) {
                                    if (g_email!.isEmpty ||
                                        g_email.length < 3 ||
                                        !g_email.contains("@")) {
                                      return "Enter Correct Guardian Email";
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
                                CustomTextField(
                                  hintText: 'Retype Password',
                                  isPassword: isPasswordShown,
                                  onsave: (password) {
                                    _formData['r_password'] = password ?? "";
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
                                  title: "Register",
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
                        SecondaryButton(
                          title: "Login with your account",
                          onPressed: () {
                            goTo(context, LoginScreen());
                          },
                        ),
                      ]),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
