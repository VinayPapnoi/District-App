import 'package:flutter/foundation.dart';
import '../repositories/content_repository.dart';

/// Developer/Admin Utility to seed Firestore on demand.
/// This is NEVER run automatically on app launch.
class FirebaseSeeder {
  static Future<void> runSeedScript({bool overwrite = false}) async {
    debugPrint('🚀 [FirebaseSeeder] Starting Firestore seeding...');
    final repository = ContentRepository();
    try {
      final results = await repository.seedFirestoreDatabase(overwrite: overwrite);
      debugPrint('✅ [FirebaseSeeder] Successfully seeded Firestore:');
      debugPrint('   - Movies: ${results['movies']} documents');
      debugPrint('   - Events: ${results['events']} documents');
      debugPrint('   - Restaurants: ${results['restaurants']} documents');
    } catch (e) {
      debugPrint('❌ [FirebaseSeeder] Seeding error: $e');
      rethrow;
    }
  }
}
