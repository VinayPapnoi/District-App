import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/movie_model.dart';
import '../models/event_model.dart';
import '../models/dining_model.dart';
import '../models/booking_model.dart';
import '../data/seed_data.dart';

class ContentRepository {
  final FirebaseFirestore _firestore;

  ContentRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance {
    _configurePersistence();
  }

  void _configurePersistence() {
    try {
      _firestore.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );
    } catch (e) {
      // Settings already initialized
    }
  }

  // ---------------------------------------------------------------------------
  // Movies
  // ---------------------------------------------------------------------------

  Stream<List<Movie>> streamMovies() {
    return _firestore
        .collection('movies')
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return SeedData.initialMovies;
      }
      return snapshot.docs.map((doc) => Movie.fromFirestore(doc)).toList();
    }).handleError((error) {
      return SeedData.initialMovies;
    });
  }

  Future<List<Movie>> getMovies() async {
    try {
      final snapshot = await _firestore.collection('movies').get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) => Movie.fromFirestore(doc)).toList();
      }
    } catch (_) {
      // Fall back to seed data if offline on first run or Firestore unseeded
    }
    return SeedData.initialMovies;
  }

  // ---------------------------------------------------------------------------
  // Events
  // ---------------------------------------------------------------------------

  Stream<List<EventModel>> streamEvents() {
    return _firestore
        .collection('events')
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return SeedData.initialEvents;
      }
      return snapshot.docs.map((doc) => EventModel.fromFirestore(doc)).toList();
    }).handleError((error) {
      return SeedData.initialEvents;
    });
  }

  Future<List<EventModel>> getEvents() async {
    try {
      final snapshot = await _firestore.collection('events').get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) => EventModel.fromFirestore(doc)).toList();
      }
    } catch (_) {
      // Fall back to seed data
    }
    return SeedData.initialEvents;
  }

  // ---------------------------------------------------------------------------
  // Restaurants (Dining)
  // ---------------------------------------------------------------------------

  Stream<List<Restaurant>> streamRestaurants() {
    return _firestore
        .collection('restaurants')
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return SeedData.initialRestaurants;
      }
      return snapshot.docs.map((doc) => Restaurant.fromFirestore(doc)).toList();
    }).handleError((error) {
      return SeedData.initialRestaurants;
    });
  }

  Future<List<Restaurant>> getRestaurants() async {
    try {
      final snapshot = await _firestore.collection('restaurants').get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) => Restaurant.fromFirestore(doc)).toList();
      }
    } catch (_) {
      // Fall back to seed data
    }
    return SeedData.initialRestaurants;
  }

  // ---------------------------------------------------------------------------
  // Bookings (User-specific)
  // ---------------------------------------------------------------------------

  Stream<List<Booking>> streamUserBookings(String userId) {
    final effectiveUid = userId.trim().isEmpty ? 'guest_user' : userId.trim();
    return _firestore
        .collection('users')
        .doc(effectiveUid)
        .collection('bookings')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Booking.fromFirestore(doc)).toList())
        .handleError((_) => <Booking>[]);
  }

  Future<void> saveBooking(Booking booking) async {
    final effectiveUid =
        booking.userId.trim().isEmpty ? 'guest_user' : booking.userId.trim();
    await _firestore
        .collection('users')
        .doc(effectiveUid)
        .collection('bookings')
        .doc(booking.id)
        .set(booking.toMap());
  }

  // ---------------------------------------------------------------------------
  // Movie Booked Seats (Real-time synchronization per movie and showtime)
  // ---------------------------------------------------------------------------

  Stream<Map<String, List<String>>> streamMovieBookedSeats(String movieId) {
    return _firestore
        .collection('movies')
        .doc(movieId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) return <String, List<String>>{};
      final data = snapshot.data();
      if (data == null || data['bookedSeats'] == null) {
        return <String, List<String>>{};
      }
      final rawMap = data['bookedSeats'] as Map<dynamic, dynamic>;
      final result = <String, List<String>>{};
      rawMap.forEach((key, val) {
        if (val is List) {
          result[key.toString()] = val.map((e) => e.toString()).toList();
        }
      });
      return result;
    }).handleError((_) => <String, List<String>>{});
  }

  Future<void> bookMovieSeats({
    required String movieId,
    required String showtime,
    required List<String> seats,
  }) async {
    final docRef = _firestore.collection('movies').doc(movieId);
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        transaction.set(
          docRef,
          {
            'bookedSeats': {
              showtime: seats,
            }
          },
          SetOptions(merge: true),
        );
        return;
      }

      final data = snapshot.data();
      final bookedSeatsMap = Map<String, dynamic>.from(
          data?['bookedSeats'] as Map? ?? {});
      final currentShowtimeSeats = List<String>.from(
          bookedSeatsMap[showtime] as List? ?? []);

      // Check for seat booking conflicts
      final alreadyTaken = seats.where((s) => currentShowtimeSeats.contains(s)).toList();
      if (alreadyTaken.isNotEmpty) {
        throw Exception('Seat(s) ${alreadyTaken.join(', ')} have already been booked by another user!');
      }

      // Add new seats
      final updatedSeats = {...currentShowtimeSeats, ...seats}.toList();
      bookedSeatsMap[showtime] = updatedSeats;

      transaction.update(docRef, {'bookedSeats': bookedSeatsMap});
    });
  }

  // ---------------------------------------------------------------------------
  // Controlled Admin Seeding Helper (Invoked explicitly, never runs silently)
  // ---------------------------------------------------------------------------

  Future<Map<String, int>> seedFirestoreDatabase({bool overwrite = false}) async {
    final batch = _firestore.batch();
    int moviesCount = 0;
    int eventsCount = 0;
    int diningCount = 0;

    for (final movie in SeedData.initialMovies) {
      final docRef = _firestore.collection('movies').doc(movie.id);
      batch.set(docRef, movie.toMap(), SetOptions(merge: !overwrite));
      moviesCount++;
    }

    for (final event in SeedData.initialEvents) {
      final docRef = _firestore.collection('events').doc(event.id);
      batch.set(docRef, event.toMap(), SetOptions(merge: !overwrite));
      eventsCount++;
    }

    for (final restaurant in SeedData.initialRestaurants) {
      final docRef = _firestore.collection('restaurants').doc(restaurant.id);
      batch.set(docRef, restaurant.toMap(), SetOptions(merge: !overwrite));
      diningCount++;
    }

    await batch.commit();
    return {
      'movies': moviesCount,
      'events': eventsCount,
      'restaurants': diningCount,
    };
  }
}
