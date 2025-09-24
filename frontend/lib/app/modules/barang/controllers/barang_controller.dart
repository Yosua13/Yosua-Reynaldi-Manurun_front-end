import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/app/data/models/barang_enums.dart';
import 'package:frontend/app/data/models/barang_model.dart';
import 'package:frontend/app/data/repositories/barang_repository.dart';
import 'package:get/get.dart';

class BarangController extends GetxController {
  final BarangRepository barangRepository;
  BarangController(this.barangRepository);

  final barangList = <Barang>[].obs;
  final isLoading = true.obs;

  final totalBarang = 0.obs;
  final totalKategori = 0.obs;
  final kategoriSummary = <String, int>{}.obs;

  final isSelectionMode = false.obs;
  final selectedIds = <int>{}.obs;

  // State pencarian
  final searchController = TextEditingController();
  Timer? _debounce;
  final showClearButton = false.obs;
  final searchFocusNode = FocusNode();

  // State untuk form
  final formKey = GlobalKey<FormState>();
  final namaController = TextEditingController();
  final stokController = TextEditingController();
  final hargaController = TextEditingController();
  final selectedKategori = Rx<Kategori?>(null);
  final selectedKelompok = Rx<KelompokBarang?>(null);

  // State untuk menyimpan data barang saat mode edit
  final isEditMode = false.obs;
  Barang? _editableBarang;

  @override
  void onInit() {
    super.onInit();
    _setupFormFromArguments();
    fetchBarang();
    ever(barangList, (_) => _updateSummary());
    searchController.addListener(_onSearchFieldChanged);
  }

  void prepareForm(Barang? barang) {
    if (barang != null) {
      isEditMode.value = true;
      _editableBarang = barang;
      fillForm(barang);
    } else {
      isEditMode.value = false;
      _editableBarang = null;
      clearForm();
    }
  }

  void saveBarang() {
    if (isEditMode.value) {
      _updateBarang();
    } else {
      _addBarang();
    }
  }

