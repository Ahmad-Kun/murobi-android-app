import 'package:flutter/material.dart';
import 'package:murobi_beta/flutter_flow/flutter_flow_theme.dart';

Widget decorationBuilder(BuildContext context, Widget child) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color.fromRGBO(170, 245, 179, 1),
          Color.fromRGBO(165, 210, 238, 1),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomLeft,
      ),
    ),
    child: child,
  );
}

AppBar appBar(BuildContext context, String text, bool params) {
  return AppBar(
    title: Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: FlutterFlowTheme.of(context).titleLarge.override(
            fontFamily: 'Lexend',
            color: Colors.black,
          ),
    ),
    backgroundColor: Color.fromRGBO(170, 245, 179, 1),
    automaticallyImplyLeading: false,
    centerTitle: true,
    leading: params
        ? BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          )
        : null,
  );
}

Widget textLapkeuBuild(BuildContext context, String lapkeuText, FontWeight fw,
    double fs, Color color) {
  return Text(
    lapkeuText,
    textAlign: TextAlign.start,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontFamily: 'poppins',
      fontWeight: fw,
      fontStyle: FontStyle.normal,
      fontSize: fs,
      color: color,
    ),
  );
}

Widget iconRiwayat(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(
          context, '/riwayat'); // Uncomment to navigate to another screen
    },
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF99DDC8), Color(0xFF66CDAA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(2, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.assignment,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            'Riwayat',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}
