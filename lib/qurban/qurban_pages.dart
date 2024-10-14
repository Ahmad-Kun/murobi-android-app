import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:murobi_beta/flutter_flow/flutter_flow_theme.dart';
import 'package:murobi_beta/flutter_flow/flutter_flow_widgets.dart';
import 'package:murobi_beta/models/qurban_model.dart';
import 'package:murobi_beta/utils/api.dart';
import 'package:murobi_beta/widget/constant_widget.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class QurbanPages extends StatefulWidget {
  const QurbanPages({super.key});

  @override
  _QurbanPagesState createState() => _QurbanPagesState();
}

class _QurbanPagesState extends State<QurbanPages> {
  List<QurbanModel>? dataQurban;
  late String selectedValue = "";
  late String sapi = "";
  late String kambing = "";
  late String sapiUser = "";
  late String kambingUser = "";

  final String apiUrl = ApiConstants.baseUrl + ApiConstants.endPointQurban;

  @override
  void initState() {
    super.initState();
    setDataQurban();
  }

  void setDataQurban() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('userToken');
    final String apiUrl = ApiConstants.baseUrl + ApiConstants.endPointQurban;
    final response = await http.post(Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'token': token,
        }));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      dataQurban =
          List.from(data).map((item) => QurbanModel.fromJson(item)).toList();
      if (mounted) {
        setState(() {
          selectedValue = dataQurban!.first.masjidName;
          sapi = dataQurban!.first.sapi.toString();
          kambing = dataQurban!.first.kambing.toString();
          sapiUser = dataQurban!.first.sapiUser.toString();
          kambingUser = dataQurban!.first.kambingUser.toString();
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Server error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'QURBAN', false),
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
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 210,
                        margin:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 6,
                              color: Color(0x4B1A1F24),
                              offset: Offset(0, 2),
                            ),
                          ],
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00968A), Color(0xFFF2A384)],
                            stops: [0, 1],
                            begin: AlignmentDirectional(0.94, -1),
                            end: AlignmentDirectional(-0.94, 1),
                          ),
                          borderRadius: BorderRadius.circular(8),
                          image: const DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage("assets/images/qurban.png"),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5, bottom: 10),
                        child: Divider(
                          color: Colors.black,
                          thickness: 1,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          textLapkeuBuild(context, "Pilih Masjid : ",
                              FontWeight.bold, 14, Colors.black),
                          if (dataQurban == null)
                            Center(
                                child:
                                    CircularProgressIndicator()) // Show loading indicator while fetching data
                          else
                            Container(
                              child: DropdownButton<String>(
                                value: selectedValue,
                                items: dataQurban?.map((QurbanModel qurban) {
                                  return DropdownMenuItem<String>(
                                    value: qurban.masjidName,
                                    child: Text(
                                      qurban.masjidName,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontFamily: 'poppins',
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14,
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                underline: null,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedValue = newValue!;
                                    sapi = dataQurban!
                                        .firstWhere((qurban) =>
                                            qurban.masjidName == selectedValue)
                                        .sapi
                                        .toString();
                                    kambing = dataQurban!
                                        .firstWhere((qurban) =>
                                            qurban.masjidName == selectedValue)
                                        .kambing
                                        .toString();
                                    sapiUser = dataQurban!
                                        .firstWhere((qurban) =>
                                            qurban.masjidName == selectedValue)
                                        .sapiUser
                                        .toString();
                                    kambingUser = dataQurban!
                                        .firstWhere((qurban) =>
                                            qurban.masjidName == selectedValue)
                                        .kambingUser
                                        .toString();
                                  });
                                },
                              ),
                            ),
                        ],
                      ),
                      textLapkeuBuild(
                        context,
                        selectedValue == ""
                            ? "Loading..."
                            : "Jumlah Qurban di $selectedValue",
                        FontWeight.w800,
                        18,
                        Colors.black,
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          generateQurban('assets/images/cow.svg', sapi),
                          generateQurban('assets/images/goat.svg', kambing),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5, bottom: 10),
                        child: Divider(
                          color: Colors.black,
                          thickness: 1,
                        ),
                      ),
                      textLapkeuBuild(
                        context,
                        selectedValue == ""
                            ? "Loading..."
                            : "Qurban Anda di $selectedValue",
                        FontWeight.w800,
                        18,
                        Colors.black,
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          generateQurban(
                              'assets/images/human-cow.svg', sapiUser),
                          generateQurban(
                              'assets/images/human-goat.svg', kambingUser),
                        ],
                      ),
                      SizedBox(height: 20),
                      iconRiwayat(context),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              FFButtonWidget(
                text: 'Ayo BerQurban',
                onPressed: () {
                  Navigator.pushNamed(context, '/payment');
                },
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 44.0,
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  iconPadding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: const Color(0xFF4B39EF),
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'Plus Jakarta Sans',
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                  elevation: 3.0,
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              const SizedBox(height: 16)
            ],
          ),
        ),
      ),
    );
  }

  Widget generateQurban(String _asset, String _hewan) {
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 40,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                _asset, // Path to your SVG file
                height: 60,
                width: 60,
              ),
              textLapkeuBuild(
                  context, " : ", FontWeight.bold, 15, Colors.black),
            ],
          ),
          textLapkeuBuild(context, sapi == "" ? "Memuat" : "$_hewan Ekor",
              FontWeight.bold, 15, Colors.black),
          SizedBox(width: 5),
        ],
      ),
    );
  }

  Widget bubleTextBuiilder(BuildContext context, String sub, String tot) {
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 40,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child:
                textLapkeuBuild(context, sub, FontWeight.bold, 14, Colors.grey),
          ),
          Flexible(
            child: textLapkeuBuild(
                context, tot, FontWeight.bold, 14, Colors.black),
          ),
        ],
      ),
    );
  }

  Widget textLapkeuBuild(BuildContext context, String lapkeuText, FontWeight fw,
      double fs, Color color) {
    return Text(
      lapkeuText,
      overflow: TextOverflow.clip,
      textAlign: TextAlign.start,
      style: TextStyle(
        fontFamily: 'poppins',
        fontWeight: fw,
        fontStyle: FontStyle.normal,
        fontSize: fs,
        color: color,
      ),
    );
  }
}
