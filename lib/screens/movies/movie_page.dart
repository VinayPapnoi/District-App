import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/content_provider.dart';
import '../../models/movie_model.dart';
import '../../widgets/movie_box.dart';
import '../../widgets/district_cached_image.dart';
import 'movie_detail_screen.dart';

class MoviesPage extends ConsumerWidget {
  const MoviesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final searchQuery = ref.watch(searchQueryProvider).trim();
    final filteredMovies = ref.watch(filteredMoviesProvider);
    final moviesAsync = ref.watch(moviesStreamProvider);
    final movies = moviesAsync.value ?? [];

    if (searchQuery.isNotEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: _buildSearchResults(context, searchQuery, filteredMovies),
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
            _buildBannerImage('assets/images/spotlight_banner.png'),
            if (movies.isNotEmpty) _buildMovieCarousel(context, movies),
            const SizedBox(height: 20),
            _buildBannerImage('assets/images/below-spotlight.png'),
            const SizedBox(height: 20),
            if (movies.isNotEmpty) _buildHorizontalMovieList(screenWidth, movies),
            const SizedBox(height: 20),
            _buildBannerImage('assets/images/explore_icon.png'),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _StaticImageBox(imagePath: 'assets/images/box_left.jpeg'),
                  _StaticImageBox(imagePath: 'assets/images/box_right.jpeg'),
                ],
              ),
            ),

            const SizedBox(height: 20),
            _buildBannerImage('assets/images/only_theatre.png'),
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

  Widget _buildBannerImage(String path) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          path,
          fit: BoxFit.contain,
          width: double.infinity,
        ),
      ),
    );
  }

  Widget _buildMovieCarousel(BuildContext context, List<Movie> movies) {
    final PageController controller = PageController(viewportFraction: 0.7);
    final total = movies.length;

    return SizedBox(
      height: 280,
      child: PageView.builder(
        controller: controller,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final movie = movies[index % total];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailScreen(movieData: movie.toMap()),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                            Colors.black.withOpacity(0.6),
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          movie.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
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

  Widget _buildHorizontalMovieList(double screenWidth, List<Movie> allMovies) {
    final movies = allMovies.take(3).toList();

    return SizedBox(
      height: 230,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: movies.length,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemBuilder: (context, index) {
          final movie = movies[index];
          final cardWidth = (screenWidth * 0.38).clamp(130.0, 180.0);
          return Container(
            width: cardWidth,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MovieDetailScreen(movieData: movie.toMap()),
                  ),
                );
              },
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(12)),
                      child: SizedBox(
                        width: double.infinity,
                        child: DistrictCachedImage(
                          imageUrl: movie.bannerUrl,
                          fallbackAsset: 'assets/movieimg/movies/oppenheimer.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
                    child: Text(
                      movie.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
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
    List<Movie> results,
  ) {
    if (results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.movie_filter_outlined,
                size: 64,
                color: Colors.grey.shade700,
              ),
              const SizedBox(height: 16),
              Text(
                'No movies found for "$query"',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Try searching by full title, language, or genre.',
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
          Row(
            children: [
              Text(
                'Results for "$query"',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${results.length}',
                  style: const TextStyle(
                    color: Color(0xFF6366F1),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final boxWidth = (constraints.maxWidth - 12) / 2;
              return Wrap(
                spacing: 12,
                runSpacing: 16,
                children: results.map((movie) {
                  return MovieBox(
                    movieData: movie.toMap(),
                    width: boxWidth,
                    margin: EdgeInsets.zero,
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StaticImageBox extends StatelessWidget {
  final String imagePath;
  const _StaticImageBox({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: (screenWidth - 48) / 2,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade800, width: 1.2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
          width: double.infinity,
        ),
      ),
    );
  }
}
