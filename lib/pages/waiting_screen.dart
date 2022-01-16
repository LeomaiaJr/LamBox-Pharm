import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lambox_pharm/models/form_data.dart';
import 'package:lambox_pharm/pages/register_email.dart';
import 'package:lambox_pharm/widgets/animated_icons.dart';

import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

class WaitingScreen extends StatefulWidget {
  @override
  _WaitingScreenState createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  var registrationUserData = [];
  String userRegistrationState = "Fazendo cadastro...";
  String userId;

  int changesNumber = 0;

  bool registration = false;

  void waitTime() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      userRegistrationState = "Esperando aprovação da Equipe Lambox...";
    });
    listenAprovation();
  }

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < 5; i++) {
      var registrationData = context.read<FormData>().registrationFormItems[i];
      registrationUserData.add(registrationData);
    }
    print(registrationUserData);
    registerUserInFirebase();
  }

  void listenAprovation() {
    var userQuery = FirebaseFirestore.instance
        .collection('newPharmacies')
        .where('name', isEqualTo: registrationUserData[0])
        .limit(1);
    StreamSubscription subscription;

    subscription = userQuery.snapshots().listen((data) {
      data.docChanges.forEach((change) {
        changesNumber++;
        print(changesNumber);
        if (changesNumber > 1) {
          subscription.cancel();
          deleteUserDocument();
        }
      });
    });
  }

  void deleteUserDocument() async {
    setState(() {
      userRegistrationState = "Cadastro Aprovado!";
    });
    await FirebaseFirestore.instance
        .collection("newPharmacies")
        .doc(userId)
        .delete();
    print(registrationUserData);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterEmail(),
      ),
    );
  }

  void registerUserInFirebase() async {
    await Firebase.initializeApp();
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    userId = _firestore.collection("newPharmacies").doc().id.toString();
    _firestore.collection("newPharmacies").doc(userId).set({
      "name": registrationUserData[0],
      "phoneNumber": registrationUserData[1],
      "street": registrationUserData[2],
      "city": registrationUserData[3],
      "approved": false,
    }).then((value) {
      setState(() {
        userRegistrationState = "Cadastro feito com sucesso!";
        registration = true;
      });
      waitTime();
    }).catchError((err) {
      print(err);
      setState(() {
        userRegistrationState = "Erro ao realizar o cadastro, tente novamente!";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: height / 4,
            child: LoadingPage(),
          ),
          SizedBox(
            height: 140,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  userRegistrationState,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 30),
                SpinKitThreeBounce(
                  itemBuilder: (BuildContext context, int index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                          color: index.isEven ? Colors.teal : Colors.green,
                          shape: BoxShape.circle),
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
