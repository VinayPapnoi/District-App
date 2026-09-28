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

// Search Query State Provider
final searchQueryProvider = StateProvider<String>((ref) => '');

// Filtered Content Providers
final filteredMoviesProvider = Provider<List<Movie>>((ref) {
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  final movies = ref.watch(moviesStreamProvider).value ?? [];
  if (query.isEmpty) return movies;
  return movies.where((m) =>
    m.title.toLowerCase().contains(query) ||
    m.genres.any((g) => g.toLowerCase().contains(query)) ||
    m.language.toLowerCase().contains(query),
  ).toList();
});

final filteredEventsProvider = Provider<List<EventModel>>((ref) {
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  final events = ref.watch(eventsStreamProvider).value ?? [];
  if (query.isEmpty) return events;
  return events.where((e) =>
    e.title.toLowerCase().contains(query) ||
    e.venue.toLowerCase().contains(query) ||
    e.categories.any((c) => c.toLowerCase().contains(query)),
  ).toList();
});

final filteredRestaurantsProvider = Provider<List<Restaurant>>((ref) {
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  final restaurants = ref.watch(restaurantsStreamProvider).value ?? [];
  if (query.isEmpty) return restaurants;
  return restaurants.where((r) =>
    r.name.toLowerCase().contains(query) ||
    r.cuisine.toLowerCase().contains(query) ||
    r.location.toLowerCase().contains(query),
  ).toList();
});
