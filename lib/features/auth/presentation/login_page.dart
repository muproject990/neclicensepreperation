import 'package:flutter/material.dart';
import 'package:neclicensepreperation/core/app_pallete.dart';
import 'package:neclicensepreperation/features/auth/presentation/signup_page.dart';
import 'package:neclicensepreperation/features/auth/presentation/widgets/auth_feild.dart';
import 'package:neclicensepreperation/features/auth/presentation/widgets/auth_gradient_button.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const LoginPage(),
      );
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //! Now using TextEditiong controller For accesing value in the text Box

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  // final nameController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    // nameController.dispose();
    super.dispose();
  }

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
                "Sign In",
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              AuthField(
                hintText: "Email",
                controller: emailController,
              ),
              const SizedBox(
                height: 15,
              ),
              AuthField(
                isObscureText: true,
                hintText: "Password",
                controller: passwordController,
              ),
              const SizedBox(
                height: 20,
              ),
              AuthGradientBtn(
                buttonText: 'Sign In',
                onPressed: () {},
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    SignUpPage.route(),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    text: "Don't have an account ? ",
                    style: Theme.of(context).textTheme.titleMedium,
                    children: [
                      TextSpan(
                        text: "Sign Up",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: AppPallete.gradient2),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
