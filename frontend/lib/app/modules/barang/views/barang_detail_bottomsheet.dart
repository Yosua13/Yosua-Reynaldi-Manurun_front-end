import 'package:flutter/material.dart';
import 'package:frontend/app/data/models/barang_model.dart';
import 'package:frontend/app/modules/barang/controllers/barang_controller.dart';
import 'package:frontend/app/modules/barang/views/barang_form_view.dart';
import 'package:frontend/app/widgets/build_detail_row.dart';
import 'package:frontend/utils/currentcy_formatter.dart';
import 'package:get/get.dart';

void showBarangDetailBottomSheet(BuildContext context, Barang barang) {
  final controller = Get.find<BarangController>();
  final theme = Theme.of(context);

  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(20),
      child: Wrap(
        runSpacing: 16,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Detail Barang', style: theme.textTheme.titleLarge),
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          BuildDetailRow('Nama Barang', barang.namaBarang),
          BuildDetailRow('Kategori', barang.kategori),
          BuildDetailRow('Kelompok', barang.kelompokBarang),
          BuildDetailRow('Stok', barang.stok.toString()),
          BuildDetailRow('Harga', CurrencyFormatter.format(barang.harga)),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Get.back();
                    controller.prepareForm(barang);
                    Get.to(() => BarangFormView());
                  },
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Edit'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.back();
                    controller.deleteBarang(barang.id);
                  },
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Hapus'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.error,
                    foregroundColor: theme.colorScheme.onError,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    backgroundColor: theme.cardColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true,
  );
}
