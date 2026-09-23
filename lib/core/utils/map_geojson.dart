import '../../../domain/entities/map_feature.dart';

abstract final class MapGeoJson {
  static Map<String, dynamic> fromFeatures(List<MapFeature> features) {
    return {
      'type': 'FeatureCollection',
      'features': features.map((feature) {
        return {
          'type': 'Feature',
          'id': feature.id,
          'geometry': {
            'type': 'Point',
            'coordinates': [feature.longitude, feature.latitude],
          },
          'properties': {
            'name': feature.name,
            'address': feature.address,
            'city': feature.city,
            'district': feature.district,
            'village': feature.village,
            'period': feature.period,
          },
        };
      }).toList(),
    };
  }
}
