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
    final moviesAsync = ref.watch(moviesStreamProvider);
    final eventsAsync = ref.watch(eventsStreamProvider);
    final restaurantsAsync = ref.watch(restaurantsStreamProvider);

    final movies = moviesAsync.value ?? [];
    final events = eventsAsync.value ?? [];
    final restaurants = restaurantsAsync.value ?? [];

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
                    final boxWidth = (constraints.maxWidth - 12) / 2;
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
    final controller = PageController(viewportFraction: 0.85, initialPage: 1000);
    final total = events.length;

    return SizedBox(
      height: 450,
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
                            Colors.black.withOpacity(0.7),
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
    final controller = PageController(viewportFraction: 0.7);
    final total = movies.length;

    return SizedBox(
      height: 280,
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
                            Colors.black.withOpacity(0.7),
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
    final controller = PageController(viewportFraction: 0.75, initialPage: 1000);
    final total = restaurants.length;

    return SizedBox(
      height: 320,
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
                            Colors.black.withOpacity(0.85),
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
}
