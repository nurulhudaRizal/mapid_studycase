import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/map_geojson.dart';
import '../bloc/map_bloc.dart';
import '../bloc/map_state.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapLibreMapController? _mapController;

  bool _isMapReady = false;
  bool _isLayerRendered = false;

  static const String _sourceId = 'mapid-tourism-source';
  static const String _layerId = 'mapid-tourism-layer';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MAPID Map')),
      body: BlocListener<MapBloc, MapState>(
        listener: (context, state) {
          if (state is MapLoaded) {
            _renderMapFeatures(state);
          }
        },
        child: MapLibreMap(
          styleString: AppConstants.openFreeMapStyleUrl,
          initialCameraPosition: const CameraPosition(
            target: LatLng(-7.797068, 110.370529),
            zoom: 12,
          ),
          onMapCreated: _onMapCreated,
        ),
      ),
    );
  }

  void _onMapCreated(MapLibreMapController controller) {
    _mapController = controller;
    _isMapReady = true;

    final state = context.read<MapBloc>().state;

    if (state is MapLoaded) {
      _renderMapFeatures(state);
    }
  }

  Future<void> _renderMapFeatures(MapLoaded state) async {
    final controller = _mapController;

    if (controller == null) {
      return;
    }

    if (!_isMapReady) {
      return;
    }

    if (_isLayerRendered) {
      return;
    }

    if (state.features.isEmpty) {
      return;
    }

    final geoJson = MapGeoJson.fromFeatures(state.features);

    await controller.addGeoJsonSource(_sourceId, geoJson);

    await controller.addCircleLayer(
      _sourceId,
      _layerId,
      const CircleLayerProperties(
        circleRadius: 7,
        circleOpacity: 0.9,
        circleStrokeWidth: 2,
        circleStrokeOpacity: 1,
      ),
    );

    _isLayerRendered = true;
  }
}
