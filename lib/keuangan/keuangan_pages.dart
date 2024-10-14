import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:murobi_beta/flutter_flow/flutter_flow_util.dart';
import 'package:murobi_beta/models/lapkeu_model.dart';
import 'package:murobi_beta/models/masjid_model.dart';
import 'package:murobi_beta/models/responselapkeu_model.dart';
import 'package:murobi_beta/models/wakaf_model.dart';
import 'package:murobi_beta/services/api_lapkeu_service.dart';
import 'package:murobi_beta/utils/api.dart';
import 'package:murobi_beta/widget/constant_widget.dart';
import 'package:murobi_beta/flutter_flow/flutter_flow_theme.dart';
import 'package:http/http.dart' as http;

class KeuanganPages extends StatefulWidget {
  const KeuanganPages({super.key});

  @override
  _KeuanganPagesState createState() => _KeuanganPagesState();
}

class _KeuanganPagesState extends State<KeuanganPages> {
  late String selectedValue;
  final double width = 7;
  late String idMasjidP;
  late String saldoAkhir = "";
  late String pemBulan = "";
  late String totZakFit = "";
  late String totZakMal = "";
  final String apiUrl = ApiConstants.baseUrl + ApiConstants.endPointDataMasjid;
  late String totWakaf = "";
  late String relWakaf = "";

  List<MasjidModel>? dataMasjid;
  late Future<List<LapkeuModel>> _apiLapkeuModel = Future.value([]);
  late Future<List<wakafModel>> _apiWakafModel = Future.value([]);

