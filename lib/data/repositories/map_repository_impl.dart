import '../../domain/entities/map_feature.dart';
import '../../domain/repositories/map_repository.dart';
import '../datasources/map_remote_datasource.dart';

class MapRepositoryImpl implements MapRepository {
  final MapRemoteDataSource remoteDataSource;

  MapRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<MapFeature>> getMapLayer() async {
    final models = await remoteDataSource.getMapLayer();

    return models.map((model) => model.toEntity()).toList();
  }
}
