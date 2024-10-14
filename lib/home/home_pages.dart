import 'package:flutter/material.dart';
import 'package:murobi_beta/widget/constant_widget.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
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