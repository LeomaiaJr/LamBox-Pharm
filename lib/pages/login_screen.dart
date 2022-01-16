import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:lambox_pharm/pages/home_screen.dart';
import 'package:lambox_pharm/pages/register_screen.dart';
import 'package:provider/provider.dart';
import 'package:lambox_pharm/models/form_data.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool logging = false;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: ModalProgressHUD(
        inAsyncCall: logging,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: height / 12,
              ),
              Container(
                child: Hero(
                  tag: 'lamboxLogo',
                  child: Image.asset(
                    'assets/lamboxpharm.png',
                    height: height / 4,
                  ),
                ),
              ),
              Expanded(
                child: ClipPath(
                  clipper: WaveClipperOne(reverse: true),
                  child: Container(
                    color: Colors.teal,
                    child: Column(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(left: 30, right: 30, top: 100),
                          child: LamBoxLoginForm(
                            obscureText: false,
                            keyboardType: TextInputType.emailAddress,
                            textType: 'E-mail',
                            iconType: Icons.person,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 30, right: 30, top: 20, bottom: 20),
                          child: LamBoxLoginForm(
                            obscureText: true,
                            keyboardType: TextInputType.text,
                            textType: 'Senha',
                            iconType: Icons.lock,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 100,
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        RegisterScreen(height),
                                  ),
                                );
                              },
                              child: Text(
                                "Registrar",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            FlatButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(20.0),
                              ),
                              color: Colors.white,
                              onPressed: () async {
                                context.read<FormData>().verifyLogin();
                                if (!context.read<FormData>().loginVerifier) {
                                  return Alert(
                                    context: context,
                                    type: AlertType.error,
                                    title: "Erro!",
                                    desc:
                                        "Complete todos os campos com informações válidas",
                                    buttons: [
                                      DialogButton(
                                        child: Text(
                                          "OK",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                        width: 120,
                                      )
                                    ],
                                  ).show();
                                } else {
                                  setState(() {
                                    logging = true;
                                  });
                                  await Firebase.initializeApp();
                                  String email = context
                                      .read<FormData>()
                                      .loginCredentials[0];
                                  String password = context
                                      .read<FormData>()
                                      .loginCredentials[1];
                                  final _auth = FirebaseAuth.instance;
                                  var loggedUser =
                                      await _auth.signInWithEmailAndPassword(
                                    email: email,
                                    password: password,
                                  );
                                  print('testesadasdas');
                                  if (loggedUser != null) {
                                    var id = _auth.currentUser.uid;
                                    final FirebaseFirestore _firestore =
                                        FirebaseFirestore.instance;
                                    var data = await _firestore
                                        .collection('Pharmacies')
                                        .where('id', isEqualTo: id)
                                        .get();
                                    var userInfo = data.docs.single.data();
                                    var documentId = data.docs.single.id;
                                    context.read<FormData>().updateMap({
                                      "name": userInfo['name'],
                                      "street": userInfo['street'],
                                      "phoneNumber": userInfo['phoneNumber'],
                                      "city": userInfo['city'],
                                      "id": userInfo['id'],
                                      "docId": documentId,
                                    });
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              HomeScreen()),
                                      (Route<dynamic> route) => false,
                                    );
                                  }
                                }
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LamBoxLoginForm extends StatefulWidget {
  LamBoxLoginForm({
    this.iconType,
    this.textType,
    this.obscureText,
    this.keyboardType,
  });

  final IconData iconType;
  final String textType;
  final bool obscureText;
  final TextInputType keyboardType;

  @override
  _LamBoxLoginFormState createState() => _LamBoxLoginFormState();
}

class _LamBoxLoginFormState extends State<LamBoxLoginForm> {
  FocusNode _focusNode = FocusNode();
  bool _focus = false;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _focus = !_focus;
      });
    });
    context.read<FormData>().addLoginFormController(controller);
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: widget.obscureText,
      style: TextStyle(color: !_focus ? Color(0xff004d40) : Colors.white),
      keyboardType: widget.keyboardType,
      focusNode: _focusNode,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Color(0xff004d40),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        labelText: widget.textType,
        labelStyle:
            TextStyle(color: !_focus ? Color(0xff004d40) : Colors.white),
        icon: Icon(widget.iconType,
            color: !_focus ? Color(0xff004d40) : Colors.white),
      ),
    );
  }
}
