import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:lambox_pharm/models/form_data.dart';

class Prescription extends StatefulWidget {
  final String docId;
  Prescription(this.docId);
  @override
  _PrescriptionState createState() => _PrescriptionState();
}

class _PrescriptionState extends State<Prescription> {
  bool getPillsFromFirebase = false;
  String pillA;
  String pillB;

  var pacients;
  var client;

  @override
  void initState() {
    super.initState();
    getPills();
  }

  void getPills() async {
    await Firebase.initializeApp();
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    var pacientsFromFirebase = await _firestore
        .collection("Pharmacies")
        .doc(context.read<FormData>().loggedUserInfo["docId"])
        .collection("clientes")
        .doc(widget.docId)
        .get();
    client = pacientsFromFirebase.data();
    setState(() {
      getPillsFromFirebase = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text('Remédios'),
          primary: false,
        ),
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: SizedBox(
                height: 100,
                width: 100,
                child: Image.asset('assets/lamboxCords.png'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Selecione o remédio colocado em cada compartimento da LamBox:',
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, left: 20),
              child: Text(
                'Compartimento A',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (getPillsFromFirebase)
              RadioListTile(
                activeColor: Colors.teal,
                title: Text(client['pill1']),
                value: 'pill1',
                groupValue: pillA,
                onChanged: (value) {
                  setState(() {
                    pillA = value;
                  });
                },
              ),
            if (!getPillsFromFirebase) CircularProgressIndicator(),
            if (getPillsFromFirebase)
              RadioListTile(
                title: Text(client['pill2']),
                activeColor: Colors.teal,
                value: 'pill2',
                groupValue: pillA,
                onChanged: (value) {
                  setState(() {
                    pillA = value;
                  });
                },
              ),
            Padding(
              padding: EdgeInsets.only(top: 10, left: 20),
              child: Text(
                'Compartimento B',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (getPillsFromFirebase)
              RadioListTile(
                activeColor: Colors.teal,
                title: Text(client['pill1']),
                value: 'pill1',
                groupValue: pillB,
                onChanged: (value) {
                  setState(() {
                    pillB = value;
                  });
                },
              ),
            if (!getPillsFromFirebase) CircularProgressIndicator(),
            if (getPillsFromFirebase)
              RadioListTile(
                title: Text(client['pill2']),
                activeColor: Colors.teal,
                value: 'pill2',
                groupValue: pillB,
                onChanged: (value) {
                  setState(() {
                    pillB = value;
                  });
                },
              ),
            Padding(
              padding: EdgeInsets.only(top: 15, right: 10, left: 10),
              child: FlatButton(
                color: Colors.teal,
                child: Text(
                  'Enviar',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () async {
                  await Firebase.initializeApp();
                  final FirebaseFirestore _firestore =
                      FirebaseFirestore.instance;
                  var pacientsFromFirebase = await _firestore
                      .collection("Pharmacies")
                      .doc(context.read<FormData>().loggedUserInfo["docId"])
                      .collection("clientes")
                      .doc(widget.docId)
                      .set(
                    {
                      'gateA': pillA,
                      'gateB': pillB,
                    },
                    SetOptions(merge: true),
                  );
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
