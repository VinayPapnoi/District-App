import 'package:cloud_firestore/cloud_firestore.dart';

class DiningOffer {
  final String title;
  final String? description;
  final String? validFrom;
  final String? details;
  final String? buttonText;

  const DiningOffer({
    required this.title,
    this.description,
    this.validFrom,
    this.details,
    this.buttonText,
  });

  factory DiningOffer.fromMap(Map<String, dynamic> map) {
    return DiningOffer(
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString(),
      validFrom: map['validFrom']?.toString(),
      details: map['details']?.toString(),
      buttonText: map['buttonText']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      if (description != null) 'description': description,
      if (validFrom != null) 'validFrom': validFrom,
      if (details != null) 'details': details,
      if (buttonText != null) 'buttonText': buttonText,
    };
  }
}

class Restaurant {
  final String id;
  final String name;
  final String imageUrl;
  final List<String> galleryUrls;
  final double rating;
  final int totalRatings;
  final String cuisine;
  final String location;
  final String timings;
  final String distance;
  final String priceForTwo;
  final String whatsGoodHere;
  final List<DiningOffer> offers;
  final String menuUpdated;
  final String description;
  final List<String> highlights;

  const Restaurant({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.galleryUrls,
    required this.rating,
    required this.totalRatings,
    required this.cuisine,
    required this.location,
    required this.timings,
    required this.distance,
    required this.priceForTwo,
    required this.whatsGoodHere,
    required this.offers,
    required this.menuUpdated,
    required this.description,
    required this.highlights,
  });

  factory Restaurant.fromMap(Map<String, dynamic> map, {String? docId}) {
    return Restaurant(
      id: docId ?? map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      imageUrl: map['imageUrl']?.toString() ?? map['image']?.toString() ?? '',
      galleryUrls: List<String>.from(map['galleryUrls'] ?? map['gallery'] ?? []),
      rating: (map['rating'] is num) ? (map['rating'] as num).toDouble() : 4.0,
      totalRatings: (map['totalRatings'] is num) ? (map['totalRatings'] as num).toInt() : 100,
      cuisine: map['cuisine']?.toString() ?? '',
      location: map['location']?.toString() ?? '',
      timings: map['timings']?.toString() ?? 'Open • 12:00 PM to 11:00 PM',
      distance: map['distance']?.toString() ?? '2.5 km',
      priceForTwo: map['priceForTwo']?.toString() ?? '₹1,000',
      whatsGoodHere: map['whatsGoodHere']?.toString() ?? '',
      offers: (map['offers'] as List<dynamic>?)
              ?.map((item) => DiningOffer.fromMap(Map<String, dynamic>.from(item)))
              .toList() ??
          [],
      menuUpdated: map['menuUpdated']?.toString() ?? 'Updated recently',
      description: map['description']?.toString() ?? '',
      highlights: List<String>.from(map['highlights'] ?? []),
    );
  }

  factory Restaurant.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return Restaurant.fromMap(data, docId: doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'galleryUrls': galleryUrls,
      'rating': rating,
      'totalRatings': totalRatings,
      'cuisine': cuisine,
      'location': location,
      'timings': timings,
      'distance': distance,
      'priceForTwo': priceForTwo,
      'whatsGoodHere': whatsGoodHere,
      'offers': offers.map((o) => o.toMap()).toList(),
      'menuUpdated': menuUpdated,
      'description': description,
      'highlights': highlights,
    };
  }

  Restaurant copyWith({
    String? id,
    String? name,
    String? imageUrl,
    List<String>? galleryUrls,
    double? rating,
    int? totalRatings,
    String? cuisine,
    String? location,
    String? timings,
    String? distance,
    String? priceForTwo,
    String? whatsGoodHere,
    List<DiningOffer>? offers,
    String? menuUpdated,
    String? description,
    List<String>? highlights,
  }) {
    return Restaurant(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      galleryUrls: galleryUrls ?? this.galleryUrls,
      rating: rating ?? this.rating,
      totalRatings: totalRatings ?? this.totalRatings,
      cuisine: cuisine ?? this.cuisine,
      location: location ?? this.location,
      timings: timings ?? this.timings,
      distance: distance ?? this.distance,
      priceForTwo: priceForTwo ?? this.priceForTwo,
      whatsGoodHere: whatsGoodHere ?? this.whatsGoodHere,
      offers: offers ?? this.offers,
      menuUpdated: menuUpdated ?? this.menuUpdated,
      description: description ?? this.description,
      highlights: highlights ?? this.highlights,
    );
  }
}
