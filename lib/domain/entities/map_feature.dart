class MapFeature {
  final String id;
  final double longitude;
  final double latitude;
  final String name;
  final String address;
  final String city;
  final String district;
  final String village;
  final String period;

  const MapFeature({
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
}
