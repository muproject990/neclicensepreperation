import 'package:flutter/material.dart';
import 'package:neclicensepreperation/core/app_pallete.dart';
import 'package:neclicensepreperation/features/auth/presentation/widgets/auth_feild.dart';
import 'package:neclicensepreperation/features/auth/presentation/widgets/auth_gradient_button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // !TextEditiong controller
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // it will validate every form feild

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: Cr,
            children: [
              const Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const AuthField(hintText: "Name"),
              const SizedBox(
                height: 15,
              ),
              const AuthField(hintText: "Password"),
              const SizedBox(
                height: 15,
              ),
              const AuthField(hintText: "Email"),
              const SizedBox(
                height: 20,
              ),
              const AuthGradientBtn(
                buttonText: "Sign Up",
              ),
              const SizedBox(
                height: 20,
              ),
              RichText(
                text: TextSpan(
                  text: "Don\'t have and account ? ",
                  style: Theme.of(context).textTheme.titleMedium,
                  children: [
                    TextSpan(
                      text: "Sign In",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: AppPallete.gradient2),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
