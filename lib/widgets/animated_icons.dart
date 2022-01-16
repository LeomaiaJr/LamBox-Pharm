import 'package:flutter/material.dart';

import 'package:after_layout/after_layout.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final List<IconData> icons = [
  FontAwesomeIcons.userMd,
  FontAwesomeIcons.clinicMedical,
  FontAwesomeIcons.briefcaseMedical,
  FontAwesomeIcons.notesMedical,
  FontAwesomeIcons.pills,
];

class LoadingPage extends StatefulWidget {
  @override
  LoadingPageState createState() => LoadingPageState();
}

class LoadingPageState extends State<LoadingPage> with AfterLayoutMixin {
  int currentIcon = -1;
  bool showing = false;

  @override
  void afterFirstLayout(BuildContext context) async {
    icons.shuffle();

    setState(() {
      showing = true;
    });

    await Future.delayed(Duration(milliseconds: 500));

    setState(() => currentIcon = 0);

    Stream.periodic(Duration(milliseconds: 1400), (i) => (i + 1) % icons.length)
      ..takeWhile((_) => mounted)
      ..listen((i) {
        if (mounted) setState(() => currentIcon = i);
      });

    await Future.delayed(Duration(seconds: 10));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPress: () => Navigator.pushReplacementNamed(context, '/'),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: AnimatedOpacity(
          opacity: showing ? 1 : 0,
          duration: Duration(milliseconds: 500),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 900),
                  switchInCurve: Curves.easeInOutBack,
                  switchOutCurve: Curves.easeInOutBack,
                  child: SizedBox(
                    key: ValueKey(currentIcon),
                    height: 140,
                    child: currentIcon < 0
                        ? null
                        : Center(
                            child: FaIcon(
                              icons[currentIcon],
                              size: 120,
                              color: Colors.teal,
                            ),
                          ),
                  ),
                  transitionBuilder: (child, animation) {
                    final fixedAnimation = child.key == ValueKey(currentIcon)
                        ? animation
                        : Tween<double>(begin: 1, end: 0).animate(animation);
                    return RotationTransition(
                      turns: fixedAnimation,
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
