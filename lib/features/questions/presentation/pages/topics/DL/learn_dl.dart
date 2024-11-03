import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:neclicensepreperation/features/questions/widgets/pdf-viewer.dart';

class LearnDL extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const LearnDL());

  final bool progressExample;

  const LearnDL({super.key, this.progressExample = false});

  @override
  State<LearnDL> createState() => _LearnDLState();
}

class _LearnDLState extends State<LearnDL> {
  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return const PdfView(
        assetPath: 'assets/pdf/Digitallogic.pdf', title: "DigitalLogic");
  }
}
