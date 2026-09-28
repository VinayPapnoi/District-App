import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/movie_model.dart';
import '../models/event_model.dart';
import '../models/dining_model.dart';
import '../models/booking_model.dart';
import '../repositories/content_repository.dart';
import 'auth_provider.dart';

// Repository Provider
final contentRepositoryProvider = Provider<ContentRepository>((ref) {
  return ContentRepository();
});

// Stream Providers for Real-time Firestore synchronization
final moviesStreamProvider = StreamProvider<List<Movie>>((ref) {
  final repository = ref.watch(contentRepositoryProvider);
  return repository.streamMovies();
});

final eventsStreamProvider = StreamProvider<List<EventModel>>((ref) {
  final repository = ref.watch(contentRepositoryProvider);
  return repository.streamEvents();
});

final restaurantsStreamProvider = StreamProvider<List<Restaurant>>((ref) {
  final repository = ref.watch(contentRepositoryProvider);
  return repository.streamRestaurants();
});

// User Bookings Stream Provider
final userBookingsProvider = StreamProvider<List<Booking>>((ref) {
  final repository = ref.watch(contentRepositoryProvider);
  final userId = ref.watch(authProvider.select((s) => s.userId)) ?? '';
  return repository.streamUserBookings(userId);
});
