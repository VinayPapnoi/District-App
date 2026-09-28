import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/content_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../widgets/district_cached_image.dart';

class StoreItem {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final double rating;
  final int totalRatings;
  final String mallLocation;
  final String floor;
  final String timings;
  final String phone;
  final String offer;
  final String description;
  final List<String> tags;

  const StoreItem({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.totalRatings,
    required this.mallLocation,
    required this.floor,
    required this.timings,
    required this.phone,
    required this.offer,
    required this.description,
    required this.tags,
  });
}

class StoresPage extends ConsumerStatefulWidget {
  const StoresPage({Key? key}) : super(key: key);

  @override
  ConsumerState<StoresPage> createState() => _StoresPageState();
}

class _StoresPageState extends ConsumerState<StoresPage> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Tech & Gadgets',
    'Fashion',
    'Sportswear',
    'Toys & Kids',
    'Beauty',
  ];

  static const List<StoreItem> _stores = [
    StoreItem(
      id: 'store_001',
      name: 'Apple Store Flagship',
      category: 'Tech & Gadgets',
      imageUrl: 'assets/images/spotlight_banner.png',
      rating: 4.9,
      totalRatings: 3400,
      mallLocation: 'DLF Mall of India, Noida',
      floor: 'Ground Floor, Unit G-12',
      timings: '10:00 AM - 10:00 PM',
      phone: '+91 120 456 7890',
      offer: 'Up to ₹8,000 instant cashback with HDFC cards',
      description:
          'Official Apple flagship experience with hands-on demo tables, Genius Bar appointments, and trade-in support.',
      tags: ['Genius Bar', 'Trade-In', 'Official Warranty'],
    ),
    StoreItem(
      id: 'store_002',
      name: 'Nike Live Concept Store',
      category: 'Sportswear',
      imageUrl: 'assets/images/sports.jpg',
      rating: 4.8,
      totalRatings: 1890,
      mallLocation: 'Cyber Hub, Gurugram',
      floor: 'Floor 1, Shop 104',
      timings: '11:00 AM - 10:30 PM',
      phone: '+91 124 888 1234',
      offer: 'Flat 15% cashback on District Pay',
      description:
          'Neighborhood-centric store featuring cutting-edge running shoes, Jordan retro drops, and personalized gait analysis.',
      tags: ['Sneaker Releases', 'Gait Analysis', 'Member Perks'],
    ),
    StoreItem(
      id: 'store_003',
      name: 'Zara & Home Collection',
      category: 'Fashion',
      imageUrl: 'assets/images/banner_halloween.jpg',
      rating: 4.6,
      totalRatings: 2650,
      mallLocation: 'Logix City Centre, Noida',
      floor: 'Ground & 1st Floor',
      timings: '10:30 AM - 10:00 PM',
      phone: '+91 120 333 4567',
      offer: 'End of Season Sale: Up to 40% off',
      description:
          'Spacious multi-level flagship carrying modern runway edits, tailored formalwear, fragrance collection, and Zara Home accents.',
      tags: ['Runway Edits', 'Zara Home', 'Express Self-Checkout'],
    ),
    StoreItem(
      id: 'store_004',
      name: 'Hamleys World of Wonders',
      category: 'Toys & Kids',
      imageUrl: 'assets/images/festival_icon.png',
      rating: 4.7,
      totalRatings: 1200,
      mallLocation: 'Ambience Mall, Vasant Kunj',
      floor: 'Floor 2, Toy Kingdom',
      timings: '10:00 AM - 09:30 PM',
      phone: '+91 11 4455 6677',
      offer: 'Free toy gift on orders above ₹1,999',
      description:
          'The finest toy shop in the world with live magic demos, remote-control arenas, Lego builders corner, and plush towers.',
      tags: ['Live Demos', 'Lego Corner', 'Gift Wrapping'],
    ),
    StoreItem(
      id: 'store_005',
      name: 'Sephora Beauty Studio',
      category: 'Beauty',
      imageUrl: 'assets/images/female.jpg',
      rating: 4.8,
      totalRatings: 1780,
      mallLocation: 'Connaught Place, Delhi',
      floor: 'Block B, Inner Circle',
      timings: '11:00 AM - 09:00 PM',
      phone: '+91 11 2345 6789',
      offer: 'Complimentary 15-min flash makeover',
      description:
          'Curated global beauty haven featuring Rare Beauty, Fenty, Huda, premium skincare consultations, and fragrance bar.',
      tags: ['Flash Makeovers', 'Rare Beauty', 'Skin Scanner'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider).trim().toLowerCase();

    final filtered = _stores.where((store) {
      final matchesCategory = _selectedCategory == 'All' || store.category == _selectedCategory;
      final matchesQuery = query.isEmpty ||
          store.name.toLowerCase().contains(query) ||
          store.category.toLowerCase().contains(query) ||
          store.mallLocation.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            // Top Mall & Rewards Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF064E3B), Color(0xFF0F172A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF34D399), size: 28),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'District Retail Privilege',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Earn instant rewards & flat cashback across all partner stores',
                            style: TextStyle(
                              color: Color(0xFFCBD5E1),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Category Horizontal Filter Bar
            SizedBox(
              height: 38,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        cat,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey.shade400,
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: const Color(0xFF10B981),
                      backgroundColor: const Color(0xFF181824),
                      side: BorderSide(
                        color: isSelected ? const Color(0xFF34D399) : const Color(0xFF262636),
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedCategory = cat);
                        }
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Stores List
            if (filtered.isEmpty)
              Padding(
                padding: const EdgeInsets.all(40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.storefront_outlined, size: 54, color: Colors.grey.shade700),
                      const SizedBox(height: 12),
                      const Text(
                        'No stores found',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Try searching by brand, category, or mall location.',
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  return _buildStoreCard(filtered[index]);
                },
              ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreCard(StoreItem store) {
    final isFav = ref.watch(favoritesProvider).contains(store.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF14141F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF242436), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          width: 68,
                          height: 68,
                          child: DistrictCachedImage(
                            imageUrl: store.imageUrl,
                            fallbackAsset: 'assets/images/spotlight_banner.png',
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
                              store.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${store.category} • ${store.floor}',
                              style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF10B981).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.star, color: Color(0xFF10B981), size: 12),
                                      const SizedBox(width: 3),
                                      Text(
                                        '${store.rating}',
                                        style: const TextStyle(
                                          color: Color(0xFF10B981),
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '(${store.totalRatings} ratings)',
                                  style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isFav ? Icons.bookmark : Icons.bookmark_border,
                          color: isFav ? const Color(0xFFF59E0B) : Colors.white,
                        ),
                        onPressed: () {
                          ref.read(favoritesProvider.notifier).toggleFavorite(store.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: const Color(0xFF1E1E28),
                              duration: const Duration(seconds: 2),
                              content: Text(
                                isFav ? 'Removed "${store.name}" from Saved' : 'Saved "${store.name}" ❤️',
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  Text(
                    store.description,
                    style: TextStyle(color: Colors.grey.shade300, fontSize: 13, height: 1.3),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 10),

                  // Promotional Perk Tag
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.local_offer, color: Color(0xFF34D399), size: 14),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            store.offer,
                            style: const TextStyle(color: Color(0xFF34D399), fontSize: 11, fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),
                  const Divider(color: Color(0xFF262638)),
                  const SizedBox(height: 6),

                  // Bottom action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, color: Colors.grey.shade500, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            store.mallLocation,
                            style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
                          ),
                        ],
                      ),
                      OutlinedButton(
                        onPressed: () => _showStoreDetails(store),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF10B981)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        ),
                        child: const Text('Store Info', style: TextStyle(color: Color(0xFF10B981), fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStoreDetails(StoreItem store) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF12121A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade700,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(store.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('${store.category} • ${store.mallLocation}', style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
            const SizedBox(height: 16),

            _buildDetailRow(Icons.access_time, 'Timings', store.timings),
            const SizedBox(height: 10),
            _buildDetailRow(Icons.layers_outlined, 'Floor & Unit', store.floor),
            const SizedBox(height: 10),
            _buildDetailRow(Icons.phone_outlined, 'Contact', store.phone),
            const SizedBox(height: 10),
            _buildDetailRow(Icons.local_offer_outlined, 'Exclusive Offer', store.offer),

            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.call, color: Colors.white, size: 18),
                    label: const Text('Call Store', style: TextStyle(color: Colors.white)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: const Color(0xFF1E1E28),
                          content: Text('📞 Connecting to ${store.name} (${store.phone})...'),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.navigation, color: Colors.black, size: 18),
                    label: const Text('Directions', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: const Color(0xFF10B981),
                          content: Text('📍 Navigating to ${store.floor} at ${store.mallLocation}'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF10B981), size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }
}
