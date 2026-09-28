import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../repositories/content_repository.dart';
import 'profile/saved_plans_screen.dart';
import 'profile/my_bookings_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: const Color(0xFF000000),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: authState.isAuthenticated
              ? _buildSignedInView(context, ref)
              : _buildGuestView(context),
        ),
      ),
    );
  }

  /// Guest view (not logged in)
  Widget _buildGuestView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sign up or log in to start booking your plans!',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Login/Sign up',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildListTile(
          icon: Icons.confirmation_number_outlined,
          title: 'My Bookings & Tickets',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MyBookingsScreen()),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildListTile(
          icon: Icons.bookmark_outline,
          title: 'My Saved Plans',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SavedPlansScreen()),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildListTile(
          icon: Icons.system_update,
          title: 'App update available',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Color(0xFF10B981),
                duration: Duration(seconds: 2),
                content: Text('🚀 You are on District v2.20.0 (Latest Production Build)'),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        const Text(
          'Support',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        _buildListTile(
          icon: Icons.help_outline,
          title: 'Frequently asked questions',
          onTap: () => _showFAQModal(context),
        ),
        const SizedBox(height: 24),
        const Text(
          'More',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        _buildListTile(
          icon: Icons.info_outline,
          title: 'About us & Architecture',
          onTap: () => _showAboutModal(context),
        ),
        if (kDebugMode) ...[
          const SizedBox(height: 24),
          const Text(
            'Developer & Cloud Settings',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _buildListTile(
            icon: Icons.cloud_upload_outlined,
            title: 'Seed Cloud Firestore (Admin Only)',
            onTap: () => _handleSeedFirestore(context),
          ),
        ],
        const SizedBox(height: 40),
        Center(
          child: Column(
            children: [
              Image.asset(
                'assets/images/district_logo.png',
                width: 80,
                color: Colors.grey.shade700,
              ),
              const SizedBox(height: 8),
              const Text(
                'v2.20.0',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Signed-in view (placeholder)
  Widget _buildSignedInView(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hello, Explorer!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        _buildListTile(
          icon: Icons.person,
          title: 'My Profile',
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _buildListTile(
          icon: Icons.confirmation_number_outlined,
          title: 'My Bookings & Tickets',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MyBookingsScreen()),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildListTile(
          icon: Icons.bookmark_outline,
          title: 'My Saved Plans',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SavedPlansScreen()),
            );
          },
        ),
        if (kDebugMode) ...[
          const SizedBox(height: 24),
          const Text(
            'Developer & Cloud Settings',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _buildListTile(
            icon: Icons.cloud_upload_outlined,
            title: 'Seed Cloud Firestore (Admin Only)',
            onTap: () => _handleSeedFirestore(context),
          ),
        ],
        const SizedBox(height: 24),
        _buildListTile(
          icon: Icons.logout,
          title: 'Logout',
          onTap: () {
            ref.read(authProvider.notifier).logout();
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
      ],
    );
  }

  void _handleSeedFirestore(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(
        child: Card(
          color: Color(0xFF1E1E28),
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Color(0xFF6366F1)),
                SizedBox(height: 16),
                Text(
                  'Seeding Cloud Firestore...',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final repository = ContentRepository();
      final results = await repository.seedFirestoreDatabase(overwrite: true);
      if (context.mounted) {
        Navigator.pop(context); // close progress dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF10B981),
            content: Text(
              '✅ Successfully seeded ${results['movies']} movies, ${results['events']} events, ${results['restaurants']} restaurants into Cloud Firestore!',
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // close progress dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text('❌ Error seeding Firestore: $e'),
          ),
        );
      }
    }
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Colors.grey.shade400,
                  size: 22,
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey.shade600,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Color(0xFF12121A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
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
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.hub_outlined, color: Color(0xFF818CF8), size: 26),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'District App Architecture',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Production Engineering Showcase',
                          style: TextStyle(color: Color(0xFF818CF8), fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildArchBadge('State Management', 'Riverpod 2.0 (StateNotifier + StreamProvider + granular selectors)'),
              const SizedBox(height: 12),
              _buildArchBadge('Cloud Backend', 'Google Cloud Firestore with real-time snapshot sync & atomic transactions'),
              const SizedBox(height: 12),
              _buildArchBadge('Dual Offline Engine', 'Firestore persistenceEnabled: true + DistrictCachedImage bounded memory decodes'),
              const SizedBox(height: 12),
              _buildArchBadge('Asset Optimization', 'Image footprint compressed from 36.4 MB to 16.3 MB (over 55% reduction)'),
              const SizedBox(height: 12),
              _buildArchBadge('Concurrency Control', 'Atomic Firestore transactions preventing concurrent duplicate seat reservations'),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Close', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArchBadge(String title, String description) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF181824),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF262638)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Color(0xFF6366F1), fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(description, style: TextStyle(color: Colors.grey.shade300, fontSize: 13, height: 1.35)),
        ],
      ),
    );
  }

  void _showFAQModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Color(0xFF12121A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
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
              const SizedBox(height: 18),
              const Text(
                'Frequently Asked Questions',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text('Answers to common queries about District plans', style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
              const SizedBox(height: 18),
              _buildFAQTile(
                'How does real-time cinema seat booking work?',
                'When you pick seats and tap Confirm & Pay, an atomic Firestore transaction locks the seats under the movie document. If another user attempts to book the same seats, the transaction rejects it and turns the seats Red (#DC2626) in real time.',
              ),
              _buildFAQTile(
                'Can I view my tickets while offline?',
                'Yes! District enables local Firestore persistence and caches ticket passes on disk. Previously loaded tickets in "My Bookings" remain accessible even without an internet connection.',
              ),
              _buildFAQTile(
                'How do I save plans for later?',
                'Tap the bookmark icon on any movie, restaurant, event, or activity card. Your saved plans are stored locally via SharedPreferences and can be viewed anytime in "My Saved Plans".',
              ),
              _buildFAQTile(
                'How do table reservations and activities work?',
                'Choose your preferred time slot and party size in the Dining or Activities tab. Your booking is recorded instantly to your account with a unique booking reference code (e.g. DST-ACT-XXXX).',
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Done', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAQTile(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF181824),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF262638)),
      ),
      child: ExpansionTile(
        title: Text(question, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
        iconColor: const Color(0xFF6366F1),
        collapsedIconColor: Colors.grey,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(answer, style: TextStyle(color: Colors.grey.shade300, fontSize: 13, height: 1.4)),
          ),
        ],
      ),
    );
  }
}

