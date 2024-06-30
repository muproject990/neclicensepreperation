import 'package:flutter/material.dart';
import 'package:neclicensepreperation/features/main/widgets/pdf-viewer.dart';

class LearnDsa extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const LearnDsa());

  final bool progressExample;

  const LearnDsa({super.key, this.progressExample = false});

  @override
  State<LearnDsa> createState() => _LearnDsaState();
}

class _LearnDsaState extends State<LearnDsa> {
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
