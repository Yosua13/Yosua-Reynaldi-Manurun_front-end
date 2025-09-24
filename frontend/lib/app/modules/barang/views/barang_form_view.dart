import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import '../../../data/models/barang_enums.dart';
import '../controllers/barang_controller.dart';

class BarangFormView extends GetView<BarangController> {
  const BarangFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.isEditMode.value ? 'Edit Barang' : 'Tambah Barang',
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(
          16.0,
        ).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom + 16.0),
        child: ElevatedButton(
          onPressed: controller.saveBarang,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Iconsax.save_2),
              const SizedBox(width: 8),
              Text(
                'Simpan',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Input Nama Barang (tidak ada perubahan) ---
                _buildLabel('Nama Barang', context),
                TextFormField(
                  controller: controller.namaController,
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Nama barang tidak boleh kosong'
                      : null,
                  decoration: _buildInputDecoration(
                    hintText: 'Masukkan nama barang',
                    icon: Iconsax.box_1,
                    context: context,
                  ),
                ),
                const SizedBox(height: 20),

                // --- Dropdown Kategori (DISESUAIKAN) ---
                _buildLabel('Kategori Barang', context),
                // Tidak perlu Obx atau loading indicator lagi
                Obx(
                  () => DropdownButtonFormField<Kategori>(
                    value: controller.selectedKategori.value,
                    // Mengambil daftar item dari enum Kategori
                    items: Kategori.values.map((kategori) {
                      return DropdownMenuItem(
                        value: kategori,
                        child: Text(
                          kategori.apiValue,
                        ), // Menampilkan teks yang sesuai
                      );
                    }).toList(),
                    onChanged: (value) =>
                        controller.selectedKategori.value = value,
                    validator: (value) =>
                        (value == null) ? 'Kategori harus dipilih' : null,
                    decoration: _buildInputDecoration(
                      hintText: 'Pilih kategori',
                      icon: Iconsax.category,
                      context: context,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // --- Dropdown Kelompok Barang (DISESUAIKAN) ---
                _buildLabel('Kelompok Barang', context),
                Obx(
                  () => DropdownButtonFormField<KelompokBarang>(
                    value: controller.selectedKelompok.value,
                    isExpanded: true, // Membuat dropdown selebar mungkin
                    items: KelompokBarang.values.map((kelompok) {
                      return DropdownMenuItem(
                        value: kelompok,
                        child: Text(kelompok.apiValue),
                      );
                    }).toList(),
                    // Mengatur tampilan item yang terpilih agar tidak overflow
                    selectedItemBuilder: (BuildContext context) {
                      return KelompokBarang.values.map<Widget>((item) {
                        return Text(
                          item.apiValue,
                          overflow: TextOverflow
                              .ellipsis, // Memberi titik-titik jika terlalu panjang
                          maxLines: 1,
                        );
                      }).toList();
                    },
                    onChanged: (value) =>
                        controller.selectedKelompok.value = value,
                    validator: (value) => (value == null)
                        ? 'Kelompok barang harus dipilih'
                        : null,
                    decoration: _buildInputDecoration(
                      hintText: 'Pilih kelompok barang',
                      icon: Iconsax.shapes,
                      context: context,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // --- Input Stok & Harga (tidak ada perubahan) ---
                _buildLabel('Stok', context),
                TextFormField(
                  controller: controller.stokController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Stok tidak boleh kosong'
                      : null,
                  decoration: _buildInputDecoration(
                    hintText: 'Masukkan jumlah stok',
                    icon: Iconsax.box_add,
                    context: context,
                  ),
                ),
                const SizedBox(height: 20),
                _buildLabel('Harga', context),
                TextFormField(
                  controller: controller.hargaController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CurrencyInputFormatter(),
                  ],
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Harga tidak boleh kosong'
                      : null,
                  decoration: _buildInputDecoration(
                    hintText: 'Masukkan harga barang',
                    icon: Iconsax.money,
                    context: context,
                    prefixText: 'Rp ',
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget dan function lainnya tidak ada perubahan
  Widget _buildLabel(String text, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData icon,
    required BuildContext context,
    String? prefixText,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixText: prefixText,
      prefixIcon: Icon(icon, size: 20),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
      ),
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }
    final int value = int.parse(newValue.text.replaceAll('.', ''));
    final formatter = NumberFormat.decimalPattern('id_ID');
    final newString = formatter.format(value);
    return newValue.copyWith(
      text: newString,
      selection: TextSelection.collapsed(offset: newString.length),
    );
  }
}
