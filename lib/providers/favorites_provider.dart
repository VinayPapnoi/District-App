import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie_model.dart';
import '../models/event_model.dart';
import '../models/dining_model.dart';
import 'content_provider.dart';

class FavoritesNotifier extends StateNotifier<Set<String>> {
  static const String _prefsKey = 'user_favorite_ids';

  FavoritesNotifier() : super({}) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_prefsKey) ?? [];
      state = list.toSet();
    } catch (_) {
      // In case of error loading from local storage, keep default empty set
    }
  }

  Future<void> toggleFavorite(String id) async {
    final updated = Set<String>.from(state);
    if (updated.contains(id)) {
      updated.remove(id);
    } else {
      updated.add(id);
    }
    state = updated;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_prefsKey, updated.toList());
    } catch (_) {}
  }

  bool isFavorite(String id) => state.contains(id);
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  return FavoritesNotifier();
});

// Computed providers for quick retrieval of full objects in Saved Plans
final favoriteMoviesProvider = Provider<List<Movie>>((ref) {
  final favIds = ref.watch(favoritesProvider);
  final movies = ref.watch(moviesStreamProvider).value ?? [];
  return movies.where((m) => favIds.contains(m.id)).toList();
});

final favoriteEventsProvider = Provider<List<EventModel>>((ref) {
  final favIds = ref.watch(favoritesProvider);
  final events = ref.watch(eventsStreamProvider).value ?? [];
  return events.where((e) => favIds.contains(e.id)).toList();
});

final favoriteRestaurantsProvider = Provider<List<Restaurant>>((ref) {
  final favIds = ref.watch(favoritesProvider);
  final restaurants = ref.watch(restaurantsStreamProvider).value ?? [];
  return restaurants.where((r) => favIds.contains(r.id)).toList();
});

final totalFavoritesCountProvider = Provider<int>((ref) {
  return ref.watch(favoritesProvider).length;
});
