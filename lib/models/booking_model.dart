import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String id;
  final String userId;
  final String itemTitle;
  final String itemType; // 'movie', 'dining', 'event'
  final String imageUrl;
  final String date;
  final String time;
  final String details; // e.g. "Seats: E4, E5" or "Guests: 2" or "General Pass x 1"
  final int totalPrice;
  final String bookingReference;
  final String status;
  final DateTime createdAt;

  const Booking({
    required this.id,
    required this.userId,
    required this.itemTitle,
    required this.itemType,
    required this.imageUrl,
    required this.date,
    required this.time,
    required this.details,
    required this.totalPrice,
    required this.bookingReference,
    this.status = 'confirmed',
    required this.createdAt,
  });

  factory Booking.fromMap(Map<String, dynamic> map, {String? docId}) {
    return Booking(
      id: docId ?? map['id']?.toString() ?? '',
      userId: map['userId']?.toString() ?? '',
      itemTitle: map['itemTitle']?.toString() ?? '',
      itemType: map['itemType']?.toString() ?? 'movie',
      imageUrl: map['imageUrl']?.toString() ?? '',
      date: map['date']?.toString() ?? '',
      time: map['time']?.toString() ?? '',
      details: map['details']?.toString() ?? '',
      totalPrice: (map['totalPrice'] is num) ? (map['totalPrice'] as num).toInt() : 0,
      bookingReference: map['bookingReference']?.toString() ?? '',
      status: map['status']?.toString() ?? 'confirmed',
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] is Timestamp
              ? (map['createdAt'] as Timestamp).toDate()
              : DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now())
          : DateTime.now(),
    );
  }

  factory Booking.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return Booking.fromMap(data, docId: doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'itemTitle': itemTitle,
      'itemType': itemType,
      'imageUrl': imageUrl,
      'date': date,
      'time': time,
      'details': details,
      'totalPrice': totalPrice,
      'bookingReference': bookingReference,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
