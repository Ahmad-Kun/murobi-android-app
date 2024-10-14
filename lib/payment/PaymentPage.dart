import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:murobi_beta/models/list_qurban_model.dart';
import 'package:murobi_beta/models/qurban_form_model.dart';
import 'package:murobi_beta/models/user_model.dart';
import 'package:murobi_beta/utils/api.dart';
import 'package:murobi_beta/widget/constant_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class PaymentPages extends StatefulWidget {
  const PaymentPages({super.key});

  @override
  _PaymentPagesState createState() => _PaymentPagesState();
}

class _PaymentPagesState extends State<PaymentPages> {
  late final WebViewController _controller;
  String? _snapUrl;
  List<QurbanFormModel>? qurbanForm;
  UserModel? userModel;
  String? hargaEmas;
  double _zakat = 0;
  bool isHitung = false;
  final List<String> categories = [
    "Zakat Mal",
    "Zakat Fitrah",
    "Infaq/Shodaqoh",
    "Wakaf",
    "Qurban"
  ];

  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  List<TextEditingController> _shohibulControllers = [];
  final _noteController = TextEditingController();
  final _pendapatanController = TextEditingController();
  final _bonusController = TextEditingController();
  final _emailController = TextEditingController();

  void _updateAmount() {
    setState(() {
      if (selectedCategory == 'Qurban' && selectedQurbanType != null) {
        // Cari QurbanFormModel yang sesuai dengan selectedMasjid dan selectedQurbanType
        QurbanFormModel? selectedQurban = qurbanForm?.firstWhere(
          (qurban) =>
              qurban.masjidName == selectedMasjid &&
              qurban.list_qurban
                  .any((q) => q.nama_qurban == selectedQurbanType),
        );

        if (selectedQurban != null) {
          // Ambil harga dari list_qurban yang sesuai dengan selectedQurbanType
          ListQurbanModel? qurbanData = selectedQurban.list_qurban.firstWhere(
            (q) => q.nama_qurban == selectedQurbanType,
          );

          selectedQurbanType?.split(' ')[0] == "Sapi"
              ? _amountController.text = qurbanData.harga.replaceAll('.00', '')
              : _amountController.text =
                  (double.tryParse(qurbanData.harga)! * kambingCount)
                      .toString().replaceAll('.0', '');
        } else {
          _amountController.text = '';
        }
      } else {
        _amountController.text = '';
      }
    });
  }

  String? selectedCategory;
  String? selectedMasjid;
  final List<String> kambingAmounts =
      List.generate(7, (index) => '${index + 1} Ekor');
  String? selectedQurbanType;
  String? selectedKambingAmount;
  int kambingCount = 1;

