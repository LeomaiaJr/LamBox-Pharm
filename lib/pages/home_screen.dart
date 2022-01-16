import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lambox_pharm/pages/clients_screen.dart';
import 'package:lambox_pharm/pages/help_screen.dart';
import 'package:provider/provider.dart';
import 'package:lambox_pharm/models/form_data.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var userInfo;
  @override
  void initState() {
    super.initState();
    userInfo = Map.of(context.read<FormData>().loggedUserInfo);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(AssetImage('assets/docQuestion.jpg'), context);
    precacheImage(AssetImage('assets/pharmacy.jpg'), context);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print(width);
    print(height);
    return Scaffold(
      body: SafeArea(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.3, 1],
              colors: [Colors.white, Colors.teal[300]],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      height: width < 400 ? 100 : 70,
                      width: 100,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: ExactAssetImage("assets/pharm.jpg"),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: width / 1.9,
                          child: Text(
                            "Olá,",
                            style: TextStyle(fontSize: 22),
                          ),
                        ),
                        SizedBox(
                          width: width / 1.9,
                          child: Text(
                            userInfo["name"] + "!",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 50),
                      child: Image.asset(
                        "assets/lamboxpharm.png",
                        height: 40,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 20, left: 20, top: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xFF76A6D7),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Column(
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            "Bem-vindo ao LamBox!",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 15),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: SizedBox(
                              width: width / 2.2,
                              child: Text(
                                "Se precisar de qualquer ajuda vá em ajuda para entrar em contato conosco.",
                                style: TextStyle(
                                  textBaseline: TextBaseline.alphabetic,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      "assets/doctors.jpg",
                      height: height > 400 ? height / 5.5 : height / 6.5,
                      filterQuality: FilterQuality.none,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30, left: 20, bottom: 20),
                child: Text(
                  "O que você está procurando?",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClientsScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: width / 3.8,
                      width: width / 3.8,
                      decoration: BoxDecoration(
                        color: Color(0xff00695c),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.users,
                            color: Colors.white,
                            size: 40,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Text(
                              "Clientes",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HelpScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: width / 3.8,
                      width: width / 3.8,
                      decoration: BoxDecoration(
                        color: Color(0xff00695c),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.question,
                            color: Colors.white,
                            size: 40,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Text(
                              "Ajuda",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
