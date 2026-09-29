import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/content_provider.dart';
import '../../models/movie_model.dart';
import '../../models/event_model.dart';
import '../../models/dining_model.dart';
import '../../widgets/district_cached_image.dart';
import '../../widgets/movie_box.dart';
import '../movies/movie_detail_screen.dart';
import '../events/event_detail_screen.dart';
import '../dining/dining_detail_screen.dart';

class ForYouPage extends ConsumerWidget {
  const ForYouPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchQueryProvider).trim();
    final filteredMovies = ref.watch(filteredMoviesProvider);
    final filteredEvents = ref.watch(filteredEventsProvider);
    final filteredRestaurants = ref.watch(filteredRestaurantsProvider);

    final moviesAsync = ref.watch(moviesStreamProvider);
    final eventsAsync = ref.watch(eventsStreamProvider);
    final restaurantsAsync = ref.watch(restaurantsStreamProvider);

    final movies = moviesAsync.value ?? [];
    final events = eventsAsync.value ?? [];
    final restaurants = restaurantsAsync.value ?? [];

    if (searchQuery.isNotEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: _buildSearchResults(
            context,
            searchQuery,
            filteredMovies,
            filteredEvents,
            filteredRestaurants,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            _buildBannerImage('assets/images/spotlight_banner.png'),
            const SizedBox(height: 20),

            if (events.isNotEmpty) ...[
              _buildSpotlightCarousel(context, events),
              const SizedBox(height: 30),
            ],

            _buildBannerImage('assets/images/blockbuster.png'),
            const SizedBox(height: 20),

            if (movies.isNotEmpty) ...[
              _buildMovieCarousel(context, movies),
              const SizedBox(height: 30),
            ],

            _buildBannerImage('assets/images/foodie.png'),
            const SizedBox(height: 20),

            if (restaurants.isNotEmpty) ...[
              _buildDiningCarousel(context, restaurants),
              const SizedBox(height: 30),
            ],

            _buildBannerImage('assets/images/blockbuster.png'),
            const SizedBox(height: 20),

            if (movies.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = (constraints.maxWidth / 160).floor().clamp(2, 5);
                    final totalGaps = (crossAxisCount - 1) * 12.0;
                    final boxWidth = (constraints.maxWidth - totalGaps) / crossAxisCount;
                    return Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: List.generate(movies.length, (index) {
                        final movie = movies[index];
                        return SizedBox(
                          width: boxWidth,
                          child: MovieBox(
                            movieData: movie.toMap(),
                            width: boxWidth,
                            margin: EdgeInsets.zero,
                          ),
                        );
                      }),
                    );
                  },
                ),
              ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSpotlightCarousel(BuildContext context, List<EventModel> events) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final carouselHeight = (screenHeight * 0.48).clamp(320.0, 460.0);
    final controller = PageController(viewportFraction: 0.85, initialPage: 1000);
    final total = events.length;

    return SizedBox(
      height: carouselHeight,
      child: PageView.builder(
        controller: controller,
        itemBuilder: (context, index) {
          final event = events[index % total];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EventDetailScreen(eventData: event.toMap()),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    DistrictCachedImage(
                      imageUrl: event.imageUrl,
                      fallbackAsset: 'assets/images/messi_event.jpg',
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.7),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 18,
                      left: 16,
                      right: 16,
                      child: Text(
                        event.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBannerImage(String path) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(path, fit: BoxFit.contain, width: double.infinity),
      ),
    );
  }

  Widget _buildMovieCarousel(BuildContext context, List<Movie> movies) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final carouselHeight = (screenHeight * 0.32).clamp(220.0, 300.0);
    final controller = PageController(viewportFraction: 0.7);
    final total = movies.length;

    return SizedBox(
      height: carouselHeight,
      child: PageView.builder(
        controller: controller,
        itemBuilder: (context, index) {
          final movie = movies[index % total];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MovieDetailScreen(movieData: movie.toMap()),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    DistrictCachedImage(
                      imageUrl: movie.bannerUrl,
                      fallbackAsset: 'assets/movieimg/movies/oppenheimer.jpg',
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withValues(alpha: 0.7),
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          movie.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDiningCarousel(BuildContext context, List<Restaurant> restaurants) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final carouselHeight = (screenHeight * 0.36).clamp(240.0, 340.0);
    final controller = PageController(viewportFraction: 0.75, initialPage: 1000);
    final total = restaurants.length;

    return SizedBox(
      height: carouselHeight,
      child: PageView.builder(
        controller: controller,
        itemBuilder: (context, index) {
          final restaurant = restaurants[index % total];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DiningDetailScreen(restaurantData: restaurant.toMap()),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    DistrictCachedImage(
                      imageUrl: restaurant.imageUrl,
                      fallbackAsset: 'assets/images/masala-synergy.jpeg',
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.85),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 18,
                      left: 16,
                      right: 16,
                      child: Text(
                        restaurant.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchResults(
    BuildContext context,
    String query,
    List<Movie> movies,
    List<EventModel> events,
    List<Restaurant> restaurants,
  ) {
    final bool isEmpty = movies.isEmpty && events.isEmpty && restaurants.isEmpty;

    if (isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off_outlined,
                size: 64,
                color: Colors.grey.shade700,
              ),
              const SizedBox(height: 16),
              Text(
                'No results found for "$query"',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Try searching with a different keyword across movies, events, or dining.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Explore results for "$query"',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Matching Movies
          if (movies.isNotEmpty) ...[
            _buildSectionHeader('MOVIES (${movies.length})'),
            const SizedBox(height: 12),
            SizedBox(
              height: 230,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return Container(
                    width: 140,
                    margin: const EdgeInsets.only(right: 12),
                    child: MovieBox(
                      movieData: movie.toMap(),
                      width: 140,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Matching Events
          if (events.isNotEmpty) ...[
            _buildSectionHeader('EVENTS (${events.length})'),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(14),
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
                            height: 90,
                            child: DistrictCachedImage(
                              imageUrl: event.imageUrl,
                              fallbackAsset: 'assets/images/messi_event.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                event.venue,
                                style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
          ],

          // Matching Restaurants
          if (restaurants.isNotEmpty) ...[
            _buildSectionHeader('DINING & RESTAURANTS (${restaurants.length})'),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(14),
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
                            height: 90,
                            child: DistrictCachedImage(
                              imageUrl: restaurant.imageUrl,
                              fallbackAsset: 'assets/images/masala-synergy.jpeg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                restaurant.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${restaurant.cuisine} • ${restaurant.location}',
                                style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.amberAccent,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }
}
