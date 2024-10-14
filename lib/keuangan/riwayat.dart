import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:murobi_beta/flutter_flow/flutter_flow_theme.dart';
import 'package:murobi_beta/flutter_flow/flutter_flow_util.dart';
import 'package:murobi_beta/models/riwayat_model.dart';
import 'package:murobi_beta/utils/api.dart';
import 'package:murobi_beta/widget/constant_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class RiwayatPages extends StatefulWidget {
  const RiwayatPages({super.key});

  @override
  _RiwayatPagesState createState() => _RiwayatPagesState();
}

class _RiwayatPagesState extends State<RiwayatPages> {
  late final WebViewController _controller;
  String? _snapUrl;
  Future<List<RiwayatModel>>? _riwayat = Future.value([]);
  Future<void> _getRiwayat() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('userToken');
    final String apiUrl = ApiConstants.baseUrl + ApiConstants.endPointRiwayat;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'token': token}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _riwayat = Future.value(List.from(data)
              .map((item) => RiwayatModel.fromJson(item))
              .toList());
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server error')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load data: $e')),
      );
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _getRiwayat();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _setSnap(String snap) async {
    try {
      setState(() {
        _snapUrl = "https://app.sandbox.midtrans.com/snap/v4/redirection/$snap";
        _controller = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(NavigationDelegate(
            onWebResourceError: (WebResourceError error) {},
            onNavigationRequest: (NavigationRequest request) {
              final host = Uri.parse(request.url).toString();
              if (host.contains("transaction_status=settlement") ||
                  host.contains("transaction_status=pending") ||
                  host.contains("transaction_status=error")) {
                Get.offAllNamed('/dashboard');
                return NavigationDecision.prevent;
              } else {
                return NavigationDecision.navigate;
              }
            },
          ))
          ..loadRequest(Uri.parse(_snapUrl!));
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(context, 'Riwayat Transaksi', true),
        body: _snapUrl != null
            ? WebViewWidget(controller: _controller)
            : decorationBuilder(
                context,
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: DefaultTabController(
                    length: 4,
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 60,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0.0, vertical: 8.0),
                            child: TabBar(
                              indicator: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              tabs: [
                                CustomTab(text: 'Semua'),
                                CustomTab(text: 'Tunda'),
                                CustomTab(text: 'Sukses'),
                                CustomTab(text: 'Gagal'),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              generateTableRiwayat(_riwayat, 'all'),
                              generateTableRiwayat(_riwayat, 'pending'),
                              generateTableRiwayat(_riwayat, 'success'),
                              generateTableRiwayat(_riwayat, 'cancel'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ))
        // : Center(
        //     child: Column(
        //       children: [
        //         textLapkeuBuild(context, 'Loading Data...',
        //             FontWeight.w800, 18, Colors.black),
        //         CircularProgressIndicator(),
        //       ],
        //     ),
        //   ),
        );
  }

  Widget generateTableRiwayat(Future<List<RiwayatModel>>? _r, String _status) {
    return Container(
      child: FutureBuilder<List<RiwayatModel>>(
        future: _riwayat,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Tampilkan indikator loading jika data masih dimuat.
          } else if (snapshot.hasError) {
            return Text('Error di Fronts: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return textLapkeuBuild(
                context,
                "Tidak Ada Data Kas/Infaq/Shodaqoh",
                FontWeight.normal,
                14,
                Colors.black); // Tampilkan pesan jika tidak ada data.
          } else {
            List<RiwayatModel> filteredData = _status == 'all'
                ? snapshot.data!
                : snapshot.data!
                    .where((item) => item.status == _status)
                    .toList();
            return SingleChildScrollView(
              child: Column(
                children: List.generate(
                  filteredData.length,
                  (index) => Padding(
                    padding: const EdgeInsetsDirectional.only(bottom: 16.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 70,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                8.0, 0.0, 0.0, 0.0),
                            child: Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              color: const Color(0x6639D2C0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  filteredData[index]
                                              .jenisZakat
                                              .contains('Kambing') ||
                                          filteredData[index]
                                              .jenisZakat
                                              .contains('Sapi')
                                      ? Icons.quora_outlined
                                      : Icons.monetization_on_outlined,
                                  color: FlutterFlowTheme.of(context).tertiary,
                                  size: 24.0,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsetsDirectional.only(start: 12.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    filteredData[index].jenisZakat,
                                    style: FlutterFlowTheme.of(context)
                                        .headlineSmall,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 4.0, 0.0, 0.0),
                                    child: Text(
                                      DateFormat('dd MMMM yyyy').format(
                                          DateTime.parse(
                                              filteredData[index].tanggal)),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium,
                                          overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                12.0, 0.0, 12.0, 0.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  filteredData[index].jumlah.replaceAll('.00', ''),
                                  textAlign: TextAlign.end,
                                  style: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Lexend',
                                        color: FlutterFlowTheme.of(context)
                                            .tertiary,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (filteredData[index].status == 'pending')
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 4.0, 0.0, 0.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        _setSnap(filteredData[index].snap);
                                      },
                                      child: Text(
                                        'Lanjut Bayar?',
                                        textAlign: TextAlign.end,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Lexend',
                                              fontSize: 12.0,
                                              color: const Color.fromARGB(
                                                  255, 255, 0, 0),
                                            ),
                                      ),
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
              ),
            );
          }
        },
      ),
    );
  }
}

class CustomTab extends StatelessWidget {
  final String text;

  CustomTab({required this.text});

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
