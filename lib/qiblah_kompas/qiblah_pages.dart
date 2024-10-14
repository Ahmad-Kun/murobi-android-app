import 'package:flutter/material.dart';
import 'package:murobi_beta/widget/constant_widget.dart';

class QiblahPages extends StatefulWidget {
  const QiblahPages({super.key});

  @override
  _QiblahPagesState createState() => _QiblahPagesState();
}

class _QiblahPagesState extends State<QiblahPages> {
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