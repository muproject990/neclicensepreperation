// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:neclicensepreperation/core/common/cubits/main_mcq/correctAns_cubit.dart';
// import 'package:neclicensepreperation/core/common/widgets/loader.dart';
// import 'package:neclicensepreperation/core/utils/show_snackbar.dart';
// import 'package:neclicensepreperation/features/questions/presentation/bloc/question_bloc.dart';
// import 'package:neclicensepreperation/features/questions/presentation/pages/topics/DSA/learn_toc.dart';
// import 'package:neclicensepreperation/features/questions/widgets/floating_btn.dart';
// import 'package:neclicensepreperation/features/questions/widgets/option_button.dart';

// class Programming extends StatefulWidget {
//   static route() => MaterialPageRoute(
//         builder: (context) => const Programming(),
//       );
//   const Programming({super.key});

//   @override
//   State<Programming> createState() => _ProgrammingState();
// }

// class _ProgrammingState extends State<Programming> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<QuestionBloc>().add(QuestionFetchProgrammingQuestions());
//   }

//   @override
//   Widget build(BuildContext context) {
//     final correctansCubit = BlocProvider.of<CorrectansCubit>(context);
//     return Scaffold(
//         appBar: AppBar(
//           title: BlocBuilder<CorrectansCubit, int>(
//               bloc: correctansCubit,
//               builder: (context, counter) {
//                 return Text(' Answered $counter out of 100');
//               }),
//         ),
//         body: BlocConsumer<QuestionBloc, QuestionState>(
//           listener: (context, state) {
//             if (state is QuestionFailure) {
//               showSnackBar(context, state.error);
//             }
//           },
//           builder: (context, state) {
//             if (state is QuestionLoading) {
//               return const Loader();
//             }

//             if (state is QuestionDisplaySuccess) {
//               return Center(
//                 child: ListView.builder(
//                     itemCount: state.questions.length,
//                     itemBuilder: (context, index) {
//                       final question = state.questions[index];
//                       return Column(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(top: 50, left: 10),
//                             child: Container(
//                               width: MediaQuery.of(context).size.width,
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 10, horizontal: 20),
//                               decoration: BoxDecoration(
//                                   color: Colors.blueGrey[600],
//                                   borderRadius: BorderRadius.circular(8)),
//                               child: Text(
//                                 '${index + 1}  ${question.question.toUpperCase()}',
//                                 style: const TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 20),
//                           MqcQuestionAnswer(
//                             text: question.option1,
//                             isCorrect: question.option1 == question.answer,
//                             // correctansCubit: correctansCubit,
//                           ),
//                           const SizedBox(height: 10),
//                           MqcQuestionAnswer(
//                             text: question.option2,
//                             isCorrect: question.option2 == question.answer,
//                             // correctansCubit: correctansCubit,
//                           ),
//                           const SizedBox(height: 10),
//                           MqcQuestionAnswer(
//                             text: question.option3,
//                             isCorrect: question.option3 == question.answer,
//                             // correctansCubit: correctansCubit,
//                           ),
//                           const SizedBox(height: 10),
//                           MqcQuestionAnswer(
//                             text: question.option4,
//                             isCorrect: question.option4 == question.answer,
//                             // correctansCubit: correctansCubit,
//                           ),
//                           const SizedBox(height: 10),
//                         ],
//                       );
//                     }),
//               );
//             }
//             return const SizedBox();
//           },
//         ),
//         floatingActionButton: FloatingBtn(
//           buttonText: 'Learn',
//           onPressed: () {
//             Navigator.push(
//               context,
//               LearnDsa.route(),
//             );
//           },
//         ));
//   }
// }

import 'package:flutter/material.dart';

class Programming extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const Programming(),
      );
  const Programming({super.key});

  @override
  State<Programming> createState() => _ProgrammingState();
}

class _ProgrammingState extends State<Programming> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Programming'),
      ),
    );
  }
}
