import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/app/widgets/build_label.dart';
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
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            shadowColor: Theme.of(context).colorScheme.shadow,
            elevation: 4,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Iconsax.save_2,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
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
                BuildLabel('Nama Barang', context),
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

                BuildLabel('Kategori Barang', context),
                Obx(
                  () => DropdownButtonFormField2<Kategori>(
                    value: controller.selectedKategori.value,
                    items: Kategori.values.map((kategori) {
                      return DropdownMenuItem(
                        value: kategori,
                        child: Text(kategori.apiValue),
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

                    isExpanded: true,
                    dropdownStyleData: DropdownStyleData(
                      width: MediaQuery.of(context).size.width - 48,
                      offset: const Offset(0, -5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                BuildLabel('Kelompok Barang', context),
                Obx(
                  () => DropdownButtonFormField2<KelompokBarang>(
                    value: controller.selectedKelompok.value,
                    isExpanded: true,
                    items: KelompokBarang.values.map((kelompok) {
                      return DropdownMenuItem(
                        value: kelompok,
                        child: Text(kelompok.apiValue),
                      );
                    }).toList(),
                    selectedItemBuilder: (BuildContext context) {
                      return KelompokBarang.values.map<Widget>((item) {
                        return Text(
                          item.apiValue,
                          overflow: TextOverflow.ellipsis,
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

                    dropdownStyleData: DropdownStyleData(
                      width: MediaQuery.of(context).size.width - 48,
                      offset: const Offset(0, -5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                BuildLabel('Stok', context),
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
                BuildLabel('Harga', context),
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
