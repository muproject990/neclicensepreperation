import 'package:flutter/material.dart';
import 'package:neclicensepreperation/features/questions/widgets/pdf-viewer.dart';

class LearnTOC extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const LearnTOC());

  final bool progressExample;

  const LearnTOC({super.key, this.progressExample = false});

  @override
  State<LearnTOC> createState() => _LearnTOCState();
}

class _LearnTOCState extends State<LearnTOC> {
  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return const PdfView(
        assetPath: 'assets/pdf/Digitallogic .pdf', title: "DigitalLogic");
  }
}
