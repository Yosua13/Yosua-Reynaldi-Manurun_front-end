import 'package:frontend/app/modules/barang/bindings/barang_binding.dart';
import 'package:frontend/app/modules/barang/views/barang_list_view.dart';
import 'package:frontend/app/routes/app_routes.dart';
import 'package:get/get.dart';

class AppPages {
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => BarangListView(),
      binding: BarangBinding(),
    ),
  ];
}
