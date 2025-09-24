import 'package:frontend/app/data/models/kategori_model.dart';
import 'package:frontend/app/data/providers/kategori_provider.dart';

class KategoriRepository {
  final KategoriProvider _kategoriProvider;
  KategoriRepository(this._kategoriProvider);

  Future<List<Kategori>> getKategori() => _kategoriProvider.fetchKategori();
}
