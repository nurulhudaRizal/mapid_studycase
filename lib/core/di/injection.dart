import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:mapid_studycase/core/permissions/location_permission_service.dart';
import 'package:mapid_studycase/data/datasources/map_remote_datasource.dart';
import 'package:mapid_studycase/data/datasources/map_remote_datasource_impl.dart';
import 'package:mapid_studycase/data/repositories/map_repository_impl.dart';
import 'package:mapid_studycase/domain/repositories/map_repository.dart';
import 'package:mapid_studycase/domain/usecase/get_map_layer.dart';
import 'package:mapid_studycase/presentation/map/bloc/map_bloc.dart';

import '../network/dio_client.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  // Register Dio client
  sl.registerLazySingleton<Dio>(DioClient.create);

  // Register services
  sl.registerLazySingleton<LocationPermissionService>(
    LocationPermissionService.new,
  );

  // Register data sources
  sl.registerLazySingleton<MapRemoteDataSource>(
    () => MapRemoteDataSourceImpl(dio: sl()),
  );

  // Register repositories
  sl.registerLazySingleton<MapRepository>(
    () => MapRepositoryImpl(remoteDataSource: sl()),
  );

  // Register use cases
  sl.registerLazySingleton<GetMapLayer>(() => GetMapLayer(repository: sl()));

  // Register BLoC
  sl.registerFactory<MapBloc>(() => MapBloc(getMapLayer: sl()));
}
