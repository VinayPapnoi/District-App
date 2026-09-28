import 'package:flutter/material.dart';
import '../../widgets/district_cached_image.dart';

class EventDetailScreen extends StatefulWidget {
  final Map<String, dynamic> eventData;

  const EventDetailScreen({
    Key? key,
    required this.eventData,
  }) : super(key: key);

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  int selectedDateIndex = 0;

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.eventData['imageUrl']?.toString() ??
        widget.eventData['image']?.toString() ??
        '';

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
                    fallbackAsset: 'assets/images/messi_event.jpg',
                    fit: BoxFit.cover,
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
                  // Event Title
                  Text(
                    widget.eventData['title'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Category Tags
                  _buildCategoryTags(),

                  const SizedBox(height: 16),

                  // Event Info Cards
                  _buildInfoCard(
                    icon: Icons.calendar_today,
                    title: 'Date & Time',
                    subtitle: widget.eventData['dateTime'] ?? 'TBA',
                  ),

                  const SizedBox(height: 12),

                  _buildInfoCard(
                    icon: Icons.location_on,
                    title: 'Venue',
                    subtitle: widget.eventData['venue'] ?? 'TBA',
                  ),

                  const SizedBox(height: 12),

                  _buildInfoCard(
                    icon: Icons.language,
                    title: 'Language',
                    subtitle: widget.eventData['language'] ?? 'English',
                  ),

                  const SizedBox(height: 20),

                  // About Section
                  const Text(
                    'About',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.eventData['description'] ?? 'No description available.',
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Terms & Conditions
                  _buildExpandableSection(
                    title: 'Terms & Conditions',
                    content: widget.eventData['terms'] ?? 'Please check with the organizer.',
                  ),

                  const SizedBox(height: 16),

                  // Available Dates (if any)
                  if (widget.eventData['availableDates'] != null)
                    _buildDateSelection(),

                  const SizedBox(height: 30),

                  // Book Now Button
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

  Widget _buildCategoryTags() {
    final categories = (widget.eventData['categories'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];
    
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categories.map((category) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.purple.withOpacity(0.5)),
          ),
          child: Text(
            category,
            style: const TextStyle(
              color: Colors.purple,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.purple, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required String content,
  }) {
    return ExpansionTile(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      iconColor: Colors.white,
      collapsedIconColor: Colors.grey,
      backgroundColor: Colors.grey[900],
      collapsedBackgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[800]!),
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[800]!),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            content,
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelection() {
    final dates = widget.eventData['availableDates'] as List? ?? [];
    
    if (dates.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Date',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dates.length,
            itemBuilder: (context, index) {
              final date = dates[index];
              final isSelected = selectedDateIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDateIndex = index;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF6366F1)
                        : Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF6366F1)
                          : Colors.grey[800]!,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        date['date'] ?? '',
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[400],
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        date['day'] ?? '',
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBookButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _showEventBookingSheet(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6366F1),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Book Tickets',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showEventBookingSheet(BuildContext context) {
    int ticketCount = 2;
    String ticketType = 'General Entry';
    final int pricePerTicket = (widget.eventData['basePrice'] is num)
        ? (widget.eventData['basePrice'] as num).toInt()
        : 1499;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          final int multiplier = ticketType == 'VIP Access' ? 2 : 1;
          final int total = ticketCount * pricePerTicket * multiplier;

          return Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Color(0xFF13131A),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
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
                  widget.eventData['title'] ?? 'Event Booking',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.eventData['venue'] ?? '',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                ),
                const SizedBox(height: 20),

                // Pass Type
                const Text(
                  'Select Pass Type',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: ['General Entry', 'VIP Access'].map((type) {
                    final isSel = ticketType == type;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ChoiceChip(
                        label: Text(type),
                        selected: isSel,
                        selectedColor: const Color(0xFF6366F1),
                        backgroundColor: const Color(0xFF22222E),
                        labelStyle: TextStyle(
                          color: isSel ? Colors.white : Colors.grey.shade400,
                        ),
                        onSelected: (val) {
                          if (val) setSheetState(() => ticketType = type);
                        },
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                // Quantity selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Number of Passes',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: Colors.white70),
                          onPressed: ticketCount > 1
                              ? () => setSheetState(() => ticketCount--)
                              : null,
                        ),
                        Text(
                          '$ticketCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, color: Colors.white70),
                          onPressed: ticketCount < 10
                              ? () => setSheetState(() => ticketCount++)
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),

                const Divider(color: Color(0xFF262636)),
                const SizedBox(height: 12),

                // Total and Pay
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total Amount', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text(
                          '₹$total',
                          style: const TextStyle(
                            color: Color(0xFF10B981),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        final refCode = 'EVT-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: const Color(0xFF10B981),
                            content: Text(
                              '🎉 $ticketCount passes confirmed! Booking Ref: $refCode',
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Confirm Booking',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}