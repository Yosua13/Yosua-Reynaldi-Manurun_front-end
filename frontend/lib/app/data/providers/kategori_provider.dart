import 'dart:convert';
import 'package:frontend/app/config/app_constants.dart';
import 'package:frontend/app/data/models/kategori_model.dart';
import 'package:http/http.dart' as http;

class KategoriProvider {
  // Fungsi untuk memanggil endpoint GET /kategori
  Future<List<Kategori>> fetchKategori() async {
    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/kategori'),
    );

    if (response.statusCode == 200) {
      // Jika sukses, decode JSON array dan map menjadi list objek Kategori
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Kategori.fromJson(data)).toList();
    } else {
      throw Exception('Gagal memuat data kategori dari API');
    }
  }
}
