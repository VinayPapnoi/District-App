import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../repositories/content_repository.dart';
import 'profile/saved_plans_screen.dart';

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
          onTap: () {},
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
          onTap: () {},
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
          title: 'About us',
          onTap: () {},
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
          icon: Icons.history,
          title: 'My Bookings',
          onTap: () {},
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
}

