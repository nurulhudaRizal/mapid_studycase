import 'package:equatable/equatable.dart';

import '../../../domain/entities/map_feature.dart';
import '../../../domain/entities/user_location.dart';

abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object?> get props => [];
}

class MapInitial extends MapState {
  const MapInitial();
}

class MapLoading extends MapState {
  const MapLoading();
}

class MapLoaded extends MapState {
  final List<MapFeature> features;
  final UserLocation? userLocation;

  const MapLoaded({required this.features, this.userLocation});

  @override
  List<Object?> get props => [features, userLocation];
}

class MapFeatureSelected extends MapLoaded {
  final Map<String, dynamic> properties;

  const MapFeatureSelected({
    required super.features,
    super.userLocation,
    required this.properties,
  });

  @override
  List<Object?> get props => [...super.props, properties];
}

class MapError extends MapState {
  final String message;

  const MapError(this.message);

  @override
  List<Object?> get props => [message];
}
