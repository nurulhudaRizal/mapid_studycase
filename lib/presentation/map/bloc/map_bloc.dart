import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/map_feature.dart';
import '../../../domain/usecase/get_map_layer.dart';
import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final GetMapLayer getMapLayer;

  MapBloc({required this.getMapLayer}) : super(const MapInitial()) {
    on<MapLoadRequested>(_onLoad);
    on<MapFeatureTapped>(_onFeatureTapped);
    on<MapFeatureSelectionCleared>(_onFeatureSelectionCleared);
    on<MapRetryRequested>(_onRetry);
  }

  Future<void> _onLoad(MapLoadRequested event, Emitter<MapState> emit) async {
    emit(const MapLoading());

    try {
      final features = await getMapLayer();

      emit(MapLoaded(features: features));
    } catch (e) {
      emit(MapError('Failed to load map data.'));
    }
  }

  void _onFeatureTapped(MapFeatureTapped event, Emitter<MapState> emit) {
    final currentState = state;

    if (currentState is! MapLoaded) {
      return;
    }

    MapFeature? selectedFeature;

    for (final feature in currentState.features) {
      if (feature.id == event.featureId) {
        selectedFeature = feature;
        break;
      }
    }

    if (selectedFeature == null) {
      return;
    }

    emit(currentState.copyWith(selectedFeature: selectedFeature));
  }

  void _onFeatureSelectionCleared(
    MapFeatureSelectionCleared event,
    Emitter<MapState> emit,
  ) {
    final currentState = state;

    if (currentState is! MapLoaded) {
      return;
    }

    emit(currentState.copyWith(clearSelectedFeature: true));
  }

  Future<void> _onRetry(MapRetryRequested event, Emitter<MapState> emit) async {
    await _onLoad(const MapLoadRequested(), emit);
  }
}
