import 'package:flutter/material.dart';
import 'package:murobi_beta/widget/constant_widget.dart';

class EdukasiWidget extends StatefulWidget {
  const EdukasiWidget({super.key});

  @override
  _EdukasiWidgetState createState() => _EdukasiWidgetState();
}

class _EdukasiWidgetState extends State<EdukasiWidget> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: decorationBuilder(
        context,
        const Padding(
          padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: Center(
            child: Text("Under M.Farhan F Construction"),
          )
        )
      )
    );
  }
}