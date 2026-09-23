import '../entities/map_feature.dart';

abstract interface class MapRepository {
  Future<List<MapFeature>> getMapLayer();
}
