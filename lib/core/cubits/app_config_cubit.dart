import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/conf/app_config.dart';
import '../utils/conf/app_config_helper.dart';

class AppConfigCubit extends Cubit<AppConfig> {
  final AppConfigHelper _configHelper;

  AppConfigCubit(this._configHelper) : super(_configHelper.getConfig());

  void updateCartValueLimit(double newLimit) async {
    final updatedConfig = state..cartValueLimit = newLimit;
    await _configHelper.updateConfig(updatedConfig);
    emit(updatedConfig);
  }

  void updateMaxOrderQuantity(int newQuantity) async {
    final updatedConfig = state..maxOrderQuantity = newQuantity;
    await _configHelper.updateConfig(updatedConfig);
    emit(updatedConfig);
  }

  void updateApiUrl(String newUrl) async {
    final updatedConfig = state..apiUrl = newUrl;
    await _configHelper.updateConfig(updatedConfig);
    emit(updatedConfig);
  }
}
