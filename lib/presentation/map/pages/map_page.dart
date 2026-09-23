import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/map_geojson.dart';
import '../../../domain/entities/map_feature.dart';
import '../bloc/map_bloc.dart';
import '../bloc/map_event.dart';
import '../bloc/map_state.dart';
import '../widgets/map_bottom_sheet.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapLibreMapController? _mapController;

  bool _styleLoaded = false;
  bool _layerRendered = false;

  String? _selectedFeatureId;

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

            final selectedFeature = state.selectedFeature;

            _updateSelectedFeature(selectedFeature?.id);

            if (selectedFeature != null) {
              _showFeatureBottomSheet(selectedFeature);
            }
          }
        },
        child: Stack(
          children: [
            MapLibreMap(
              styleString: AppConstants.openFreeMapStyleUrl,

              initialCameraPosition: const CameraPosition(
                target: LatLng(-7.797068, 110.370529),
                zoom: 12,
              ),

              myLocationEnabled: true,

              onMapCreated: _onMapCreated,

              onStyleLoadedCallback: _onStyleLoaded,
            ),

            _buildLoadingOverlay(),

            _buildErrorOverlay(),

            _buildEmptyOverlay(),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // MAP CREATED
  // ---------------------------------------------------------------------------

  void _onMapCreated(MapLibreMapController controller) {
    _mapController = controller;

    controller.onFeatureTapped.add(_onFeatureTapped);
  }

  // ---------------------------------------------------------------------------
  // STYLE LOADED
  // ---------------------------------------------------------------------------

  void _onStyleLoaded() {
    _styleLoaded = true;

    final state = context.read<MapBloc>().state;

    if (state is MapLoaded) {
      _renderMapFeatures(state);
    }
  }

  // ---------------------------------------------------------------------------
  // RENDER GEOJSON
  // ---------------------------------------------------------------------------

  Future<void> _renderMapFeatures(MapLoaded state) async {
    final controller = _mapController;

    if (controller == null) {
      return;
    }

    if (!_styleLoaded) {
      return;
    }

    if (_layerRendered) {
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
        circleColor: [
          'case',

          // Check whether this feature is selected.
          [
            'boolean',
            ['feature-state', 'selected'],
            false,
          ],

          // Selected color.
          '#FF5722',

          // Default color.
          '#1976D2',
        ],

        circleStrokeWidth: 2,
        circleStrokeColor: '#FFFFFF',
        circleStrokeOpacity: 1,
      ),
    );

    _layerRendered = true;
  }

  // ---------------------------------------------------------------------------
  // FEATURE TAP
  // ---------------------------------------------------------------------------

  void _onFeatureTapped(
    Point<double> point,
    LatLng coordinates,
    String id,
    String layerId,
    Annotation? annotation,
  ) {
    if (layerId != _layerId) {
      return;
    }

    context.read<MapBloc>().add(MapFeatureTapped(id));
  }

  // ---------------------------------------------------------------------------
  // UPDATE SELECTED FEATURE
  // ---------------------------------------------------------------------------

  Future<void> _updateSelectedFeature(String? featureId) async {
    final controller = _mapController;

    if (controller == null) {
      return;
    }

    if (!_layerRendered) {
      return;
    }

    // Remove selected state from previous feature.
    final previousFeatureId = _selectedFeatureId;

    if (previousFeatureId != null && previousFeatureId != featureId) {
      await controller.setFeatureState(_sourceId, previousFeatureId, {
        'selected': false,
      });
    }

    // Select new feature.
    if (featureId != null) {
      await controller.setFeatureState(_sourceId, featureId, {
        'selected': true,
      });
    }

    _selectedFeatureId = featureId;
  }

  // ---------------------------------------------------------------------------
  // LOADING
  // ---------------------------------------------------------------------------

  Widget _buildLoadingOverlay() {
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        if (state is! MapLoading) {
          return const SizedBox.shrink();
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  // ---------------------------------------------------------------------------
  // ERROR
  // ---------------------------------------------------------------------------

  Widget _buildErrorOverlay() {
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        if (state is! MapError) {
          return const SizedBox.shrink();
        }

        return Center(
          child: Card(
            margin: const EdgeInsets.all(24),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48),
                  const SizedBox(height: 12),
                  const Text(
                    'Failed to load map data',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () async {
                      await _resetMapLayer();

                      if (!context.mounted) {
                        return;
                      }

                      context.read<MapBloc>().add(const MapRetryRequested());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // EMPTY DATA
  // ---------------------------------------------------------------------------

  Widget _buildEmptyOverlay() {
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        if (state is! MapLoaded || state.features.isNotEmpty) {
          return const SizedBox.shrink();
        }

        return const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text('No tourism data available.'),
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // FEATURE BOTTOM SHEET
  // ---------------------------------------------------------------------------

  void _showFeatureBottomSheet(MapFeature feature) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return MapBottomSheet(feature: feature);
      },
    ).whenComplete(() {
      if (!mounted) {
        return;
      }

      context.read<MapBloc>().add(const MapFeatureSelectionCleared());
    });
  }

  // ---------------------------------------------------------------------------
  // RESET MAP LAYER
  // ---------------------------------------------------------------------------

  Future<void> _resetMapLayer() async {
    final controller = _mapController;

    if (controller == null) {
      return;
    }

    try {
      await controller.removeLayer(_layerId);
    } catch (_) {}

    try {
      await controller.removeSource(_sourceId);
    } catch (_) {}

    _layerRendered = false;
    _selectedFeatureId = null;
  }

  // ---------------------------------------------------------------------------
  // DISPOSE
  // ---------------------------------------------------------------------------

  @override
  void dispose() {
    _mapController = null;
    super.dispose();
  }
}