  Future<void> _getDataForm() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('userToken');
    final String apiUrl = ApiConstants.baseUrl + ApiConstants.endPointForm;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'token': token}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        qurbanForm = List.from(data['dataQurban'])
            .map((item) => QurbanFormModel.fromJson(item))
            .toList();
        userModel = UserModel.fromJson(data['dataUser']);
        try {
          if (mounted) {
            setState(() {
              hargaEmas = data['emas'].toString();
            });
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Server error')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load data: $e')),
        );
      }
    }
  }

  Future<void> _checkData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('userToken');
    final String date = DateTime.now().toString();
    final amount =
        int.tryParse(_amountController.text.replaceAll(',', '')) ?? "";
    final Map<String, dynamic> data = {
      'token': token,
      'order_id':
          userModel!.id.toString() + date.replaceAll(RegExp(r'[- :.]'), ''),
      'user_id': userModel?.id,
      'masjid_id': qurbanForm
          ?.firstWhere((masjid) => masjid.masjidName == selectedMasjid)
          .masjid_id,
      'jenis_ziswaf_id': categories.indexOf(selectedCategory!) + 1,
      'first_name': userModel?.userName,
      'email': userModel?.userEmail,
      'jumlah_uang': amount,
      'note': _noteController.text,
      'nama_barang':
          selectedCategory == 'Qurban' ? selectedQurbanType?.split(' ')[0] : '',
      'jenis_barang': selectedCategory == 'Qurban' ? selectedQurbanType : '',
      'jumlah_barang': selectedCategory == 'Qurban'
          ? selectedQurbanType?.split(' ')[0] == 'Sapi'
              ? 1
              : int.tryParse(selectedKambingAmount!.split((' '))[0]) ?? ''
          : '',
      'nama_ziswaf': selectedCategory == 'Qurban'
          ? List<String>.generate(_shohibulControllers.length,
              (index) => _shohibulControllers[index].text)
          : '',
    };
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      debugPrint(json.encode(data));
    });
  }

  Future<void> _submitForm() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('userToken');
    final String apiUrl = ApiConstants.baseUrl + ApiConstants.endPointSubmit;
    final String date = DateTime.now().toString();

    final amount =
        int.tryParse(_amountController.text.replaceAll(',', '')) ?? "";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'token': token,
          'order_id':
              userModel!.id.toString() + date.replaceAll(RegExp(r'[- :.]'), ''),
          'user_id': userModel?.id,
          'masjid_id': qurbanForm
              ?.firstWhere((masjid) => masjid.masjidName == selectedMasjid)
              .masjid_id,
          'jenis_ziswaf_id': categories.indexOf(selectedCategory!) + 1,
          'first_name': userModel?.userName,
          'email': _emailController.text,
          'jumlah_uang': amount,
          'note': _noteController.text,
          'nama_barang': selectedCategory == 'Qurban'
              ? selectedQurbanType?.split(' ')[0]
              : '',
          'jenis_barang':
              selectedCategory == 'Qurban' ? selectedQurbanType : '',
          'jumlah_barang': selectedCategory == 'Qurban'
              ? selectedQurbanType?.split(' ')[0] == 'Sapi'
                  ? 1
                  : int.tryParse(selectedKambingAmount!.split((' '))[0]) ?? ''
              : '',
          'nama_ziswaf': selectedCategory == 'Qurban'
              ? List<String>.generate(_shohibulControllers.length,
                  (index) => _shohibulControllers[index].text)
              : [userModel?.userName],
        }),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _snapUrl = data['snapUrl'];
          _controller = WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setNavigationDelegate(
              NavigationDelegate(
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
              ),
            )
            ..loadRequest(Uri.parse(_snapUrl!));
        });
        debugPrint('Snap Url: $_snapUrl');
      } else {
        if (mounted)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to Get Snap')),
          );
        debugPrint(response.body);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load data: $e')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getDataForm();
    _shohibulControllers = List.generate(
      7,
      (index) => TextEditingController(),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _bonusController.dispose();
    _pendapatanController.dispose();
    _noteController.dispose();
    _emailController.dispose();
    _shohibulControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'Formulir Sumbangan', true),
      body: _snapUrl != null
          ? WebViewWidget(controller: _controller)
          : decorationBuilder(
              context,
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: qurbanForm != null
                    ? DefaultTabController(
                        length: 2,
                        child: Column(
                          children: <Widget>[
                            Container(
                              constraints:
                                  const BoxConstraints.expand(height: 50),
                              child: const TabBar(
                                tabs: [
                                  Tab(text: "Bayar"),
                                  Tab(text: "Kalkulator Zakat"),
                                ],
                              ),
                            ),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Form(
                                          key: _formKey,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 10),
                                              textLapkeuBuild(
                                                  context,
                                                  "Pilih Masjid : ",
                                                  FontWeight.bold,
                                                  14,
                                                  Colors.black),
                                              Container(
                                                child: DropdownButtonFormField<
                                                    String>(
                                                  value: selectedMasjid,
                                                  items: qurbanForm?.map(
                                                      (QurbanFormModel qfm) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: qfm.masjidName,
                                                      child: Text(
                                                        qfm.masjidName,
                                                        textAlign:
                                                            TextAlign.start,
                                                        overflow:
                                                            TextOverflow.clip,
                                                        style: const TextStyle(
                                                          fontFamily: 'poppins',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 14,
                                                          color:
                                                              Color(0xff000000),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      selectedMasjid =
                                                          newValue!;
                                                      selectedQurbanType = null;
                                                    });
                                                  },
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Silahkan Pilih Masjid!';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                "Pilih Kategori Sumbangan:",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              DropdownButtonFormField<String>(
                                                value: selectedCategory,
                                                items: categories
                                                    .map((String category) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: category,
                                                    child: Text(
                                                      category,
                                                      style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (newValue) {
                                                  setState(
                                                    () {
                                                      selectedCategory =
                                                          newValue!;
                                                      selectedKambingAmount =
                                                          selectedCategory ==
                                                                  "Qurban"
                                                              ? kambingAmounts
                                                                  .first
                                                              : null;
                                                      kambingCount = 1;
                                                      selectedQurbanType = null;
                                                      _updateAmount();
                                                    },
                                                  );
                                                },
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Silahkan Pilih Sumbangan!';
                                                  }
                                                  return null;
                                                },
                                              ),
                                              if (selectedCategory ==
                                                  "Qurban") ...[
                                                SizedBox(height: 10),
                                                textLapkeuBuild(
                                                    context,
                                                    "Pilih Hewan Qurban : ",
                                                    FontWeight.bold,
                                                    14,
                                                    Colors.black),
                                                DropdownButtonFormField<String>(
                                                  value: selectedQurbanType,
                                                  items: qurbanForm
                                                      ?.where((qurban) =>
                                                          qurban.masjidName ==
                                                          selectedMasjid)
                                                      .expand((qurban) => qurban
                                                          .list_qurban
                                                          .map((q) =>
                                                              q.nama_qurban))
                                                      .map((namaQurban) =>
                                                          DropdownMenuItem<
                                                              String>(
                                                            value: namaQurban,
                                                            child: Text(
                                                              namaQurban,
                                                              style:
                                                                  const TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ))
                                                      .toList(),
                                                  onChanged: (newValue) {
                                                    setState(
                                                      () {
                                                        selectedQurbanType =
                                                            newValue;
                                                        kambingCount = 1;
                                                        selectedKambingAmount =
                                                            kambingAmounts
                                                                .first;
                                                        _shohibulControllers =
                                                            selectedQurbanType?.split(
                                                                            ' ')[
                                                                        0] ==
                                                                    "Sapi"
                                                                ? List.generate(
                                                                    7,
                                                                    (index) =>
                                                                        TextEditingController())
                                                                : List.generate(
                                                                    kambingCount,
                                                                    (index) =>
                                                                        TextEditingController());
                                                        _updateAmount();
                                                      },
                                                    );
                                                  },
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Silahkan Pilih Hewan Qurban!';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                if (selectedQurbanType
                                                        ?.split(' ')[0] ==
                                                    "Sapi") ...[
                                                  SizedBox(height: 10),
                                                  textLapkeuBuild(
                                                      context,
                                                      "Masukan Shohibul Qurban : ",
                                                      FontWeight.bold,
                                                      14,
                                                      Colors.black),
                                                ],
                                                if (selectedQurbanType
                                                        ?.split(' ')[0] ==
                                                    "Kambing") ...[
                                                  DropdownButtonFormField<
                                                      String>(
                                                    value:
                                                        selectedKambingAmount,
                                                    items: kambingAmounts
                                                        .map((String amount) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: amount,
                                                        child: Text(
                                                          amount,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        selectedKambingAmount =
                                                            newValue;
                                                        kambingCount =
                                                            int.parse(newValue!
                                                                .split(' ')[0]);
                                                        _shohibulControllers =
                                                            List.generate(
                                                          kambingCount,
                                                          (index) =>
                                                              TextEditingController(),
                                                        );
                                                        _updateAmount();
                                                      });
                                                    },
                                                  ),
                                                  SizedBox(height: 10),
                                                  textLapkeuBuild(
                                                      context,
                                                      "Masukan Shohibul Qurban : ",
                                                      FontWeight.bold,
                                                      14,
                                                      Colors.black),
                                                  ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    itemCount: kambingCount,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Column(
                                                        children: [
                                                          SizedBox(height: 10),
                                                          TextFormField(
                                                            controller:
                                                                _shohibulControllers[
                                                                    index],
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  "Nama Shohibul Qurban ${index + 1}",
                                                              border:
                                                                  OutlineInputBorder(),
                                                            ),
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Tolong Isi Shohibul Qurban ${index + 1}!';
                                                              }
                                                              return null;
                                                            },
                                                          )
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ] else if (selectedQurbanType
                                                        ?.split(' ')[0] ==
                                                    "Sapi") ...[
                                                  ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    itemCount: 7,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Column(
                                                        children: [
                                                          SizedBox(height: 10),
                                                          TextFormField(
                                                            controller:
                                                                _shohibulControllers[
                                                                    index],
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  "Nama Shohibul Qurban ${index + 1}",
                                                              border:
                                                                  OutlineInputBorder(),
                                                            ),
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Tolong Isi Shohibul Qurban ${index + 1}!';
                                                              }
                                                              return null;
                                                            },
                                                          )
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ],
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 16.0),
                                                child: TextFormField(
                                                  controller: _amountController,
                                                  readOnly: selectedCategory ==
                                                          'Qurban'
                                                      ? true
                                                      : false,
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText:
                                                        'Masukan Nominal Donasi : ',
                                                    border:
                                                        OutlineInputBorder(),
                                                    prefixText: 'Rp ',
                                                  ),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty || value == "0") {
                                                      return 'Nominal donasi tidak boleh kosong!';
                                                    }
                                                    return null;
                                                  },
                                                  inputFormatters: [
                                                    CurrencyInputFormatter()
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 16.0),
                                                child: TextFormField(
                                                  controller: _emailController,
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText:
                                                        'Masukan Gmail Anda : ',
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Alamat Gmail Tidak Boleh Kosong!';
                                                    }
                                                    if (!value
                                                        .toLowerCase()
                                                        .endsWith(
                                                            '@gmail.com')) {
                                                      return 'Masukan Alamat Email Valid!';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 16.0),
                                                child: TextFormField(
                                                  controller: _noteController,
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText:
                                                        'Catatan Tambahan',
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                  maxLines: 3,
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              Container(
                                                width: double.infinity,
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      _submitForm();
                                                      // _checkData();
                                                    }
                                                  },
                                                  child: const Text('Submit'),
                                                ),
                                              ),
                                              SizedBox(height: 20)
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 10),
                                        // Harga emas rata tengah
                                        Center(
                                          child: textLapkeuBuild(
                                            context,
                                            "Harga emas saat ini: Rp $hargaEmas/gr",
                                            FontWeight.w800,
                                            18,
                                            Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        // Jumlah pendapatan per bulan
                                        textLapkeuBuild(
                                          context,
                                          "Jumlah pendapatan per bulan",
                                          FontWeight.w800,
                                          18,
                                          Colors.black,
                                        ),
                                        SizedBox(height: 10),
                                        // Input pendapatan
                                        Container(
                                          child: TextFormField(
                                            controller: _pendapatanController,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              prefixText: "Rp ",
                                            ),
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              CurrencyInputFormatter()
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        // Bonus, THR dan lainnya
                                        textLapkeuBuild(
                                          context,
                                          "Bonus, THR dan lainnya",
                                          FontWeight.w800,
                                          18,
                                          Colors.black,
                                        ),
                                        SizedBox(height: 10),
                                        Container(
                                          child: TextFormField(
                                            controller: _bonusController,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              prefixText: "Rp ",
                                            ),
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              CurrencyInputFormatter()
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        // Tombol Hitung dan Reset
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  _pendapatanController.clear();
                                                  _bonusController.clear();
                                                  setState(() {
                                                    isHitung = false;
                                                    _zakat = 0;
                                                  });
                                                },
                                                child: const Text('Reset'),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  double? pendapatan =
                                                      parseCurrency(
                                                          _pendapatanController
                                                              .text);
                                                  double? bonus = parseCurrency(
                                                      _bonusController.text);
                                                  double hitung =
                                                      pendapatan + bonus;
                                                  double? emas =
                                                      double.tryParse(
                                                          hargaEmas!);
                                                  _zakat =
                                                      hitung >= emas! * 85 / 12
                                                          ? hitung * 0.025
                                                          : 0;
                                                  setState(() {
                                                    isHitung = true;
                                                  });
                                                },
                                                child: const Text('Hitung'),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        // Informasi zakat jika sudah dihitung
                                        if (isHitung)
                                          Container(
                                            width: double.infinity,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  textLapkeuBuild(
                                                    context,
                                                    "Jumlah zakat penghasilan Anda:",
                                                    FontWeight.normal,
                                                    18,
                                                    Colors.black,
                                                  ),
                                                  textLapkeuBuild(
                                                    context,
                                                    "Rp $_zakat",
                                                    FontWeight.w800,
                                                    30,
                                                    Colors.black,
                                                  ),
                                                  if (_zakat == 0)
                                                    textLapkeuBuild(
                                                      context,
                                                      "Penghasilan Anda belum mencapai nishab.",
                                                      FontWeight.normal,
                                                      14,
                                                      Colors.black,
                                                    ),
                                                ],
                                              ),
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
                      )
                    : Center(
                        child: Column(
                          children: [
                            textLapkeuBuild(context, 'Loading Data...',
                                FontWeight.w800, 18, Colors.black),
                            CircularProgressIndicator(),
                          ],
                        ),
                      ),
              ),
            ),
    );
  }

  double parseCurrency(String value) {
    return double.tryParse(value.replaceAll(',', '')) ?? 0.0;
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final formatter = NumberFormat('#,###.##');
    final newText = newValue.text.replaceAll(',', '');
    final num = double.tryParse(newText);
    final formattedText = formatter.format(num);

    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
