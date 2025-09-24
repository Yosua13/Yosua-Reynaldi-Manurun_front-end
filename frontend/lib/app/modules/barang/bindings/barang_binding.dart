import 'package:frontend/app/data/providers/barang_provider.dart';
import 'package:frontend/app/data/repositories/barang_repository.dart';
import 'package:get/get.dart';
import 'package:frontend/app/modules/barang/controllers/barang_controller.dart';

class BarangBinding extends Bindings {
  @override
  void dependencies() {
    // Providers
    Get.lazyPut<BarangProvider>(() => BarangProvider());

    // Repositories
    Get.lazyPut<BarangRepository>(() => BarangRepository(Get.find()));

    // Controller (sekarang hanya butuh BarangRepository)
    Get.lazyPut<BarangController>(() => BarangController(Get.find()));
  }
}
