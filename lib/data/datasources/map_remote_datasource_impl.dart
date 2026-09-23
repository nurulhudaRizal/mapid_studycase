import 'package:dio/dio.dart';

import '../../core/config/env_config.dart';
import '../models/map_feature_model.dart';
import 'map_remote_datasource.dart';

class MapRemoteDataSourceImpl implements MapRemoteDataSource {
  final Dio dio;

  MapRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<MapFeatureModel>> getMapLayer() async {
    final response = await dio.get(
      '/layers_new/get_layer',
      queryParameters: {
        'api_key': EnvConfig.mapidApiKey,
        'layer_id': EnvConfig.mapidLayerId,
        'project_id': EnvConfig.mapidProjectId,
      },
    );

    final data = Map<String, dynamic>.from(response.data as Map);

    final features = List<dynamic>.from(data['features'] as List? ?? []);

    return features
        .map(
          (item) =>
              MapFeatureModel.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
  }
}
