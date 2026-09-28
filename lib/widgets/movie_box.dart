import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/favorites_provider.dart';
import '../screens/movies/movie_detail_screen.dart';
import 'district_cached_image.dart';

class MovieBox extends StatelessWidget {
  final Map<String, dynamic> movieData;
  final double? width;

  const MovieBox({
    Key? key,
    required this.movieData,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String title = movieData['title'] ?? 'Untitled';
    final String banner = movieData['bannerUrl'] ?? movieData['bannerImage'] ?? '';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailScreen(movieData: movieData),
          ),
        );
      },
      child: Container(
        width: width ?? 160,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade800, width: 1.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 3 / 4,
                child: DistrictCachedImage(
                  imageUrl: banner,
                  fallbackAsset: 'assets/movieimg/movies/oppenheimer.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                color: Colors.black87,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Consumer(
                      builder: (context, ref, _) {
                        final String id = movieData['id']?.toString() ?? '';
                        final isFav = ref.watch(favoritesProvider).contains(id);
                        return IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            isFav ? Icons.bookmark : Icons.bookmark_border,
                            color: isFav ? const Color(0xFFF59E0B) : Colors.white70,
                            size: 18,
                          ),
                          onPressed: () {
                            ref.read(favoritesProvider.notifier).toggleFavorite(id);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
