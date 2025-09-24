class Barang {
  final int id;
  final String namaBarang;
  final int stok;
  final String kelompokBarang;
  final String kategori;
  final int harga;

  Barang({
    required this.id,
    required this.namaBarang,
    required this.stok,
    required this.kelompokBarang,
    required this.kategori,
    required this.harga,
  });

  factory Barang.fromJson(Map<String, dynamic> json) => Barang(
    id: json["id"],
    namaBarang: json["nama_barang"],
    stok: json["stok"],
    kelompokBarang: json["kelompok_barang"],
    kategori: json["kategori"],
    harga: json["harga"],
  );
}
