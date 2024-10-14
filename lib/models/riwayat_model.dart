class RiwayatModel {
  final String jumlah;
  final String tanggal;
  final String jenisZakat;
  final String status;
  final String snap;
  final String? namaBarang;

  RiwayatModel({
    required this.jumlah,
    required this.tanggal,
    required this.jenisZakat,
    required this.status,
    required this.snap,
    this.namaBarang,
  });

  factory RiwayatModel.fromJson(Map<String, dynamic> json) {
    return RiwayatModel(
      jumlah: json['jumlah'],
      tanggal: json['tanggal'],
      jenisZakat: json['jenisZakat'],
      status: json['status'],
      snap: json['snap'],
      namaBarang: json['namaBarang'],
    );
  } 
}