  void _updateBarang() async {
    if (formKey.currentState!.validate()) {
      try {
        final data = {
          "nama_barang": namaController.text,
          "stok": int.parse(stokController.text),
          "harga": int.parse(hargaController.text.replaceAll('.', '')),
          "kategori": selectedKategori.value!.apiValue,
          "kelompok_barang": selectedKelompok.value!.apiValue,
        };
        await barangRepository.updateBarang(_editableBarang!.id, data);
        Get.back();
        fetchBarang();
        Get.snackbar(
          'Sukses',
          'Barang berhasil diperbarui',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } catch (e) {
        Get.snackbar('Error', 'Gagal memperbarui barang: ${e.toString()}');
      }
    }
  }

  void _addBarang() async {
    if (formKey.currentState!.validate()) {
      try {
        final data = {
          "nama_barang": namaController.text,
          "stok": int.parse(stokController.text),
          "harga": int.parse(hargaController.text.replaceAll('.', '')),
          "kategori": selectedKategori.value!.apiValue,
          "kelompok_barang": selectedKelompok.value!.apiValue,
        };
        await barangRepository.addBarang(data);
        Get.back();
        fetchBarang();
        Get.snackbar(
          'Sukses',
          'Barang berhasil ditambahkan',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } catch (e) {
        Get.snackbar('Error', 'Gagal menambahkan barang: ${e.toString()}');
      }
    }
  }

  void _setupFormFromArguments() {
    if (Get.arguments != null && Get.arguments is Barang) {
      isEditMode.value = true;
      _editableBarang = Get.arguments as Barang;
      fillForm(_editableBarang!);
    } else {
      isEditMode.value = false;
      _editableBarang = null;
      clearForm();
    }
  }

  @override
  void onClose() {
    _debounce?.cancel();
    searchController.dispose();
    searchController.removeListener(_onSearchFieldChanged);
    searchFocusNode.dispose();
    super.onClose();
  }

  void _onSearchFieldChanged() {
    showClearButton.value = searchController.text.isNotEmpty;
  }

  void unfocusKeyboard() {
    FocusScope.of(Get.context!).unfocus();
  }

  void clearSearch() {
    searchController.clear();
    fetchBarang();
    unfocusKeyboard();
  }

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchBarang(searchTerm: query);
    });
  }

  void _updateSummary() {
    totalBarang.value = barangList.length;
    final uniqueKategori = <String>{};
    final summary = <String, int>{};

    for (var barang in barangList) {
      final kategoriName = barang.kategori;
      uniqueKategori.add(kategoriName);
      summary[kategoriName] = (summary[kategoriName] ?? 0) + 1;
    }
    totalKategori.value = uniqueKategori.length;
    kategoriSummary.assignAll(summary);
  }

  void fetchBarang({String? searchTerm}) async {
    try {
      isLoading.value = true;
      var result = await barangRepository.getBarang(searchTerm: searchTerm);
      barangList.assignAll(result);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat data barang: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi addBarang diubah sedikit untuk menggunakan state controller
  void addBarang() async {
    if (formKey.currentState!.validate()) {
      try {
        final data = {
          "nama_barang": namaController.text,
          "stok": int.parse(stokController.text),
          "harga": int.parse(hargaController.text.replaceAll('.', '')),
          "kategori": selectedKategori.value!.apiValue,
          "kelompok_barang": selectedKelompok.value!.apiValue,
        };
        await barangRepository.addBarang(data);
        Get.back();
        fetchBarang();
        Get.snackbar(
          'Sukses',
          'Barang berhasil ditambahkan',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } catch (e) {
        Get.snackbar('Error', 'Gagal menambahkan barang: ${e.toString()}');
      }
    }
  }

  // Fungsi updateBarang diubah untuk menggunakan state controller
  void updateBarang() async {
    if (formKey.currentState!.validate()) {
      try {
        final data = {
          "nama_barang": namaController.text,
          "stok": int.parse(stokController.text),
          "harga": int.parse(hargaController.text.replaceAll('.', '')),
          "kategori": selectedKategori.value!.apiValue,
          "kelompok_barang": selectedKelompok.value!.apiValue,
        };
        // Ambil ID dari state _editableBarang
        await barangRepository.updateBarang(_editableBarang!.id, data);
        Get.back();
        fetchBarang();
        Get.snackbar(
          'Sukses',
          'Barang berhasil diperbarui',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } catch (e) {
        Get.snackbar('Error', 'Gagal memperbarui barang: ${e.toString()}');
      }
    }
  }

  void deleteBarang(int id) async {
    Get.defaultDialog(
      title: "Konfirmasi Hapus",
      middleText: "Apakah Anda yakin ingin menghapus barang ini?",
      onConfirm: () async {
        try {
          Get.back();
          final result = await barangRepository.deleteBarang(id);
          fetchBarang();
          Get.snackbar(
            'Sukses',
            result['message'] ?? 'Barang berhasil dihapus',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } catch (e) {
          Get.snackbar('Error', 'Gagal menghapus barang: ${e.toString()}');
        }
      },
      textConfirm: "Hapus",
      confirmTextColor: Colors.white,
      textCancel: "Batal",
    );
  }

  void deleteBulkBarang() async {
    if (selectedIds.isEmpty) return;
    Get.defaultDialog(
      title: "Konfirmasi Hapus",
      middleText:
          "Yakin ingin menghapus ${selectedIds.length} barang yang dipilih?",
      onConfirm: () async {
        try {
          Get.back(); // Tutup dialog konfirmasi
          final result = await barangRepository.deleteBulkBarang(
            selectedIds.toList(),
          );

          toggleSelectionMode();
          fetchBarang();

          Get.snackbar(
            'Sukses',
            result['message'] ?? '${selectedIds.length} barang dihapus',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } catch (e) {
          Get.snackbar(
            'Error',
            e.toString(),
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      },
      textConfirm: "Hapus Semua",
      confirmTextColor: Colors.white,
      textCancel: "Batal",
    );
  }

  void toggleSelectionMode() {
    isSelectionMode.value = !isSelectionMode.value;
    if (!isSelectionMode.value) {
      selectedIds.clear();
    }
  }

  void toggleSelection(int id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
  }

  void clearForm() {
    namaController.clear();
    stokController.clear();
    hargaController.clear();
    selectedKategori.value = null;
    selectedKelompok.value = null;
  }

  void fillForm(Barang barang) {
    namaController.text = barang.namaBarang;
    stokController.text = barang.stok.toString();
    hargaController.text = barang.harga.toString();
    selectedKategori.value = Kategori.fromApiValue(barang.kategori);
    selectedKelompok.value = KelompokBarang.fromApiValue(barang.kelompokBarang);
  }
}
