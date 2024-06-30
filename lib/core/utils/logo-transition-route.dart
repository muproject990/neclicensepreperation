import 'package:flutter/material.dart';

class LoginTransitionWrapper extends StatefulWidget {
  final Widget child;

  const LoginTransitionWrapper({
    super.key,
    required this.child,
  });

  @override
  State<LoginTransitionWrapper> createState() => _LoginTransitionWrapperState();
}

class _LoginTransitionWrapperState extends State<LoginTransitionWrapper> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacement(
        LogoTransitionRoute(page: widget.child),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/img/logo.jpg',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}

class LogoTransitionRoute extends PageRouteBuilder {
  final Widget page;

  LogoTransitionRoute({required this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              Stack(
            children: [
              child,
              FadeTransition(
                opacity: Tween<double>(begin: 1.0, end: 0.0).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: const Interval(0.0, 0.98, curve: Curves.easeOut),
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/img/logo.jpg',
                    width: 200,
                    height: 200,
                  ),
                ),
              ),
            ],
          ),
        );
}
