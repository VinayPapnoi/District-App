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
    if (userId.isEmpty) return Stream.value([]);
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('bookings')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Booking.fromFirestore(doc)).toList())
        .handleError((_) => <Booking>[]);
  }

  Future<void> saveBooking(Booking booking) async {
    if (booking.userId.isEmpty) return;
    await _firestore
        .collection('users')
        .doc(booking.userId)
        .collection('bookings')
        .doc(booking.id)
        .set(booking.toMap());
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
