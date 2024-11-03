import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neclicensepreperation/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:neclicensepreperation/features/questions/presentation/pages/add_new_question.dart';
import 'package:neclicensepreperation/features/questions/presentation/pages/topics/DL/DL.dart';
import 'package:neclicensepreperation/features/questions/presentation/pages/topics/DSA/dsa.dart';
import 'package:neclicensepreperation/features/questions/presentation/pages/topics/Programming/programming.dart';
import 'package:neclicensepreperation/features/questions/presentation/pages/topics/TOC/toc.dart';
import 'package:neclicensepreperation/features/questions/widgets/gradient_button.dart';

class MCQMainPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const MCQMainPage());
  const MCQMainPage({super.key});

  @override
  State<MCQMainPage> createState() => _MCQMainPageState();
}

class _MCQMainPageState extends State<MCQMainPage> {
  String? currentUserEmail;

  @override
  Widget build(BuildContext context) {
    {
      return BlocBuilder<AppUserCubit, AppUserState>(builder: (context, state) {
        if (state is AppUserLoggedIn) {
          currentUserEmail =
              state.user.email; // Assuming 'user' has an 'email' property
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('MCQ  App'),
            actions: [
              if (currentUserEmail == 'ap@gmail.com')
                IconButton(
                  onPressed: () {
                    Navigator.push(context, AddNewQuestion.route());
                  },
                  icon: const Icon(
                    CupertinoIcons.add_circled,
                  ),
                )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                GradientBtn(
                  buttonText: "Digital Logic And Microprocessor",
                  onPressed: () {
                    Navigator.push(
                      context,
                      DL.route(),
                    );
                  },
                ),
                const SizedBox(height: 20),
                GradientBtn(
                  buttonText: "Theory Of Computation",
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   TOC.route(),
                    // );
                  },
                ),
                const SizedBox(height: 20),
                GradientBtn(
                  buttonText: "DataStructure and Algorithms",
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   Dsa.route(),
                    // );
                  },
                ),
                const SizedBox(height: 20),
                GradientBtn(
                  buttonText: "Programming",
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   Programming.route(),
                    // );
                  },
                ),
              ],
            ),
          ),
        );
      });
    }
  }
}
