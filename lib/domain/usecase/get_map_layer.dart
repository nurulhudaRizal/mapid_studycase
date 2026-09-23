import '../entities/map_feature.dart';
import '../repositories/map_repository.dart';

class GetMapLayer {
  final MapRepository repository;

  GetMapLayer({required this.repository});

  Future<List<MapFeature>> call() {
    return repository.getMapLayer();
  }
}
