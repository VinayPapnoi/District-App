import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/movie_model.dart';
import '../models/booking_model.dart';
import '../providers/auth_provider.dart';
import '../providers/content_provider.dart';

class SeatSelectionBottomSheet extends ConsumerStatefulWidget {
  final Movie movie;

  const SeatSelectionBottomSheet({
    Key? key,
    required this.movie,
  }) : super(key: key);

  @override
  ConsumerState<SeatSelectionBottomSheet> createState() =>
      _SeatSelectionBottomSheetState();
}

class _SeatSelectionBottomSheetState
    extends ConsumerState<SeatSelectionBottomSheet> {
  String _selectedShowtime = '4:45 PM';
  final Set<String> _selectedSeats = {'D4', 'D5'};

  // Sample reserved seats
  final Set<String> _reservedSeats = {
    'A2',
    'A3',
    'C4',
    'C5',
    'E1',
    'E2',
    'F7',
    'F8'
  };

  final List<String> _showtimes = [
    '1:30 PM',
    '4:45 PM',
    '8:00 PM',
    '10:30 PM',
  ];

  final List<String> _rows = ['A', 'B', 'C', 'D', 'E', 'F'];
  final int _cols = 8;

  @override
  Widget build(BuildContext context) {
    final seatPrice = widget.movie.basePrice;
    final totalPrice = _selectedSeats.length * seatPrice;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Color(0xFF13131A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade700,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.movie.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${widget.movie.certificate} • ${widget.movie.language} • ₹$seatPrice/ticket',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const Divider(color: Color(0xFF262636)),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 8),

                  // Showtime Selector
                  SizedBox(
                    height: 38,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _showtimes.length,
                      itemBuilder: (context, index) {
                        final time = _showtimes[index];
                        final isSelected = _selectedShowtime == time;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(
                              time,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey.shade400,
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: const Color(0xFF6366F1),
                            backgroundColor: const Color(0xFF1E1E2A),
                            onSelected: (selected) {
                              if (selected) {
                                setState(() => _selectedShowtime = time);
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Cinema Screen Indicator
                  Column(
                    children: [
                      Container(
                        height: 4,
                        width: MediaQuery.of(context).size.width * 0.7,
                        decoration: BoxDecoration(
                          color: const Color(0xFF6366F1),
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6366F1).withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'ALL EYES THIS WAY (SCREEN)',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 10,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Seat Grid
                  _buildSeatGrid(),

                  const SizedBox(height: 24),

                  // Legend
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLegendItem('Available', const Color(0xFF262636)),
                      const SizedBox(width: 16),
                      _buildLegendItem('Selected', const Color(0xFF6366F1)),
                      const SizedBox(width: 16),
                      _buildLegendItem('Reserved', const Color(0xFF4B4B5A)),
                    ],
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Bottom summary bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF1A1A24),
              border: Border(top: BorderSide(color: Color(0xFF262636))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _selectedSeats.isEmpty
                            ? 'Select seats'
                            : 'Seats: ${_selectedSeats.join(', ')}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '₹$totalPrice (${_selectedSeats.length} tickets)',
                        style: const TextStyle(
                          color: Color(0xFF10B981),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _selectedSeats.isEmpty ? null : _handleBooking,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF4444),
                      disabledBackgroundColor: Colors.grey.shade800,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                    ),
                    child: const Text(
                      'Confirm & Pay',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
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

  Widget _buildSeatGrid() {
    return Column(
      children: _rows.map((row) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20,
                child: Text(
                  row,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...List.generate(_cols, (colIndex) {
                final seatId = '$row${colIndex + 1}';
                final isReserved = _reservedSeats.contains(seatId);
                final isSelected = _selectedSeats.contains(seatId);

                // Add aisle gap in middle
                final isAisle = colIndex == 3;

                return Padding(
                  padding: EdgeInsets.only(
                    left: 4,
                    right: isAisle ? 16 : 4,
                  ),
                  child: GestureDetector(
                    onTap: isReserved
                        ? null
                        : () {
                            setState(() {
                              if (isSelected) {
                                _selectedSeats.remove(seatId);
                              } else {
                                _selectedSeats.add(seatId);
                              }
                            });
                          },
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isReserved
                            ? const Color(0xFF383848)
                            : (isSelected
                                ? const Color(0xFF6366F1)
                                : const Color(0xFF22222E)),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF818CF8)
                              : (isReserved
                                  ? Colors.transparent
                                  : Colors.grey.shade800),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${colIndex + 1}',
                          style: TextStyle(
                            color: isReserved
                                ? Colors.grey.shade600
                                : (isSelected
                                    ? Colors.white
                                    : Colors.grey.shade400),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
        ),
      ],
    );
  }

  void _handleBooking() async {
    final userId = ref.read(authProvider.select((s) => s.userId)) ?? 'guest_user';
    final refCode = 'DST-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    final booking = Booking(
      id: 'booking_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      itemTitle: widget.movie.title,
      itemType: 'movie',
      imageUrl: widget.movie.bannerUrl,
      date: 'Today',
      time: _selectedShowtime,
      details: 'Seats: ${_selectedSeats.join(', ')}',
      totalPrice: _selectedSeats.length * widget.movie.basePrice,
      bookingReference: refCode,
      createdAt: DateTime.now(),
    );

    // Save to Firestore repository
    await ref.read(contentRepositoryProvider).saveBooking(booking);

    if (!mounted) return;
    Navigator.pop(context); // close seat selection

    // Show E-Ticket Dialog
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xFF181824),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 56),
              const SizedBox(height: 12),
              const Text(
                'Booking Confirmed!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Ref: $refCode',
                style: const TextStyle(
                  color: Color(0xFF6366F1),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF101018),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildTicketRow('Movie', widget.movie.title),
                    const SizedBox(height: 6),
                    _buildTicketRow('Showtime', 'Today, $_selectedShowtime'),
                    const SizedBox(height: 6),
                    _buildTicketRow('Seats', _selectedSeats.join(', ')),
                    const SizedBox(height: 6),
                    _buildTicketRow('Total Paid', '₹${booking.totalPrice}'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTicketRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
