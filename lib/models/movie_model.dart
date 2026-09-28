import 'package:cloud_firestore/cloud_firestore.dart';

class CastMember {
  final String name;
  final String image;

  const CastMember({
    required this.name,
    required this.image,
  });

  factory CastMember.fromMap(Map<String, dynamic> map) {
    return CastMember(
      name: map['name']?.toString() ?? '',
      image: map['image']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
    };
  }
}

class Movie {
  final String id;
  final String title;
  final String bannerUrl;
  final String certificate;
  final String language;
  final String duration;
  final String releaseDate;
  final List<String> genres;
  final String synopsis;
  final List<CastMember> cast;
  final List<Map<String, String>> availableDates;
  final List<String> offers;
  final double rating;
  final int basePrice;

  const Movie({
    required this.id,
    required this.title,
    required this.bannerUrl,
    required this.certificate,
    required this.language,
    required this.duration,
    required this.releaseDate,
    required this.genres,
    required this.synopsis,
    required this.cast,
    required this.availableDates,
    required this.offers,
    this.rating = 8.5,
    this.basePrice = 250,
  });

  factory Movie.fromMap(Map<String, dynamic> map, {String? docId}) {
    return Movie(
      id: docId ?? map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      bannerUrl: map['bannerUrl']?.toString() ?? map['bannerImage']?.toString() ?? '',
      certificate: map['certificate']?.toString() ?? 'UA',
      language: map['language']?.toString() ?? 'Hindi',
      duration: map['duration']?.toString() ?? '',
      releaseDate: map['releaseDate']?.toString() ?? '',
      genres: List<String>.from(map['genres'] ?? []),
      synopsis: map['synopsis']?.toString() ?? '',
      cast: (map['cast'] as List<dynamic>?)
              ?.map((item) => CastMember.fromMap(Map<String, dynamic>.from(item)))
              .toList() ??
          [],
      availableDates: (map['availableDates'] as List<dynamic>?)
              ?.map((item) => Map<String, String>.from(
                  (item as Map).map((k, v) => MapEntry(k.toString(), v.toString()))))
              .toList() ??
          [],
      offers: List<String>.from(map['offers'] ?? []),
      rating: (map['rating'] is num) ? (map['rating'] as num).toDouble() : 8.5,
      basePrice: (map['basePrice'] is num) ? (map['basePrice'] as num).toInt() : 250,
    );
  }

  factory Movie.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return Movie.fromMap(data, docId: doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'bannerUrl': bannerUrl,
      'bannerImage': bannerUrl,
      'certificate': certificate,
      'language': language,
      'duration': duration,
      'releaseDate': releaseDate,
      'genres': genres,
      'synopsis': synopsis,
      'cast': cast.map((c) => c.toMap()).toList(),
      'availableDates': availableDates,
      'offers': offers,
      'rating': rating,
      'basePrice': basePrice,
    };
  }

  Movie copyWith({
    String? id,
    String? title,
    String? bannerUrl,
    String? certificate,
    String? language,
    String? duration,
    String? releaseDate,
    List<String>? genres,
    String? synopsis,
    List<CastMember>? cast,
    List<Map<String, String>>? availableDates,
    List<String>? offers,
    double? rating,
    int? basePrice,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      certificate: certificate ?? this.certificate,
      language: language ?? this.language,
      duration: duration ?? this.duration,
      releaseDate: releaseDate ?? this.releaseDate,
      genres: genres ?? this.genres,
      synopsis: synopsis ?? this.synopsis,
      cast: cast ?? this.cast,
      availableDates: availableDates ?? this.availableDates,
      offers: offers ?? this.offers,
      rating: rating ?? this.rating,
      basePrice: basePrice ?? this.basePrice,
    );
  }
}
