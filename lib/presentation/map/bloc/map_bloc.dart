import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecase/get_map_layer.dart';
import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final GetMapLayer getMapLayer;

  MapBloc({required this.getMapLayer}) : super(const MapInitial()) {
    on<MapLoadRequested>(_onLoad);
  }

  Future<void> _onLoad(MapLoadRequested event, Emitter<MapState> emit) async {
    emit(const MapLoading());

    try {
      final features = await getMapLayer();

      emit(MapLoaded(features: features));
    } catch (e) {
      emit(MapError(e.toString()));
    }
  }
}
