import 'package:flutter/material.dart';
import 'package:frontend/app/modules/barang/controllers/barang_controller.dart';
import 'package:frontend/app/modules/barang/views/barang_detail_bottomsheet.dart';
import 'package:frontend/app/modules/barang/views/barang_form_view.dart';
import 'package:frontend/utils/currentcy_formatter.dart';
import 'package:get/get.dart';

class BarangListView extends GetView<BarangController> {
  const BarangListView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Obx(
          () => Text(
            controller.isSelectionMode.value
                ? '${controller.selectedIds.length} dipilih'
                : 'Daftar Barang',
          ),
        ),
        actions: [
          Obx(
            () => controller.isSelectionMode.value
                ? IconButton(
                    icon: const Icon(Icons.delete_outline),
                    tooltip: "Hapus Pilihan",
                    onPressed: controller.selectedIds.isEmpty
                        ? null
                        : () => controller.deleteBulkBarang(),
                  )
                : IconButton(
                    icon: const Icon(Icons.select_all),
                    tooltip: "Pilih Beberapa",
                    onPressed: () => controller.toggleSelectionMode(),
                  ),
          ),
          IconButton(
            icon: Icon(
              Get.isDarkMode
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
            tooltip: "Ganti Tema",
            onPressed: () {
              Get.changeThemeMode(
                Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
              );
            },
          ),
        ],
        leading: Obx(
          () => controller.isSelectionMode.value
              ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => controller.toggleSelectionMode(),
                )
              : const SizedBox.shrink(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => controller.fetchBarang(),
        child: Column(
          children: [
            // --- WIDGET RINGKASAN ---
            _buildSummaryCard(theme),

            // --- WIDGET PENCARIAN ---
            _buildSearchBar(),

            _buildDebugSelection(),

            // --- LIST BARANG ---
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.barangList.isEmpty) {
                  // --- TAMPILAN DATA KOSONG ---
                  return _buildEmptyState();
                }
                return ListView.builder(
                  itemCount: controller.barangList.length,
                  itemBuilder: (context, index) {
                    final barang = controller.barangList[index];
                    return Obx(() {
                      final isSelected = controller.selectedIds.contains(
                        barang.id,
                      );
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        child: ListTile(
                          onTap: () {
                            if (controller.isSelectionMode.value) {
                              controller.toggleSelection(barang.id);
                            } else {
                              showBarangDetailBottomSheet(context, barang);
                            }
                          },
                          onLongPress: () {
                            if (!controller.isSelectionMode.value) {
                              controller.toggleSelectionMode();
                              controller.toggleSelection(barang.id);
                            }
                          },
                          leading: controller.isSelectionMode.value
                              ? Checkbox(
                                  value: isSelected,
                                  onChanged: (value) =>
                                      controller.toggleSelection(barang.id),
                                  activeColor: theme.colorScheme.primary,
                                )
                              : CircleAvatar(
                                  child: Text(
                                    barang.namaBarang[0].toUpperCase(),
                                  ),
                                ),
                          title: Text(
                            barang.namaBarang,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Stok: ${barang.stok} • ${barang.kategori}',
                          ),
                          trailing: Text(
                            CurrencyFormatter.format(barang.harga),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.primary,
                              fontSize: 14,
                            ),
                          ),
                          tileColor: isSelected
                              ? theme.colorScheme.primary.withOpacity(0.1)
                              : null,
                        ),
                      );
                    });
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: Obx(
        () => controller.isSelectionMode.value
            ? const SizedBox.shrink()
            : FloatingActionButton.extended(
                onPressed: () {
                  controller.prepareForm(null);
                  Get.to(() => BarangFormView());
                },
                icon: const Icon(Icons.add),
                label: const Text('Tambah Barang'),
              ),
      ),
    );
  }

  Widget _buildDebugSelection() {
    return Obx(() {
      if (!controller.isSelectionMode.value || controller.selectedIds.isEmpty) {
        return const SizedBox.shrink(); // Sembunyikan jika tidak dalam mode seleksi
      }
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Colors.amber.withOpacity(0.2),
        child: Text(
          "Debug - ID Terpilih: ${controller.selectedIds.join(', ')}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    });
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: Obx(
        () => TextField(
          controller: controller.searchController,
          focusNode: controller.searchFocusNode,
          onChanged: controller.onSearchChanged,
          onSubmitted: (_) => controller.unfocusKeyboard(),
          decoration: InputDecoration(
            hintText: 'Cari nama barang...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            contentPadding: EdgeInsets.zero,
            suffixIcon: controller.showClearButton.value
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: controller.clearSearch,
                  )
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(ThemeData theme) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      color: theme.colorScheme.primaryContainer.withOpacity(0.5),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _summaryItem(
                    'Total Barang',
                    controller.totalBarang.value.toString(),
                    theme,
                  ),
                  _summaryItem(
                    'Jenis Kategori',
                    controller.totalKategori.value.toString(),
                    theme,
                  ),
                ],
              ),
              if (controller.kategoriSummary.isNotEmpty) ...[
                const Divider(height: 20),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: controller.kategoriSummary.entries.map((entry) {
                    return Chip(
                      label: Text('${entry.key}: ${entry.value}'),
                      backgroundColor: theme.colorScheme.secondaryContainer,
                      side: BorderSide.none,
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryItem(String title, String value, ThemeData theme) {
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        Text(
          title,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/gambar-kosong.png', width: Get.width * 0.5),
            const SizedBox(height: 16),
            const Text(
              'Belum ada barang.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              controller.searchController.text.isEmpty
                  ? 'Ketuk tombol + untuk menambah data baru.'
                  : 'Coba kata kunci lain atau hapus filter.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
