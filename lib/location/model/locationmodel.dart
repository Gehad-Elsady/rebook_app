class LocationModel {
  double latitude;
  double longitude;

  // Named parameters with required modifier
  LocationModel({required this.latitude, required this.longitude});

  Map<String, dynamic> toMap() =>
      {'latitude': latitude, 'longitude': longitude};

  // Factory constructor to create a LocationModel from a map
  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      latitude: map['latitude']?.toDouble(), // Default to 0.0 if null
      longitude: map['longitude']?.toDouble(), // Default to 0.0 if null
    );
  }
}
