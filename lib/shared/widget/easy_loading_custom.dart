import 'package:flutter_easyloading/flutter_easyloading.dart';

Future<T> performLoading<T>(Future<T> future, String status,
    [String? successMessage, String? errorMessage]) async {
  EasyLoading.show(status: status);
  try {
    T result = await future;
    await Future.delayed(const Duration(seconds: 1));
    EasyLoading.dismiss();
    if (successMessage != null) {
      EasyLoading.showSuccess(successMessage);
    }
    return result;
  } catch (e) {
    await Future.delayed(const Duration(seconds: 1));
    EasyLoading.dismiss();
    if (errorMessage != null) {
      EasyLoading.showError(errorMessage);
    }
    rethrow;
  }
}
