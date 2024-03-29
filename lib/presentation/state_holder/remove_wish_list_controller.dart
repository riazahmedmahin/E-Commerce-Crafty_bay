import 'package:get/get.dart';

import '../../data/services/network_caller.dart';
import '../../data/utility/urls.dart';

class RemoveWishListController extends GetxController {
  bool _inProgress = false;

  bool get inProgress => _inProgress;

  String _errorMessage = '';

  String get errorMessage => _errorMessage;

  Future<bool> removeWishListItem(
    int productId,
  ) async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    final response = await NetworkCaller().getRequest(
      Urls.removeWishList(productId),
    );
    _inProgress = false;
    if (response.isSuccess) {
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }
    update();
    return isSuccess;
  }
}
