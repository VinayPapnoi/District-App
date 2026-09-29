import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/favorites_provider.dart';
import '../../widgets/district_cached_image.dart';
import '../movies/movie_detail_screen.dart';
import '../events/event_detail_screen.dart';
import '../dining/dining_detail_screen.dart';

class SavedPlansScreen extends ConsumerStatefulWidget {
  const SavedPlansScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SavedPlansScreen> createState() => _SavedPlansScreenState();
}

class _SavedPlansScreenState extends ConsumerState<SavedPlansScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favMovies = ref.watch(favoriteMoviesProvider);
    final favEvents = ref.watch(favoriteEventsProvider);
    final favRestaurants = ref.watch(favoriteRestaurantsProvider);
    final totalCount = ref.watch(totalFavoritesCountProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Flexible(
              child: Text(
                'My Saved Plans',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$totalCount',
                style: const TextStyle(
                  color: Color(0xFFF59E0B),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF6366F1),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          tabs: [
            Tab(text: 'Movies (${favMovies.length})'),
            Tab(text: 'Events (${favEvents.length})'),
            Tab(text: 'Dining (${favRestaurants.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Movies Tab
          _buildMoviesList(context, favMovies),

          // Events Tab
          _buildEventsList(context, favEvents),

          // Dining Tab
          _buildDiningList(context, favRestaurants),
        ],
      ),
    );
  }

  Widget _buildMoviesList(BuildContext context, List<dynamic> movies) {
    if (movies.isEmpty) {
      return _buildEmptyState(
        icon: Icons.movie_outlined,
        title: 'No movies saved',
        subtitle: 'Tap the bookmark icon on any movie to save it to your watchlist.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF16161E),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF262636), width: 0.8),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MovieDetailScreen(movieData: movie.toMap()),
                ),
              );
            },
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(14)),
                  child: SizedBox(
                    width: 90,
                    height: 100,
                    child: DistrictCachedImage(
                      imageUrl: movie.bannerUrl,
                      fallbackAsset: 'assets/movieimg/movies/banner1.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${movie.language} • ${movie.certificate} • ⭐ ${movie.rating}',
                        style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        movie.genres.join(', '),
                        style: const TextStyle(
                          color: Color(0xFF6366F1),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.bookmark, color: Color(0xFFF59E0B)),
                  onPressed: () {
                    ref.read(favoritesProvider.notifier).toggleFavorite(movie.id);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEventsList(BuildContext context, List<dynamic> events) {
    if (events.isEmpty) {
      return _buildEmptyState(
        icon: Icons.festival_outlined,
        title: 'No events saved',
        subtitle: 'Tap the bookmark icon on any concert or event to save it here.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF16161E),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF262636), width: 0.8),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EventDetailScreen(eventData: event.toMap()),
                ),
              );
            },
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(14)),
                  child: SizedBox(
                    width: 90,
                    height: 100,
                    child: DistrictCachedImage(
                      imageUrl: event.imageUrl,
                      fallbackAsset: 'assets/images/messi_event.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        event.venue,
                        style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                        maxLines: 1,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        event.dateTime,
                        style: const TextStyle(
                          color: Colors.amberAccent,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.bookmark, color: Color(0xFFF59E0B)),
                  onPressed: () {
                    ref.read(favoritesProvider.notifier).toggleFavorite(event.id);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDiningList(BuildContext context, List<dynamic> restaurants) {
    if (restaurants.isEmpty) {
      return _buildEmptyState(
        icon: Icons.restaurant_outlined,
        title: 'No restaurants saved',
        subtitle: 'Save restaurants and cafes to quickly access reservations.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        final restaurant = restaurants[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF16161E),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF262636), width: 0.8),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DiningDetailScreen(restaurantData: restaurant.toMap()),
                ),
              );
            },
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(14)),
                  child: SizedBox(
                    width: 90,
                    height: 100,
                    child: DistrictCachedImage(
                      imageUrl: restaurant.imageUrl,
                      fallbackAsset: 'assets/images/masala-synergy.jpeg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${restaurant.cuisine} • ⭐ ${restaurant.rating}',
                        style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        restaurant.location,
                        style: const TextStyle(
                          color: Color(0xFF10B981),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.bookmark, color: Color(0xFFF59E0B)),
                  onPressed: () {
                    ref.read(favoritesProvider.notifier).toggleFavorite(restaurant.id);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: Colors.grey.shade700),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
