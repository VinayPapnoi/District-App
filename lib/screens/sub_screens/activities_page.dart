import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/booking_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/content_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../widgets/district_cached_image.dart';

class ActivityItem {
  final String id;
  final String title;
  final String category;
  final String imageUrl;
  final double rating;
  final int totalRatings;
  final int pricePerPerson;
  final String duration;
  final String location;
  final String ageLimit;
  final String description;
  final List<String> highlights;

  const ActivityItem({
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.totalRatings,
    required this.pricePerPerson,
    required this.duration,
    required this.location,
    required this.ageLimit,
    required this.description,
    required this.highlights,
  });
}

class ActivitiesPage extends ConsumerStatefulWidget {
  const ActivitiesPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends ConsumerState<ActivitiesPage> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Go-Karting',
    'VR & Arcade',
    'Escape Rooms',
    'Bowling',
    'Trampoline',
  ];

  static const List<ActivityItem> _activities = [
    ActivityItem(
      id: 'act_001',
      title: 'Formula 1 Go-Karting Arena',
      category: 'Go-Karting',
      imageUrl: 'assets/images/sports.jpg',
      rating: 4.8,
      totalRatings: 1420,
      pricePerPerson: 699,
      duration: '30 mins',
      location: 'DLF Mall, Noida • 3.2 km',
      ageLimit: '12+ yrs',
      description:
          'High-speed twin-engine karts with live telemetry timing, professional gear, and multi-level asphalt track.',
      highlights: ['Pro Timing Rig', 'Safety Gear Included', 'Podium Ceremony'],
    ),
    ActivityItem(
      id: 'act_002',
      title: 'Smaaash VR & Arcade Arena',
      category: 'VR & Arcade',
      imageUrl: 'assets/images/rolling.jpeg',
      rating: 4.6,
      totalRatings: 980,
      pricePerPerson: 499,
      duration: '60 mins',
      location: 'Cyber Hub, Gurugram • 6.5 km',
      ageLimit: 'All ages',
      description:
          'Immersive VR roller coasters, interactive cricket pitch simulation, and 50+ classic & modern arcade machines.',
      highlights: ['VR Roller Coaster', 'Cricket Sim', 'Unlimited Playpass'],
    ),
    ActivityItem(
      id: 'act_003',
      title: 'Mystery Rooms: Alcatraz Escape',
      category: 'Escape Rooms',
      imageUrl: 'assets/images/hell.jpg',
      rating: 4.9,
      totalRatings: 2150,
      pricePerPerson: 799,
      duration: '60 mins',
      location: 'Connaught Place, Delhi • 1.8 km',
      ageLimit: '10+ yrs',
      description:
          'Real-life mystery puzzle where your squad has 60 minutes to crack secret codes and escape maximum security.',
      highlights: ['Hollywood Props', 'Clue Assistance', 'Team Building'],
    ),
    ActivityItem(
      id: 'act_004',
      title: 'Amoeba Cosmic Bowling & Laser',
      category: 'Bowling',
      imageUrl: 'assets/images/nightlife.jpg',
      rating: 4.5,
      totalRatings: 760,
      pricePerPerson: 350,
      duration: '45 mins',
      location: 'Logix City Centre, Noida • 2.1 km',
      ageLimit: 'All ages',
      description:
          'Glow-in-the-dark cosmic bowling lanes, DJ music lounge, tasty finger foods, and indoor laser tag arena.',
      highlights: ['Cosmic Glow', 'Shoe Rental Free', 'Snack Lounge'],
    ),
    ActivityItem(
      id: 'act_005',
      title: 'SkyJumper Trampoline & Foam Pit',
      category: 'Trampoline',
      imageUrl: 'assets/images/messi_event.jpg',
      rating: 4.7,
      totalRatings: 1840,
      pricePerPerson: 550,
      duration: '60 mins',
      location: 'Sector 29, Gurugram • 7.0 km',
      ageLimit: '5+ yrs',
      description:
          'Massive indoor trampoline park featuring interconnected bouncy courts, slam-dunk hoops, and foam pit diving.',
      highlights: ['Foam Pit Drop', 'Slam Dunk Hoops', 'Grip Socks Incl.'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider).trim().toLowerCase();

    final filtered = _activities.where((act) {
      final matchesCategory = _selectedCategory == 'All' || act.category == _selectedCategory;
      final matchesQuery = query.isEmpty ||
          act.title.toLowerCase().contains(query) ||
          act.category.toLowerCase().contains(query) ||
          act.location.toLowerCase().contains(query);
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

            // Top Highlights Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2E1065), Color(0xFF0F172A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.flash_on, color: Color(0xFFA855F7), size: 28),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Weekend Adventure Pass',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Book top activities & get flat ₹200 instant cashback',
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

            // Category Filter Bar
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
                      selectedColor: const Color(0xFF6366F1),
                      backgroundColor: const Color(0xFF181824),
                      side: BorderSide(
                        color: isSelected ? const Color(0xFF818CF8) : const Color(0xFF262636),
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

            // Activities List
            if (filtered.isEmpty)
              Padding(
                padding: const EdgeInsets.all(40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.sports_esports_outlined, size: 54, color: Colors.grey.shade700),
                      const SizedBox(height: 12),
                      const Text(
                        'No activities found',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Try searching for other categories or locations.',
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
                  return _buildActivityCard(filtered[index]);
                },
              ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard(ActivityItem item) {
    final isFav = ref.watch(favoritesProvider).contains(item.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
            // Image Stack
            Stack(
              children: [
                SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: DistrictCachedImage(
                    imageUrl: item.imageUrl,
                    fallbackAsset: 'assets/images/sports.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF6366F1)),
                    ),
                    child: Text(
                      item.category,
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withValues(alpha: 0.65),
                    radius: 18,
                    child: IconButton(
                      iconSize: 18,
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        isFav ? Icons.bookmark : Icons.bookmark_border,
                        color: isFav ? const Color(0xFFF59E0B) : Colors.white,
                      ),
                      onPressed: () {
                        ref.read(favoritesProvider.notifier).toggleFavorite(item.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: const Color(0xFF1E1E28),
                            duration: const Duration(seconds: 2),
                            content: Text(
                              isFav ? 'Removed "${item.title}" from Saved Plans' : 'Saved "${item.title}" to Plans ❤️',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.4)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: Color(0xFF10B981), size: 13),
                            const SizedBox(width: 3),
                            Text(
                              '${item.rating}',
                              style: const TextStyle(color: Color(0xFF10B981), fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.location,
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.description,
                    style: TextStyle(color: Colors.grey.shade300, fontSize: 13, height: 1.3),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),

                  // Highlights Tags
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: item.highlights.map((h) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E2C),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '• $h',
                          style: TextStyle(color: Colors.grey.shade300, fontSize: 11),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFF262638)),
                  const SizedBox(height: 10),

                  // Bottom action row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'From ₹${item.pricePerPerson}',
                            style: const TextStyle(
                              color: Color(0xFF10B981),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'per player • ${item.duration}',
                            style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () => _showBookingSheet(item),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6366F1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        child: const Text(
                          'Book Slot',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
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

  void _showBookingSheet(ActivityItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _ActivityBookingSheet(activity: item),
    );
  }
}

class _ActivityBookingSheet extends ConsumerStatefulWidget {
  final ActivityItem activity;

  const _ActivityBookingSheet({Key? key, required this.activity}) : super(key: key);

  @override
  ConsumerState<_ActivityBookingSheet> createState() => _ActivityBookingSheetState();
}

class _ActivityBookingSheetState extends ConsumerState<_ActivityBookingSheet> {
  String _selectedDay = 'Today';
  String _selectedTime = '5:00 PM';
  int _playersCount = 2;
  bool _isSaving = false;

  final List<String> _days = ['Today', 'Tomorrow', 'This Saturday', 'This Sunday'];
  final List<String> _timeSlots = ['11:30 AM', '2:00 PM', '4:30 PM', '7:00 PM', '9:30 PM'];

  @override
  Widget build(BuildContext context) {
    final total = _playersCount * widget.activity.pricePerPerson;

    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF12121A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
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

              Text(
                widget.activity.title,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                '${widget.activity.location} • ₹${widget.activity.pricePerPerson}/player',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
              ),
              const SizedBox(height: 18),

              // Date Selector
              const Text('Select Date', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _days.map((day) {
                    final isSelected = _selectedDay == day;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(day, style: TextStyle(color: isSelected ? Colors.white : Colors.grey.shade400, fontSize: 12)),
                        selected: isSelected,
                        selectedColor: const Color(0xFF6366F1),
                        backgroundColor: const Color(0xFF1E1E2A),
                        onSelected: (val) {
                          if (val) setState(() => _selectedDay = day);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 16),

              // Time Slot Selector
              const Text('Select Time Slot', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _timeSlots.map((time) {
                    final isSelected = _selectedTime == time;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(time, style: TextStyle(color: isSelected ? Colors.white : Colors.grey.shade400, fontSize: 12)),
                        selected: isSelected,
                        selectedColor: const Color(0xFF6366F1),
                        backgroundColor: const Color(0xFF1E1E2A),
                        onSelected: (val) {
                          if (val) setState(() => _selectedTime = time);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 16),

              // Players Count
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(
                    child: Text('Players / Guests', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E2A),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF262636)),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove, color: Colors.white, size: 18),
                          onPressed: _playersCount > 1 ? () => setState(() => _playersCount--) : null,
                        ),
                        Text(
                          '$_playersCount',
                          style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, color: Colors.white, size: 18),
                          onPressed: _playersCount < 8 ? () => setState(() => _playersCount++) : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              const Divider(color: Color(0xFF262636)),
              const SizedBox(height: 10),

              // Confirmation Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total Amount', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '₹$total',
                            style: const TextStyle(color: Color(0xFF10B981), fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _confirmBooking,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6366F1),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        child: _isSaving
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text('Confirm & Book', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmBooking() async {
    setState(() => _isSaving = true);

    final userId = ref.read(authProvider.select((s) => s.userId)) ?? 'guest_user';
    final refCode = 'DST-ACT-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    final booking = Booking(
      id: 'act_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      itemTitle: widget.activity.title,
      itemType: 'activity',
      imageUrl: widget.activity.imageUrl,
      date: _selectedDay,
      time: _selectedTime,
      details: 'Players: $_playersCount • ${widget.activity.duration}',
      totalPrice: _playersCount * widget.activity.pricePerPerson,
      bookingReference: refCode,
      createdAt: DateTime.now(),
    );

    try {
      await ref.read(contentRepositoryProvider).saveBooking(booking);

      if (!mounted) return;
      Navigator.pop(context); // close bottom sheet

      showDialog(
        context: context,
        builder: (dialogCtx) => Dialog(
          backgroundColor: const Color(0xFF181824),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 56),
                const SizedBox(height: 12),
                const Text(
                  'Experience Booked!',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ref: $refCode',
                  style: const TextStyle(color: Color(0xFF6366F1), fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFF101018), borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      _buildRow('Activity', widget.activity.title),
                      const SizedBox(height: 6),
                      _buildRow('When', '$_selectedDay at $_selectedTime'),
                      const SizedBox(height: 6),
                      _buildRow('Party Size', '$_playersCount players'),
                      const SizedBox(height: 6),
                      _buildRow('Total Paid', '₹${booking.totalPrice}'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(dialogCtx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Done', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: const Color(0xFFDC2626), content: Text('Booking error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
