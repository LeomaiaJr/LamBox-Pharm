import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lambox_pharm/pages/prescription_screen.dart';
import 'package:provider/provider.dart';
import 'package:lambox_pharm/models/form_data.dart';
import 'dart:math';

class ClientsScreen extends StatefulWidget {
  @override
  _ClientsScreenState createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  var pacients;
  bool noPacients = false;
  bool getPacientsFromFirebase = false;

  List<Widget> myPacients = [];

  @override
  void initState() {
    super.initState();
    getPacients();
  }

  void getPacients() async {
    await Firebase.initializeApp();
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    var pacientsFromFirebase = await _firestore
        .collection("Pharmacies")
        .doc(context.read<FormData>().loggedUserInfo["docId"])
        .collection("clientes")
        .get();
    pacients = pacientsFromFirebase.docs;
    if (pacients.length == 0) {
      setState(() {
        noPacients = true;
      });
    }
    if (!noPacients) {
      for (var x = 0; x < pacients.length; x++) {
        Random random = Random();
        int randomNumber = random.nextInt(3) + 1;
        print(randomNumber);
        var myPacient = pacients[x].data();
        var docId = pacients[x].id;
        print(docId);
        myPacients.add(
          PacientCard(
            name: myPacient['name'],
            gender: myPacient['gender'],
            pill1: myPacient['pill1'],
            pill2: myPacient['pill2'],
            number: randomNumber,
            docId: docId,
          ),
        );
      }
      setState(() {
        getPacientsFromFirebase = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        toolbarHeight: kToolbarHeight - 20,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Stack(
            overflow: Overflow.visible,
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 0),
                child: Image.asset('assets/pharmacy.jpg'),
              ),
              Positioned(
                top: height / 3.8,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.teal,
                  ),
                  child: Text(
                    "Clientes",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w300),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 20, left: 10, right: 10),
            child: Text(
                'Clique em um paciente para informar aonde os remédios foram colocados na LamBox:'),
          ),
          if (!getPacientsFromFirebase && !noPacients)
            Container(
              alignment: Alignment.bottomCenter,
              height: 100,
              child: CircularProgressIndicator(
                backgroundColor: Colors.teal,
              ),
            ),
          if (getPacientsFromFirebase)
            Expanded(
              child: Theme(
                data: ThemeData(
                  accentColor: Color(0xFFC9E7F2),
                ),
                child: ListView(
                  children: myPacients,
                ),
              ),
            ),
          if (noPacients)
            Container(
              margin: EdgeInsets.only(top: 50),
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  FaIcon(
                    FontAwesomeIcons.frown,
                    color: Colors.grey,
                    size: 80,
                  ),
                  Text(
                    'Você não possui nenhum paciente.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class PacientCard extends StatelessWidget {
  final String docId;
  final String name;
  final String gender;
  final String pill1;
  final String pill2;
  final int number;
  PacientCard({
    this.name,
    this.number,
    this.docId,
    this.pill1,
    this.pill2,
    this.gender,
  });

  Color primaryColor;
  void getColor() {
    if (gender == 'feminino') {
      primaryColor = Colors.amber;
    } else {
      primaryColor = Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    getColor();
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => Prescription(docId),
        );
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: primaryColor),
            borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.only(top: 20, left: 15, right: 15),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: [
            SizedBox(
              height: 80,
              width: 80,
              child: Image.asset("assets/$gender$number.png"),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PacientChip(
                  myColor: primaryColor,
                  size: 3,
                  icon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  size2: 1,
                  text: name,
                ),
                SizedBox(
                  height: 10,
                ),
                PacientChip(
                  myColor: primaryColor,
                  size: 6,
                  icon: Icon(
                    FontAwesomeIcons.venusMars,
                    color: Colors.white,
                    size: 22,
                  ),
                  text: gender,
                  size2: 3,
                ),
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PacientChip(
                  myColor: primaryColor,
                  text: pill1,
                  icon: Icon(
                    FontAwesomeIcons.pills,
                    color: Colors.white,
                    size: 22,
                  ),
                  size: 8,
                  size2: 6,
                ),
                SizedBox(
                  height: 10,
                ),
                PacientChip(
                  myColor: primaryColor,
                  size: 8,
                  icon: Icon(
                    FontAwesomeIcons.pills,
                    color: Colors.white,
                    size: 22,
                  ),
                  text: pill2,
                  size2: 6,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PacientChip extends StatelessWidget {
  final String text;
  final Icon icon;
  final double size;
  final double size2;
  final Color myColor;
  const PacientChip({
    this.text,
    this.icon,
    this.size,
    this.size2,
    this.myColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: myColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: size, left: size2),
            child: icon,
          ),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
