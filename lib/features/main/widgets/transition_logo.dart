import 'package:flutter/material.dart';

class LogoTransition extends StatefulWidget {
  const LogoTransition({super.key});

  @override
  State<LogoTransition> createState() => _LogoTransitionState();
}

class _LogoTransitionState extends State<LogoTransition> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _visible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedOpacity(
        opacity: _visible ? 1.0 : 0.0,
        duration: Duration(seconds: 1),
        child: Image.asset(
          'assets/img/nec.png',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
