import 'package:frontend/app/data/models/barang_model.dart';
import 'package:frontend/app/data/providers/barang_provider.dart';

class BarangRepository {
  final BarangProvider _barangProvider;
  BarangRepository(this._barangProvider);

  Future<List<Barang>> getBarang({String? searchTerm}) =>
      _barangProvider.fetchBarang(searchTerm: searchTerm);
  Future<Barang> addBarang(Map<String, dynamic> data) =>
      _barangProvider.addBarang(data);
  Future<Barang> updateBarang(int id, Map<String, dynamic> data) =>
      _barangProvider.updateBarang(id, data);
  Future<Map<String, dynamic>> deleteBarang(int id) =>
      _barangProvider.deleteBarang(id);
  Future<Map<String, dynamic>> deleteBulkBarang(List<int> ids) =>
      _barangProvider.deleteBulkBarang(ids);
}
