import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lambox_pharm/models/form_data.dart';
import 'package:lambox_pharm/pages/waiting_screen.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RegisterScreen extends StatefulWidget {
  final double height;
  RegisterScreen(this.height);
  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  final FocusNode _focus = FocusNode();
  bool focus = false;

  final FocusNode _focus2 = FocusNode();
  bool focus2 = false;

  bool containerAnimate = true;
  bool containerAnimate2 = false;
  bool firstForm = true;
  bool secondForm = true;

  AnimationController controller;

  AnimationController containerController;
  Animation animation;

  AnimationController heightController;
  Animation<double> heightAnimation;

  double myOpacity = 1;
  bool hasAnimate = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() {
      setState(() {
        focus = !focus;
      });
      if (!hasAnimate) {
        controller.reverse(from: 1);
        hasAnimate = true;
      }
    });

    _focus2.addListener(() {
      setState(() {
        focus2 = !focus2;
      });
    });

    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        containerAnimate = false;
        containerAnimate2 = true;
        containerController.reverse(from: 1);
        controller.forward();
      }
    });

    controller.addListener(() {
      setState(() {
        myOpacity = controller.value;
        print(myOpacity);
      });
    });

    containerController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    animation = CurvedAnimation(
      parent: containerController,
      curve: Curves.easeInQuint,
    );

    containerController.addListener(() {
      setState(() {
        print((animation.value * 100));
        if (animation.value < 0) {
          containerAnimate2 = false;
        }
      });
    });

    heightController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    heightAnimation = Tween<double>(begin: 0.0, end: widget.height / 1.35)
        .chain(CurveTween(curve: Curves.easeIn))
        .animate(heightController);

    heightAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        secondForm = false;
        heightController.reverse(from: widget.height / 1.35);
      }
    });

    heightController.addListener(() {
      setState(() {
        print(heightAnimation.value);
        if (!secondForm && heightAnimation.value == 0) {
          _focus2.requestFocus();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 30, top: 50),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Hero(
                  tag: 'lamboxLogo',
                  child: Image.asset(
                    'assets/lamboxpharm.png',
                    height: 100,
                  ),
                ),
                if (containerAnimate2)
                  Opacity(
                    opacity: controller.value,
                    child: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.teal),
                        ),
                        color: Colors.teal,
                        onPressed: () {
                          context
                              .read<FormData>()
                              .firstRegistrationFormVerify();
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (context.read<FormData>().firstFormVerifier) {
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WaitingScreen(),
                                ),
                              );
                            }
                          } else {
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
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                  width: 120,
                                )
                              ],
                            ).show();
                          }
                        },
                        child: Text(
                          'Próximo',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
          if (containerAnimate)
            Padding(
              padding: EdgeInsets.only(left: 30, top: 30, bottom: 30),
              child: AnimatedOpacity(
                opacity: myOpacity,
                duration: Duration(milliseconds: 400),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bem-vindo ao LamBox!',
                        style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.w800,
                            fontSize: 30),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Row(
                          children: [
                            Text(
                              'Não sabe o que é LamBox? Clique ',
                              style: TextStyle(fontWeight: FontWeight.w300),
                            ),
                            Text(
                              'aqui',
                              style: TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.w300),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          if (containerAnimate2)
            SizedBox(
              height: (animation.value * 100),
            ),
          Expanded(
            child: ClipPath(
              clipper: WaveClipperOne(reverse: true),
              child: Container(
                padding: EdgeInsets.only(left: 30, right: 30),
                width: double.infinity,
                color: Colors.teal,
                child: AnimationLimiter(
                  child: ListView(
                    children: AnimationConfiguration.toStaggeredList(
                      duration: Duration(milliseconds: 800),
                      childAnimationBuilder: (widget) => SlideAnimation(
                        horizontalOffset: 50.0,
                        child: FadeInAnimation(
                          child: widget,
                        ),
                      ),
                      children: [
                        SizedBox(
                          height: 70,
                          child: Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Text(
                              'Preencha com algumas informações da farmácia:',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: LamBoxRegisterFormFocus(
                            obscureText: false,
                            textType: 'Nome da Farmácia',
                            iconType: FontAwesomeIcons.clinicMedical,
                            focus: focus,
                            focusNode: _focus,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: LamBoxRegisterForm(
                            obscureText: false,
                            textType: 'Telefone',
                            iconType: Icons.call,
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: LamBoxRegisterForm(
                            obscureText: false,
                            textType: 'Rua',
                            iconType: FontAwesomeIcons.road,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: LamBoxRegisterForm(
                            obscureText: false,
                            textType: 'Cidade',
                            iconType: FontAwesomeIcons.city,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LamBoxRegisterForm extends StatefulWidget {
  LamBoxRegisterForm({
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
  _LamBoxRegisterFormState createState() => _LamBoxRegisterFormState();
}

class _LamBoxRegisterFormState extends State<LamBoxRegisterForm> {
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
    context.read<FormData>().addFormController(controller);
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

class LamBoxRegisterFormFocus extends StatefulWidget {
  LamBoxRegisterFormFocus({
    this.focus,
    this.focusNode,
    this.iconType,
    this.textType,
    this.obscureText,
    this.keyboardType,
  });

  final bool focus;
  final FocusNode focusNode;

  final IconData iconType;
  final String textType;
  final bool obscureText;
  final TextInputType keyboardType;

  @override
  _LamBoxRegisterFormFocusState createState() =>
      _LamBoxRegisterFormFocusState();
}

class _LamBoxRegisterFormFocusState extends State<LamBoxRegisterFormFocus> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<FormData>().addFormController(controller);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: widget.obscureText,
      style: TextStyle(color: !widget.focus ? Color(0xff004d40) : Colors.white),
      keyboardType: widget.keyboardType,
      focusNode: widget.focusNode,
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
            TextStyle(color: !widget.focus ? Color(0xff004d40) : Colors.white),
        icon: Icon(widget.iconType,
            color: !widget.focus ? Color(0xff004d40) : Colors.white),
      ),
    );
  }
}
