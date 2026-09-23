import '../entities/user_location.dart';
import '../repositories/location_repository.dart';

class GetUserLocation {
  final LocationRepository repository;

  GetUserLocation({required this.repository});

  Future<UserLocation> call() {
    return repository.getCurrentLocation();
  }
}
