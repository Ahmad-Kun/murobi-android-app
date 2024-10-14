import 'package:flutter/material.dart';
import 'package:murobi_beta/flutter_flow/flutter_flow_theme.dart';
import 'package:murobi_beta/widget/constant_widget.dart';

class ZiswafPages extends StatefulWidget {
  const ZiswafPages({super.key});
  @override
  _ZiswafPagesState createState() => _ZiswafPagesState();
}

class _ZiswafPagesState extends State<ZiswafPages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'ZISWAF', false),
      body: decorationBuilder(
        context,
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      boxBuilder(
                        context,
                        'Zakat',
                        "Zakat berarti bersih, suci, subur, dan berkembang, terdapat zakat fitrah dan mal (harta) yang wajib dilaksanakan dan dapat diwakilkan.",
                      ),
                      boxBuilder(
                        context,
                        "Infaq",
                        "Infaq & Shodaqoh adalah pemberian harta yang dikeluarkan untuk kepentingan umum, seperti pembangunan masjid, panti, dsb.",
                      ),
                      boxBuilder(
                        context,
                        "Wakaf",
                        "Mewakafkan harta kepada Allah yang akan dikelola masjid untuk kepentingan Umat (Tempat Ibadah, Pendidikan, Kesehatan, Sosial, Ekonomi, dll).",
                      ),
                      const SizedBox(height: 20),
                      iconRiwayat(context),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget boxBuilder(BuildContext context, String title, String description) {
  return WillPopScope(
    onWillPop: () async {
      // param = "";
      return true;
    },
    child: GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/payment');
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 210,
        margin: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              blurRadius: 6,
              color: Color(0x4B1A1F24),
              offset: Offset(0, 2),
            )
          ],
          gradient: const LinearGradient(
            colors: [Color(0xFF00968A), Color(0xFFF2A384)],
            stops: [0, 1],
            begin: AlignmentDirectional(0.94, -1),
            end: AlignmentDirectional(-0.94, 1),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            const Positioned(
              right: 10,
              child: Image(
                image: AssetImage("assets/images/moon3.png"),
                height: 100,
                width: 100,
                fit: BoxFit.scaleDown,
              ),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 100,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      softWrap: true,
                      style: FlutterFlowTheme.of(context).displaySmall.override(
                            fontFamily: 'Lexend',
                            color: const Color.fromRGBO(30, 30, 30, 1.0),
                          ),
                    ),
                    Text(
                      description,
                      softWrap: true,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Lexend',
                          color: const Color.fromRGBO(30, 30, 30, 1.0)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
