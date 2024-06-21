import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neclicensepreperation/core/app_pallete.dart';
import 'package:neclicensepreperation/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:neclicensepreperation/core/common/widgets/loader.dart';
import 'package:neclicensepreperation/core/utils/show_snackbar.dart';
import 'package:neclicensepreperation/core/utils/topics.dart';
import 'package:neclicensepreperation/features/main/presentation/bloc/question_bloc.dart';
import 'package:neclicensepreperation/features/main/widgets/question_editor.dart';

class AddNewQuestion extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const AddNewQuestion());

  const AddNewQuestion({super.key});

  @override
  State<AddNewQuestion> createState() => _AddNewQuestionState();
}

class _AddNewQuestionState extends State<AddNewQuestion> {
  final questioncontroller = TextEditingController();
  final op1controller = TextEditingController();
  final op2controller = TextEditingController();
  final op3controller = TextEditingController();
  final op4controller = TextEditingController();
  TextEditingController answercontroller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  List<String> seletedTopice = [];

  void uploadQuestion() {
    if (formKey.currentState!.validate() && seletedTopice.length == 1) {
      final userId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
      context.read<QuestionBloc>().add(QuestionUpload(
          question: questioncontroller.text,
          option1: op1controller.text.toLowerCase().trim(),
          option2: op2controller.text.toLowerCase().trim(),
          option3: op3controller.text.toLowerCase().trim(),
          userId: userId,
          option4: op4controller.text.toLowerCase().trim(),
          answer: answercontroller.text.toLowerCase().trim(),
          topics: seletedTopice));

      // showSnackBar(context, " Data Uploaded Sucessfully");
    }
  }

  @override
  void dispose() {
    questioncontroller.dispose();
    op1controller.dispose();
    op2controller.dispose();
    op3controller.dispose();
    op4controller.dispose();
    answercontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: uploadQuestion,
            icon: const Icon(
              Icons.done_rounded,
            ),
          )
        ],
      ),
      body: BlocConsumer<QuestionBloc, QuestionState>(
        listener: (context, state) {
          if (state is QuestionFailure) {
            showSnackBar(context, state.error);
          } else if (state is QuestionUploadSuccess) {
            showSnackBar(context, "Added Sucessfully");
          }
        },
        builder: (context, state) {
          if (state is QuestionLoading) {
            return const Loader();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    DottedBorder(
                      color: AppPallete.borderColor,
                      radius: const Radius.circular(10),
                      borderType: BorderType.RRect,
                      strokeCap: StrokeCap.round,
                      dashPattern: const [10, 4],
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Icons.question_answer_outlined),
                              Text("Select Any Topics ?")
                            ],
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: Topics.children
                            .map(
                              (e) => Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: GestureDetector(
                                  onTap: () {
                                    if (seletedTopice.contains(e)) {
                                      seletedTopice.remove(e);
                                    } else {
                                      seletedTopice.add(e);
                                    }
                                    setState(() {
                                      print(seletedTopice);
                                    });
                                  },
                                  child: Chip(
                                    color: seletedTopice.contains(e)
                                        ? const MaterialStatePropertyAll(
                                            AppPallete.gradient2)
                                        : null,
                                    side: seletedTopice.contains(e)
                                        ? null
                                        : const BorderSide(
                                            color: AppPallete.borderColor),
                                    label: Text(e),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppPallete.greyColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: QuestionEditor(
                        controller: questioncontroller,
                        hintText: "Enter Question here",
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    QuestionEditor(
                      controller: op1controller,
                      hintText: "Option 1",
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    QuestionEditor(
                      controller: op2controller,
                      hintText: "Option 2",
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    QuestionEditor(
                      controller: op3controller,
                      hintText: "Option 3",
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    QuestionEditor(
                      controller: op4controller,
                      hintText: "Option 4",
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: QuestionEditor(
                        controller: answercontroller,
                        hintText: "Answer",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
