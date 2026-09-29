import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/booking_model.dart';
import '../../repositories/content_repository.dart';
import '../../providers/favorites_provider.dart';
import '../../widgets/district_cached_image.dart';

class DiningDetailScreen extends StatefulWidget {
  final Map<String, dynamic> restaurantData;

  const DiningDetailScreen({
    Key? key,
    required this.restaurantData,
  }) : super(key: key);

  @override
  State<DiningDetailScreen> createState() => _DiningDetailScreenState();
}

class _DiningDetailScreenState extends State<DiningDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String restaurantId = widget.restaurantData['id']?.toString() ?? '';
    final String restaurantName = widget.restaurantData['name'] ?? widget.restaurantData['title'] ?? 'Restaurant';
    final String imageUrl = widget.restaurantData['imageUrl']?.toString() ??
        widget.restaurantData['image']?.toString() ??
        '';

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          // App Bar with Restaurant Image
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              Consumer(
                builder: (context, ref, _) {
                  final isFav = ref.watch(favoritesProvider).contains(restaurantId);
                  return IconButton(
                    icon: Icon(
                      isFav ? Icons.bookmark : Icons.bookmark_border,
                      color: isFav ? const Color(0xFFF59E0B) : Colors.white,
                    ),
                    onPressed: () {
                      ref.read(favoritesProvider.notifier).toggleFavorite(restaurantId);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: const Color(0xFF1E1E28),
                          duration: const Duration(seconds: 2),
                          content: Text(
                            isFav ? 'Removed "$restaurantName" from Saved Plans' : 'Saved "$restaurantName" to Plans ❤️',
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
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  DistrictCachedImage(
                    imageUrl: imageUrl,
                    fallbackAsset: 'assets/images/masala-synergy.jpeg',
                    fit: BoxFit.cover,
                  ),
                  // View Gallery Button
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: ElevatedButton(
                      onPressed: () {
                        _showGallery();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'View gallery',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Restaurant Name & Rating
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.restaurantData['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  (widget.restaurantData['rating'] ?? 4.5).toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.star,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${widget.restaurantData['totalRatings'] ?? 100}',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.restaurantData['cuisine']?.toString() ?? 'Multi-Cuisine',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.restaurantData['location']?.toString() ?? 'Downtown',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.access_time,
                              color: Colors.grey[400], size: 16),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              widget.restaurantData['timings']?.toString() ?? 'Open • Timings vary',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Divider(color: Colors.grey, height: 1),

                // Quick Info Section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: _buildQuickInfo(
                          icon: Icons.location_on,
                          label: widget.restaurantData['distance']?.toString() ?? 'Nearby',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildQuickInfo(
                          icon: Icons.access_time,
                          label: 'What\'s good here?',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildQuickInfo(
                          icon: Icons.currency_rupee,
                          label: widget.restaurantData['priceForTwo']?.toString() ?? '₹1,000 for two',
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(color: Colors.grey, height: 1),

                // Tab Bar
                Container(
                  color: Colors.grey[900],
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.red,
                    indicatorWeight: 3,
                    tabs: const [
                      Tab(text: 'Offers'),
                      Tab(text: 'Menu'),
                      Tab(text: 'Gallery'),
                      Tab(text: 'Reviews'),
                    ],
                  ),
                ),

                // Tab Content
                _buildTabContent(),

                const SizedBox(height: 80), // Space for bottom buttons
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomButtons(),
    );
  }

  Widget _buildQuickInfo({required IconData icon, required String label}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.grey[400], size: 20),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildOffersTab();
      case 1:
        return _buildMenuTab();
      case 2:
        return _buildGalleryTab();
      case 3:
        return _buildReviewsTab();
      default:
        return _buildOffersTab();
    }
  }

  Widget _buildOffersTab() {
    final rawOffers = widget.restaurantData['offers'];
    final offers = (rawOffers is List) ? rawOffers : [];

    if (offers.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text(
              'No active offers available at this time',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Offers',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...offers.map((offer) {
            final offerMap = offer is Map ? Map<String, dynamic>.from(offer) : <String, dynamic>{};
            return _buildOfferCard(offerMap);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildOfferCard(Map<String, dynamic> offer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withOpacity(0.3),
            Colors.blue.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (offer['icon'] == 'carnival')
            Row(
              children: [
                const Icon(Icons.celebration, color: Colors.purple, size: 20),
                const SizedBox(width: 8),
                Text(
                  offer['title']?.toString() ?? 'Special Offer',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          else
            Text(
              offer['title']?.toString() ?? 'Special Offer',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          const SizedBox(height: 8),
          if (offer['validFrom'] != null)
            Text(
              offer['validFrom'].toString(),
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
              ),
            ),
          if (offer['description'] != null)
            Text(
              offer['description'].toString(),
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 14,
              ),
            ),
          if (offer['details'] != null)
            Text(
              offer['details'].toString(),
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 14,
              ),
            ),
          if (offer['buttonText'] != null) ...[
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _showTableBookingSheet(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                offer['buttonText'].toString(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMenuTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.restaurantData['menuUpdated']?.toString() ?? 'Updated recently',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'What\'s good here',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.restaurantData['whatsGoodHere']?.toString() ??
                      'Chef specials and seasonal favorites',
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryTab() {
    final rawGallery = widget.restaurantData['galleryUrls'] ??
        widget.restaurantData['gallery'];
    final gallery = (rawGallery is List)
        ? rawGallery.map((e) => e.toString()).toList()
        : <String>[];

    if (gallery.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Column(
              children: [
                Icon(Icons.photo_library_outlined, color: Colors.grey, size: 40),
                SizedBox(height: 12),
                Text(
                  'No gallery photos available yet',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: gallery.length,
        itemBuilder: (context, index) {
          final imgUrl = gallery[index];
          return GestureDetector(
            onTap: () => _openFullScreenGallery(gallery, index),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: DistrictCachedImage(
                imageUrl: imgUrl,
                fallbackAsset: 'assets/images/food.jpg',
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReviewsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Reviews',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                'No reviews yet',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showTableBookingSheet(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Book a table',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showPayBillSheet(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Pay bill',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTableBookingSheet(BuildContext context) {
    int guests = 2;
    String selectedSlot = '7:30 PM (Dinner)';
    final List<String> slots = [
      '1:00 PM (Lunch)',
      '1:45 PM (Lunch)',
      '7:30 PM (Dinner)',
      '8:30 PM (Dinner)',
      '9:15 PM (Dinner)',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          return SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF13131A),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade700,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Reserve a Table at ${widget.restaurantData['name'] ?? 'Restaurant'}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.restaurantData['location'] ?? '',
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                    ),
                    const SizedBox(height: 20),

                // Number of guests
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Guests',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: Colors.white70),
                          onPressed: guests > 1
                              ? () => setSheetState(() => guests--)
                              : null,
                        ),
                        Text(
                          '$guests People',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, color: Colors.white70),
                          onPressed: guests < 12
                              ? () => setSheetState(() => guests++)
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Time Slots
                const Text(
                  'Select Time Slot',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: slots.map((slot) {
                    final isSel = selectedSlot == slot;
                    return ChoiceChip(
                      label: Text(slot),
                      selected: isSel,
                      selectedColor: const Color(0xFFEF4444),
                      backgroundColor: const Color(0xFF22222E),
                      labelStyle: TextStyle(
                        color: isSel ? Colors.white : Colors.grey.shade400,
                        fontSize: 12,
                      ),
                      onSelected: (val) {
                        if (val) setSheetState(() => selectedSlot = slot);
                      },
                    );
                  }).toList(),
                ),

                const Divider(color: Color(0xFF262636)),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(ctx);
                      final refCode =
                          'TBL-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

                      final booking = Booking(
                        id: 'booking_${DateTime.now().millisecondsSinceEpoch}',
                        userId: 'guest_user',
                        itemTitle: widget.restaurantData['name'] ??
                            widget.restaurantData['title'] ??
                            'Restaurant',
                        itemType: 'dining',
                        imageUrl:
                            widget.restaurantData['imageUrl']?.toString() ??
                                widget.restaurantData['image']?.toString() ??
                                '',
                        date: 'Today',
                        time: selectedSlot,
                        details: 'Table for $guests guests ($selectedSlot)',
                        totalPrice: 0,
                        bookingReference: refCode,
                        createdAt: DateTime.now(),
                      );

                      await ContentRepository().saveBooking(booking);

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: const Color(0xFF10B981),
                            content: Text(
                              '🎉 Table for $guests confirmed ($selectedSlot)! Ref: $refCode',
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF4444),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Confirm Reservation',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      );
    },
  ),
);
}

  void _showPayBillSheet(BuildContext context) {
    final TextEditingController amountController =
        TextEditingController(text: '1200');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF13131A),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade700,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Pay Dining Bill at ${widget.restaurantData['name'] ?? ''}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    decoration: InputDecoration(
                      prefixText: '₹ ',
                      prefixStyle: const TextStyle(color: Color(0xFF10B981), fontSize: 18),
                      labelText: 'Enter Bill Amount',
                      labelStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFF22222E),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: const Color(0xFF10B981),
                            content: Text(
                              '✅ Bill payment of ₹${amountController.text} processed successfully with 10% instant discount applied!',
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Proceed to Pay with Discount',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showGallery() {
    final rawGallery = widget.restaurantData['galleryUrls'] ??
        widget.restaurantData['gallery'];
    final gallery = (rawGallery is List)
        ? rawGallery.map((e) => e.toString()).toList()
        : <String>[];

    if (gallery.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFF1E1E28),
          content: Text('No gallery photos available for this venue.'),
        ),
      );
      return;
    }

    _openFullScreenGallery(gallery, 0);
  }

  void _openFullScreenGallery(List<String> photos, int initialIndex) {
    final name = widget.restaurantData['name'] ??
        widget.restaurantData['title'] ??
        'Gallery';
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => _FullScreenGalleryViewer(
          photos: photos,
          initialIndex: initialIndex,
          restaurantName: name.toString(),
        ),
      ),
    );
  }
}

class _FullScreenGalleryViewer extends StatefulWidget {
  final List<String> photos;
  final int initialIndex;
  final String restaurantName;

  const _FullScreenGalleryViewer({
    Key? key,
    required this.photos,
    required this.initialIndex,
    required this.restaurantName,
  }) : super(key: key);

  @override
  State<_FullScreenGalleryViewer> createState() =>
      _FullScreenGalleryViewerState();
}

class _FullScreenGalleryViewerState extends State<_FullScreenGalleryViewer> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09090E),
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.restaurantName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${_currentIndex + 1} of ${widget.photos.length}',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.photos.length,
            onPageChanged: (idx) {
              setState(() => _currentIndex = idx);
            },
            itemBuilder: (context, index) {
              return InteractiveViewer(
                minScale: 1.0,
                maxScale: 3.5,
                child: Center(
                  child: DistrictCachedImage(
                    imageUrl: widget.photos[index],
                    fallbackAsset: 'assets/images/food.jpg',
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),

          // Bottom indicator dots if multiple photos
          if (widget.photos.length > 1)
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.photos.length, (idx) {
                  final isSelected = idx == _currentIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isSelected ? 20 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF6366F1)
                          : Colors.grey.shade700,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}