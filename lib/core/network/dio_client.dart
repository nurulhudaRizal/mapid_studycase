import 'package:dio/dio.dart';

import '../constants/app_constants.dart';

abstract final class DioClient {
  static Dio create() {
    return Dio(
      BaseOptions(
        baseUrl: AppConstants.mapidBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
      ),
    );
  }
}
