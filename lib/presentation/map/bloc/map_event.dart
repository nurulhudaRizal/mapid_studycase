import 'package:equatable/equatable.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object?> get props => [];
}

class MapLoadRequested extends MapEvent {
  const MapLoadRequested();
}

class MapFeatureTapped extends MapEvent {
  final String featureId;

  const MapFeatureTapped(this.featureId);

  @override
  List<Object?> get props => [featureId];
}

class MapFeatureSelectionCleared extends MapEvent {
  const MapFeatureSelectionCleared();
}

class MapRetryRequested extends MapEvent {
  const MapRetryRequested();
}
