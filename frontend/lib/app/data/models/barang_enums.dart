enum Kategori {
  elektronik('Elektronik'),
  pakaianFashion('Pakaian (Fashion)'),
  kebutuhanRumahTangga('Kebutuhan Rumah Tangga'),
  makananMinuman('Makanan & Minuman'),
  kecantikanPerawatanDiri('Kecantikan & Perawatan Diri'),
  otomotif('Otomotif'),
  olahragaHobi('Olahraga & Hobi'),
  bukuAlatTulis('Buku & Alat Tulis'),
  digital('Digital');

  final String apiValue;
  const Kategori(this.apiValue);

  static Kategori fromApiValue(String value) {
    return Kategori.values.firstWhere(
      (e) => e.apiValue == value,
      orElse: () => Kategori.elektronik,
    );
  }
}

enum KelompokBarang {
  perangkatRumahTangga('Perangkat Rumah Tangga (TV, kulkas, mesin cuci)'),
  komputerLaptop('Komputer & Laptop'),
  smartphoneAksesoris('Smartphone & Aksesoris'),
  audioVideo('Audio & Video'),
  pakaian('Pakaian (kemeja, celana, jaket)'),
  aksesoriFashion('Aksesori (tas, ikat pinggang, perhiasan)'),
  alasKaki('Alas Kaki (sepatu, sandal)'),
  perabotan('Perabotan (meja, kursi, lemari)'),
  peralatanDapur('Peralatan Dapur (panci, wajan, kompor)'),
  alatKebersihan('Alat Kebersihan (sapu, pel, vacuum cleaner)'),
  makananSegar('Makanan Segar (buah, sayur, daging)'),
  makananKemasan('Makanan Kemasan (snack, mie instan)'),
  minuman('Minuman (air mineral, kopi, teh, jus)'),
  kosmetik('Kosmetik (lipstik, bedak)'),
  skincare('Skincare (serum, pelembab)'),
  perawatanRambut('Perawatan Rambut (sampo, conditioner)'),
  kebersihanTubuh('Kebersihan Tubuh (sabun, deodorant)'),
  kendaraan('Kendaraan (mobil, motor)'),
  sukuCadang('Suku Cadang'),
  aksesorisKendaraan('Aksesoris Kendaraan (helm, jok, cover motor)'),
  peralatanOlahraga('Peralatan Olahraga (bola, raket, matras yoga)'),
  pakaianSepatuOlahraga('Pakaian & Sepatu Olahraga'),
  hobi('Hobi (alat musik, perlengkapan berkebun, mainan)'),
  bukuMajalah('Buku & Majalah'),
  alatTulis('Alat Tulis (pulpen, pensil, penghapus)'),
  peralatanGambar('Peralatan Gambar (buku sketsa, spidol, cat air)'),
  ebookMajalahDigital('E-book & Majalah Digital'),
  perangkatLunak('Perangkat Lunak (software, aplikasi)'),
  kontenHiburan('Konten Hiburan (musik, video, film digital)'),
  lainnya('Lainnya');

  final String apiValue;
  const KelompokBarang(this.apiValue);

  static KelompokBarang fromApiValue(String value) {
    return KelompokBarang.values.firstWhere(
      (e) => e.apiValue == value,
      orElse: () => KelompokBarang.lainnya,
    );
  }
}
