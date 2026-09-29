import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/favorites_provider.dart';
import '../../models/movie_model.dart';
import '../../widgets/seat_selection_bottom_sheet.dart';

class MovieDetailScreen extends StatefulWidget {
  final Map<String, dynamic> movieData;

  const MovieDetailScreen({
    Key? key,
    required this.movieData,
  }) : super(key: key);

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  bool isBlockbusterOfferEnabled = true;
  int selectedDateIndex = 0;
  late List<Map<String, String>> availableDates;

  @override
  void initState() {
    super.initState();
    // Use dates from movieData if available, otherwise generate them
    if (widget.movieData['availableDates'] != null) {
      availableDates = List<Map<String, String>>.from(
        widget.movieData['availableDates'].map((date) => {
          'date': date['date'].toString(),
          'day': date['day'].toString(),
        }),
      );
    } else {
      availableDates = _generateNextDates(4);
    }
  }

  List<Map<String, String>> _generateNextDates(int count) {
    final now = DateTime.now();
    return List.generate(count, (index) {
      final date = now.add(Duration(days: index));
      return {
        'date': date.day.toString(),
        'day': ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][date.weekday % 7],
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.movieData;
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          // App Bar with Banner Image
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {},
              ),
              Consumer(
                builder: (context, ref, _) {
                  final movieId = data['id']?.toString() ?? '';
                  final isFav = ref.watch(favoritesProvider).contains(movieId);
                  return IconButton(
                    icon: Icon(
                      isFav ? Icons.bookmark : Icons.bookmark_border,
                      color: isFav ? const Color(0xFFF59E0B) : Colors.white,
                    ),
                    onPressed: () {
                      ref.read(favoritesProvider.notifier).toggleFavorite(movieId);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: const Color(0xFF1E1E28),
                          duration: const Duration(seconds: 2),
                          content: Text(
                            isFav
                                ? 'Removed "${data['title']}" from Watchlist'
                                : 'Added "${data['title']}" to Watchlist ⭐',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.black87,
                      content: Text('Share functionality coming soon'),
                    ),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Handle both asset and network images
                  (data['bannerImage'] ?? '').startsWith('assets/')
                      ? Image.asset(
                          data['bannerImage'] ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(color: Colors.grey[900]),
                        )
                      : Image.network(
                          data['bannerImage'] ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(color: Colors.grey[900]),
                        ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                          Colors.black,
                        ],
                        stops: const [0.0, 0.7, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Genre Tags
                  if (data['genres'] != null) _buildGenreTags(data['genres']),
                  
                  const SizedBox(height: 16),

                  // Movie Title
                  Text(
                    data['title'] ?? 'Untitled Movie',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Movie Info (Certificate, Language, Duration)
                  Text(
                    '${data['certificate'] ?? 'N/A'} • ${data['language'] ?? 'N/A'} • ${data['duration'] ?? 'N/A'}',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Synopsis
                  Text(
                    data['synopsis'] ?? 'No synopsis available.',
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Cast
                  if (data['cast'] != null) _buildCastSection(data['cast']),

                  const SizedBox(height: 16),

                  // View Movie Details Button
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // Could expand to show more details
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.black87,
                            content: Text('Full details view coming soon'),
                          ),
                        );
                      },
                      child: const Text(
                        'View movie details',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Offers Section
                  if (data['offers'] != null && (data['offers'] as List).isNotEmpty)
                    _buildOffersSection(data['offers']),

                  const SizedBox(height: 20),

                  // Blockbuster Tuesdays Banner
                  _buildBlockbusterBanner(),

                  const SizedBox(height: 20),

                  // Date Selection
                  _buildDateSelection(),

                  const SizedBox(height: 20),

                  // Blockbuster Tuesday Offer Toggle
                  _buildOfferToggle(),

                  const SizedBox(height: 30),

                  // Book Tickets Button
                  _buildBookButton(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenreTags(List genres) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: genres.map((genre) {
        IconData icon;
        Color color;
        
        switch (genre.toString().toLowerCase()) {
          case 'adventure':
            icon = Icons.terrain;
            color = Colors.teal;
            break;
          case 'drama':
            icon = Icons.theater_comedy;
            color = Colors.orange;
            break;
          case 'thriller':
            icon = Icons.warning_amber_rounded;
            color = Colors.yellow;
            break;
          case 'action':
            icon = Icons.local_fire_department;
            color = Colors.red;
            break;
          case 'comedy':
            icon = Icons.emoji_emotions;
            color = Colors.pink;
            break;
          case 'horror':
            icon = Icons.nightlight_round;
            color = Colors.purple;
            break;
          default:
            icon = Icons.movie;
            color = Colors.blue;
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.5)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                genre.toString(),
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCastSection(List cast) {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cast.length,
        itemBuilder: (context, index) {
          final member = cast[index];
          final imagePath = member['image'] ?? '';
          
          return Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.grey[800],
                  backgroundImage: imagePath.startsWith('assets/')
                      ? AssetImage(imagePath) as ImageProvider
                      : NetworkImage(imagePath),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 70,
                  child: Text(
                    member['name'] ?? 'Unknown',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOffersSection(List offers) {
    final firstOffer = offers.isNotEmpty ? offers[0].toString() : 'Special offers available';
    final displayText = firstOffer.length > 35 
        ? '${firstOffer.substring(0, 35)}...' 
        : firstOffer;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withValues(alpha: 0.3),
            Colors.blue.withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Icon(Icons.local_offer, color: Colors.purple[300], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              displayText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
        ],
      ),
    );
  }

  Widget _buildBlockbusterBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Text(
          'Blockbuster Tuesdays: Shows starting from ₹92',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildDateSelection() {
    // Get current month abbreviation
    final now = DateTime.now();
    final monthAbbr = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
                       'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'][now.month - 1];
    
    return Row(
      children: [
        // Month Label
        Container(
          width: 40,
          alignment: Alignment.center,
          child: RotatedBox(
            quarterTurns: 3,
            child: Text(
              monthAbbr,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
        
        const SizedBox(width: 8),

        // Date Boxes
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(availableDates.length, (index) {
              final date = availableDates[index];
              final isSelected = selectedDateIndex == index;
              
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDateIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? const Color(0xFF6366F1) 
                          : Colors.grey[900],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF6366F1)
                            : Colors.grey[800]!,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            date['date'] ?? '',
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.grey[400],
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            date['day'] ?? '',
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildOfferToggle() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Blockbuster Tuesday Offer',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Shows ranging from ₹0-₹150',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isBlockbusterOfferEnabled,
            onChanged: (value) {
              setState(() {
                isBlockbusterOfferEnabled = value;
              });
            },
            activeThumbColor: const Color(0xFF6366F1),
          ),
        ],
      ),
    );
  }

  Widget _buildBookButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          final movie = Movie.fromMap(widget.movieData);
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => SeatSelectionBottomSheet(movie: movie),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFEF4444),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Select Seats',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}