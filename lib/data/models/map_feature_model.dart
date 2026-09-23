import '../../domain/entities/map_feature.dart';

class MapFeatureModel {
  final String id;
  final double longitude;
  final double latitude;
  final String name;
  final String address;
  final String city;
  final String district;
  final String village;
  final String period;

  const MapFeatureModel({
    required this.id,
    required this.longitude,
    required this.latitude,
    required this.name,
    required this.address,
    required this.city,
    required this.district,
    required this.village,
    required this.period,
  });

  factory MapFeatureModel.fromJson(Map<String, dynamic> json) {
    final geometry = Map<String, dynamic>.from(json['geometry'] as Map);

    final coordinates = List<dynamic>.from(geometry['coordinates'] as List);

    final properties = Map<String, dynamic>.from(
      json['properties'] as Map? ?? {},
    );

    return MapFeatureModel(
      id: json['id'].toString(),
      longitude: (coordinates[0] as num).toDouble(),
      latitude: (coordinates[1] as num).toDouble(),
      name: properties['NAMA']?.toString() ?? '-',
      address: properties['ALAMAT']?.toString() ?? '-',
      city: properties['KABKOT']?.toString() ?? '-',
      district: properties['KECAMATAN']?.toString() ?? '-',
      village: properties['DESA']?.toString() ?? '-',
      period: properties['WAKTU']?.toString() ?? '-',
    );
  }

  MapFeature toEntity() {
    return MapFeature(
      id: id,
      longitude: longitude,
      latitude: latitude,
      name: name,
      address: address,
      city: city,
      district: district,
      village: village,
      period: period,
    );
  }
}
