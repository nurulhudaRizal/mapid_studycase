import 'package:equatable/equatable.dart';

import '../../../domain/entities/map_feature.dart';

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
  final MapFeature? selectedFeature;

  const MapLoaded({required this.features, this.selectedFeature});

  MapLoaded copyWith({
    List<MapFeature>? features,
    MapFeature? selectedFeature,
    bool clearSelectedFeature = false,
  }) {
    return MapLoaded(
      features: features ?? this.features,
      selectedFeature: clearSelectedFeature
          ? null
          : selectedFeature ?? this.selectedFeature,
    );
  }

  @override
  List<Object?> get props => [features, selectedFeature];
}

class MapError extends MapState {
  final String message;

  const MapError(this.message);

  @override
  List<Object?> get props => [message];
}
