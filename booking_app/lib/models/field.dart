class Field {
  final String id;
  final String name;
  final String sportId;
  final String location;
  final String address;
  final double latitude;
  final double longitude;
  final double pricePerHour;
  final List<String> images;
  final String description;
  final List<String> facilities;
  final double rating;
  final int reviewCount;
  final Map<String, List<String>> availableHours;
  final bool isActive;

  Field({
    required this.id,
    required this.name,
    required this.sportId,
    required this.location,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.pricePerHour,
    required this.images,
    required this.description,
    required this.facilities,
    required this.rating,
    required this.reviewCount,
    required this.availableHours,
    this.isActive = true,
  });

  factory Field.fromJson(Map<String, dynamic> json) {
    return Field(
      id: json['id'] as String,
      name: json['name'] as String,
      sportId: json['sportId'] as String,
      location: json['location'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      pricePerHour: (json['pricePerHour'] as num).toDouble(),
      images: List<String>.from(json['images'] as List),
      description: json['description'] as String,
      facilities: List<String>.from(json['facilities'] as List),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      availableHours: Map<String, List<String>>.from(
        (json['availableHours'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(key, List<String>.from(value as List)),
        ),
      ),
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sportId': sportId,
      'location': location,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'pricePerHour': pricePerHour,
      'images': images,
      'description': description,
      'facilities': facilities,
      'rating': rating,
      'reviewCount': reviewCount,
      'availableHours': availableHours,
      'isActive': isActive,
    };
  }
}