  void _getData() async {
    final String apiUrl =
        ApiConstants.baseUrl + ApiConstants.endPointDataMasjid;

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      dataMasjid =
          List.from(data).map((item) => MasjidModel.fromJson(item)).toList();
      idMasjidP = dataMasjid![0].id.toString();
      selectedValue = dataMasjid![0].masjidName;
    } else {
      // Handle error response
      print('Error: ${response.statusCode}');
    }
    setLapkeu(idMasjidP);
  }

  void setLapkeu(String id) async {
    try {
      LapkeuResponse response = await ApiLapkeu.getApi(id);
      if (mounted) {
        setState(() {
          _apiLapkeuModel = Future.value(response.lapkeuList);
          saldoAkhir = response.saldoAkhir;
          pemBulan = response.inSaldoNow;
          totZakFit = response.totZakFit;
          totZakMal = response.totZakMal;
          _apiWakafModel = Future.value(response.wakafList);
          totWakaf = response.totWakaf;
          relWakaf = response.relWakaf;
        });
      }
    } catch (e) {
      print('Error fetching Lapkeu data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'Laporan Keuangan', false),
      body: decorationBuilder(
        context,
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  height: 20,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      textLapkeuBuild(context, "Pilih Masjid : ",
                          FontWeight.bold, 14, Colors.black),
                      if (dataMasjid == null)
                        Center(
                            child:
                                CircularProgressIndicator()) // Show loading indicator while fetching data
                      else
                        Container(
                          child: DropdownButton<String>(
                            value: selectedValue,
                            items: dataMasjid?.map((MasjidModel masjid) {
                              return DropdownMenuItem<String>(
                                value: masjid.masjidName,
                                child: Text(
                                  masjid.masjidName,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.clip,
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
                                idMasjidP = dataMasjid!
                                    .firstWhere((masjid) =>
                                        masjid.masjidName == selectedValue)
                                    .id
                                    .toString();
                                setLapkeu(idMasjidP);
                              });
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5, bottom: 10),
                  child: Divider(
                    color: Colors.black,
                    thickness: 1,
                  ),
                ),
                textLapkeuBuild(context, "Jumlah Zakat ${DateTime.now().year}",
                    FontWeight.w800, 18, Colors.black),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    bubleTextBuiilder(context, "Zakat Fitrah",
                        totZakFit == "" ? "Memuat" : "Rp. ${totZakFit.replaceAll('.00', '')}"),
                    SizedBox(width: 20),
                    bubleTextBuiilder(context, "Zakat Mal",
                        totZakMal == "" ? "Memuat" : "Rp. ${totZakMal.replaceAll('.00', '')}"),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 5, bottom: 10),
                  child: Divider(
                    color: Colors.black,
                    thickness: 1,
                  ),
                ),
                textLapkeuBuild(context, "Aset Wakaf Hingga Saat Ini :",
                    FontWeight.w800, 18, Colors.black),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    bubleTextBuiilder(context, "Total Wakaf",
                        totZakFit == "" ? "Memuat" : "Rp. ${totWakaf.replaceAll('.00', '')}"),
                    SizedBox(width: 20),
                    bubleTextBuiilder(context, "Realisasi Wakaf",
                        totZakMal == "" ? "Memuat" : "Rp. ${relWakaf.replaceAll('.00', '')}"),
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
                    "Jumlah Infaq/Shodaqoh/Kas ${DateTime.now().year}",
                    FontWeight.w800,
                    18,
                    Colors.black),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    bubleTextBuiilder(context, "Uang Kas Saat Ini",
                        saldoAkhir == "" ? "Memuat" : "Rp. ${saldoAkhir.replaceAll('.00', '')}"),
                    SizedBox(width: 20),
                    bubleTextBuiilder(context, "Pemasukan Bulan Ini",
                        pemBulan == "" ? "Memuat" : "Rp. ${pemBulan.replaceAll('.00', '')}"),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 5, bottom: 10),
                  child: Divider(
                    color: Colors.black,
                    thickness: 1,
                  ),
                ),
                DefaultTabController(
                  length: 2,
                  child: Column(
                    children: <Widget>[
                      Container(
                        constraints: BoxConstraints.expand(height: 50),
                        child: TabBar(
                          tabs: [
                            Tab(text: "Arus Kas Infaq"),
                            Tab(text: "Arus Wakaf"),
                          ],
                        ),
                      ),
                      Container(
                        height: 300,
                        child: TabBarView(
                          children: [
                            Container(
                              child: FutureBuilder<List<LapkeuModel>>(
                                future: _apiLapkeuModel,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator(); // Tampilkan indikator loading jika data masih dimuat.
                                  } else if (snapshot.hasError) {
                                    return Text(
                                        'Error di Fronts: ${snapshot.error}');
                                  } else if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return textLapkeuBuild(
                                        context,
                                        "Tidak Ada Data Kas/Infaq/Shodaqoh",
                                        FontWeight.normal,
                                        14,
                                        Colors
                                            .black); // Tampilkan pesan jika tidak ada data.
                                  } else {
                                    return SingleChildScrollView(
                                      child: Column(
                                        children: List.generate(
                                          snapshot.data!.length,
                                          (index) => generateTableKas(
                                            snapshot.data![index]
                                                .note, // Gantilah dengan properti yang sesuai dari LapkeuModel
                                            snapshot.data![index].tanggal
                                                .toString(),
                                            snapshot.data![index].jumlah,
                                            snapshot.data![index].arusKas,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                            Container(
                              child: FutureBuilder<List<wakafModel>>(
                                future: _apiWakafModel,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator(); // Tampilkan indikator loading jika data masih dimuat.
                                  } else if (snapshot.hasError) {
                                    return Text(
                                        'Error di Fronts: ${snapshot.error}');
                                  } else if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return textLapkeuBuild(
                                        context,
                                        "Tidak Ada Data Wakaf",
                                        FontWeight.normal,
                                        14,
                                        Colors
                                            .black); // Tampilkan pesan jika tidak ada data.
                                  } else {
                                    return SingleChildScrollView(
                                      child: Column(
                                        children: List.generate(
                                          snapshot.data!.length,
                                          (index) => generateTableWakaf(
                                            snapshot.data![index]
                                                .sumbangan, // Gantilah dengan properti yang sesuai dari LapkeuModel
                                            snapshot.data![index].tanggal
                                                .toString(),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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
          textLapkeuBuild(context, sub, FontWeight.bold, 14, Colors.grey),
          textLapkeuBuild(context, tot, FontWeight.bold, 14, Colors.black),
        ],
      ),
    );
  }

  Widget textLapkeuBuild(BuildContext context, String lapkeuText, FontWeight fw,
      double fs, Color color) {
    return Text(
      lapkeuText,
      textAlign: TextAlign.start,
      overflow: TextOverflow.clip,
      style: TextStyle(
        fontFamily: 'poppins',
        fontWeight: fw,
        fontStyle: FontStyle.normal,
        fontSize: fs,
        color: color,
      ),
    );
  }

  Widget generateTableKas(
      String note, String date, String nominal, int cashFlow) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 70.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primaryBackground,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: const Color(0x6639D2C0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    cashFlow == 0
                        ? Icons.monetization_on_rounded
                        : Icons.money_off_rounded,
                    color: FlutterFlowTheme.of(context).tertiary,
                    size: 24.0,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note,
                      style: FlutterFlowTheme.of(context).headlineSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 4.0, 0.0, 0.0),
                      child: Text(
                        DateFormat('dd MMMM yyyy').format(DateTime.parse(date)),
                        style: FlutterFlowTheme.of(context).bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    nominal.replaceAll('.00', ''),
                    textAlign: TextAlign.end,
                    style: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'Lexend',
                          color: FlutterFlowTheme.of(context).tertiary,
                        ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 4.0, 0.0, 0.0),
                    child: Text(
                      cashFlow == 0 ? 'Pemasukan' : 'Pengeluaran',
                      textAlign: TextAlign.end,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Lexend',
                            fontSize: 12.0,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget generateTableWakaf(String sumbangan, String date) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 70.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primaryBackground,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: const Color(0x6639D2C0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.clean_hands_outlined,
                    color: FlutterFlowTheme.of(context).tertiary,
                    size: 24.0,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sumbangan.replaceAll('.00', ''),
                      style: FlutterFlowTheme.of(context).headlineSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 4.0, 0.0, 0.0),
                      child: Text(
                        DateFormat('dd MMMM yyyy').format(DateTime.parse(date)),
                        style: FlutterFlowTheme.of(context).bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
