import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/booking_model.dart';
import '../../providers/content_provider.dart';
import '../../widgets/district_cached_image.dart';

class MyBookingsScreen extends ConsumerStatefulWidget {
  const MyBookingsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends ConsumerState<MyBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookingsAsync = ref.watch(userBookingsProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Bookings & Tickets',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF6366F1),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          isScrollable: true,
          labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'All Bookings'),
            Tab(text: 'Movies 🎬'),
            Tab(text: 'Events 🎟️'),
            Tab(text: 'Dining 🍽️'),
          ],
        ),
      ),
      body: bookingsAsync.when(
        data: (allBookings) {
          final movies = allBookings.where((b) => b.itemType == 'movie').toList();
          final events = allBookings.where((b) => b.itemType == 'event').toList();
          final dining = allBookings.where((b) => b.itemType == 'dining').toList();

          return TabBarView(
            controller: _tabController,
            children: [
              _buildBookingsList(allBookings, 'No bookings found yet.'),
              _buildBookingsList(movies, 'No movie tickets booked yet.'),
              _buildBookingsList(events, 'No event passes booked yet.'),
              _buildBookingsList(dining, 'No table reservations made yet.'),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFF6366F1)),
        ),
        error: (e, _) => Center(
          child: Text(
            'Error loading bookings: $e',
            style: const TextStyle(color: Colors.redAccent),
          ),
        ),
      ),
    );
  }

  Widget _buildBookingsList(List<Booking> list, String emptyMessage) {
    if (list.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.confirmation_number_outlined,
                size: 64,
                color: Colors.grey.shade700,
              ),
              const SizedBox(height: 16),
              Text(
                emptyMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Book movies, concerts, or tables to view your active digital passes here.',
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

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return _buildDigitalTicket(list[index]);
      },
    );
  }

  Widget _buildDigitalTicket(Booking booking) {
    final bool isMovie = booking.itemType == 'movie';
    final bool isDining = booking.itemType == 'dining';
    final bool isActivity = booking.itemType == 'activity';
    final Color badgeColor = isMovie
        ? const Color(0xFF6366F1)
        : (isDining
            ? const Color(0xFFEF4444)
            : (isActivity ? const Color(0xFF10B981) : const Color(0xFFF59E0B)));

    final String fallback = isMovie
        ? 'assets/movieimg/movies/banner1.jpg'
        : (isDining
            ? 'assets/images/masala-synergy.jpeg'
            : (isActivity ? 'assets/images/sports.jpg' : 'assets/images/messi_event.jpg'));

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF161622),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF262638), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top ticket section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: 70,
                    height: 85,
                    child: DistrictCachedImage(
                      imageUrl: booking.imageUrl,
                      fallbackAsset: fallback,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: badgeColor.withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                booking.itemType.toUpperCase(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: badgeColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check_circle, size: 12, color: Color(0xFF10B981)),
                                SizedBox(width: 4),
                                Text(
                                  'CONFIRMED',
                                  style: TextStyle(
                                    color: Color(0xFF10B981),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        booking.itemTitle,
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
                        '${booking.date} • ${booking.time}',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        booking.details,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Perforated divider line
          Row(
            children: [
              Container(
                width: 14,
                height: 24,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.horizontal(right: Radius.circular(12)),
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final count = (constraints.constrainWidth() / 10).floor();
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        count,
                        (_) => const SizedBox(
                          width: 5,
                          height: 1.5,
                          child: DecoratedBox(
                            decoration: BoxDecoration(color: Color(0xFF38384C)),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                width: 14,
                height: 24,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
                ),
              ),
            ],
          ),

          // Bottom ticket section (Reference, QR, Price)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'BOOKING REF',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 10,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        booking.bookingReference,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (booking.totalPrice > 0)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'AMOUNT PAID',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 10,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '₹${booking.totalPrice}',
                        style: const TextStyle(
                          color: Color(0xFF10B981),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF222230),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Table Reserved',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
