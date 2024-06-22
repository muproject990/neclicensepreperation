import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:neclicensepreperation/features/main/presentation/pages/home_page.dart';
import 'package:neclicensepreperation/features/main/widgets/gradient_button.dart';
import 'package:neclicensepreperation/features/main/widgets/option_button.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DottedBorder(
            color: Colors.grey,
            strokeWidth: 1,
            borderType: BorderType.RRect,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: SizedBox(
                height: 70,
                width: MediaQuery.of(context).size.width / 1.2,
                child: const Text(
                  "\"WELCOME 2 NEC License Prep-\neration Guide\"",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset('assets/img/logo.png'),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          GradientBtn(
            buttonText: "Chick Here To Begin",
            onPressed: () => Navigator.push(context, MCQMainPage.route()),
          )
        ],
      ),
    );
  }
}
