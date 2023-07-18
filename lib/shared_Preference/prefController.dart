import 'package:get/get.dart';

class PrefController extends GetxController {
  static PrefController get to => Get.put(PrefController());

  RxString token = '-'.obs;
  RxString email = '-'.obs;
  RxString password = '-'.obs;
  RxString user_id = '-'.obs;

  clear() {
    token.value = '-';
    email.value = '-';
    password.value = '-';
    user_id.value = '-';
  }
}
