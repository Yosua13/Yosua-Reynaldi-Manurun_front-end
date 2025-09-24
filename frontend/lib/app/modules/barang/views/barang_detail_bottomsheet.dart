import 'package:flutter/material.dart';
import 'package:frontend/app/data/models/barang_model.dart';
import 'package:frontend/app/modules/barang/controllers/barang_controller.dart';
import 'package:frontend/app/modules/barang/views/barang_form_view.dart';
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
          _buildDetailRow('Nama Barang', barang.namaBarang),
          _buildDetailRow('Kategori', barang.kategori),
          _buildDetailRow('Kelompok', barang.kelompokBarang),
          _buildDetailRow('Stok', barang.stok.toString()),
          _buildDetailRow('Harga', CurrencyFormatter.format(barang.harga)),
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
                    Get.back(); // Close bottom sheet
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

Widget _buildDetailRow(String label, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: const TextStyle(color: Colors.grey)),
      Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
    ],
  );
}
