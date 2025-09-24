import 'dart:convert';
import 'package:frontend/app/config/app_constants.dart';
import 'package:frontend/app/data/models/barang_model.dart';
import 'package:http/http.dart' as http;

class BarangProvider {
  final _headers = {'Content-Type': 'application/json'};

  // GET /barang
  Future<List<Barang>> fetchBarang({String? searchTerm}) async {
    final uri = Uri.parse('${AppConstants.baseUrl}/barang').replace(
      queryParameters: searchTerm != null && searchTerm.isNotEmpty
          ? {'search': searchTerm}
          : null,
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Barang.fromJson(data)).toList();
    } else {
      throw Exception('Gagal memuat data barang');
    }
  }

  // POST /barang
  Future<Barang> addBarang(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/barang'),
      headers: _headers,
      body: json.encode(data),
    );
    if (response.statusCode == 201) {
      return Barang.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal menambah barang baru');
    }
  }

  // PATCH /barang/:id
  Future<Barang> updateBarang(int id, Map<String, dynamic> data) async {
    final response = await http.patch(
      Uri.parse('${AppConstants.baseUrl}/barang/$id'),
      headers: _headers,
      body: json.encode(data),
    );
    if (response.statusCode == 200) {
      return Barang.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal memperbarui barang');
    }
  }

  // DELETE /barang/:id
  Future<Map<String, dynamic>> deleteBarang(int id) async {
    final response = await http.delete(
      Uri.parse('${AppConstants.baseUrl}/barang/$id'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body); // Jika backend mengembalikan pesan
    } else {
      throw Exception('Gagal menghapus barang');
    }
  }

  // POST /barang/bulk-delete
  Future<Map<String, dynamic>> deleteBulkBarang(List<int> ids) async {
    final uri = Uri.parse('${AppConstants.baseUrl}/barang/bulk-delete');
    final headers = {'Content-Type': 'application/json; charset=UTF-8'};
    final body = json.encode({'ids': ids});

    try {
      final response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        final errorBody = json.decode(response.body);
        final errorMessage =
            errorBody['message'] ?? 'Terjadi kesalahan tidak diketahui';
        throw Exception('Gagal menghapus barang masal: $errorMessage');
      }
    } catch (e) {
      throw Exception('Tidak dapat terhubung ke server: ${e.toString()}');
    }
  }
}
