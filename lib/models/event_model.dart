import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String id;
  final String title;
  final String imageUrl;
  final String dateTime;
  final String venue;
  final String language;
  final List<String> categories;
  final String description;
  final String terms;
  final List<Map<String, String>> availableDates;
  final String? offer;
  final int basePrice;

  const EventModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.dateTime,
    required this.venue,
    required this.language,
    required this.categories,
    required this.description,
    required this.terms,
    required this.availableDates,
    this.offer,
    this.basePrice = 499,
  });

  factory EventModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return EventModel(
      id: docId ?? map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      imageUrl: map['imageUrl']?.toString() ?? map['image']?.toString() ?? '',
      dateTime: map['dateTime']?.toString() ?? '',
      venue: map['venue']?.toString() ?? '',
      language: map['language']?.toString() ?? 'English',
      categories: List<String>.from(map['categories'] ?? []),
      description: map['description']?.toString() ?? '',
      terms: map['terms']?.toString() ?? '',
      availableDates: (map['availableDates'] as List<dynamic>?)
              ?.map((item) => Map<String, String>.from(
                  (item as Map).map((k, v) => MapEntry(k.toString(), v.toString()))))
              .toList() ??
          [],
      offer: map['offer']?.toString(),
      basePrice: (map['basePrice'] is num) ? (map['basePrice'] as num).toInt() : 499,
    );
  }

  factory EventModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return EventModel.fromMap(data, docId: doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'dateTime': dateTime,
      'venue': venue,
      'language': language,
      'categories': categories,
      'description': description,
      'terms': terms,
      'availableDates': availableDates,
      'offer': offer,
      'basePrice': basePrice,
    };
  }

  EventModel copyWith({
    String? id,
    String? title,
    String? imageUrl,
    String? dateTime,
    String? venue,
    String? language,
    List<String>? categories,
    String? description,
    String? terms,
    List<Map<String, String>>? availableDates,
    String? offer,
    int? basePrice,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      dateTime: dateTime ?? this.dateTime,
      venue: venue ?? this.venue,
      language: language ?? this.language,
      categories: categories ?? this.categories,
      description: description ?? this.description,
      terms: terms ?? this.terms,
      availableDates: availableDates ?? this.availableDates,
      offer: offer ?? this.offer,
      basePrice: basePrice ?? this.basePrice,
    );
  }
}
