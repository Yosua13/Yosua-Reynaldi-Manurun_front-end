// Helper function untuk parsing cepat
import 'dart:convert';

Kategori kategoriFromJson(String str) => Kategori.fromJson(json.decode(str));

class Kategori {
  final int id;
  final String namaKategori;

  Kategori({required this.id, required this.namaKategori});

  // Factory constructor untuk membuat instance Kategori dari JSON map
  factory Kategori.fromJson(Map<String, dynamic> json) =>
      Kategori(id: json["id"], namaKategori: json["nama_kategori"]);
}
