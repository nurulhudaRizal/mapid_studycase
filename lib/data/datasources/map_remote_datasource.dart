import '../models/map_feature_model.dart';

abstract interface class MapRemoteDataSource {
  Future<List<MapFeatureModel>> getMapLayer();
}
