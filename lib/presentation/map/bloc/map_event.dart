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
  final Map<String, dynamic> properties;

  const MapFeatureTapped(this.properties);

  @override
  List<Object?> get props => [properties];
}

class MapRetryRequested extends MapEvent {
  const MapRetryRequested();
}
