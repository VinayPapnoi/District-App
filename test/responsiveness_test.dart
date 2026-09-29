import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:brl_task_4/models/movie_model.dart';
import 'package:brl_task_4/models/event_model.dart';
import 'package:brl_task_4/models/dining_model.dart';
import 'package:brl_task_4/models/booking_model.dart';
import 'package:brl_task_4/providers/auth_provider.dart';
import 'package:brl_task_4/providers/content_provider.dart';
import 'package:brl_task_4/screens/splash_screen.dart';
import 'package:brl_task_4/screens/login_screen.dart';
import 'package:brl_task_4/screens/home_screen.dart';
import 'package:brl_task_4/screens/otp_verification_screen.dart';
import 'package:brl_task_4/screens/movies/movie_detail_screen.dart';
import 'package:brl_task_4/screens/events/event_detail_screen.dart';
import 'package:brl_task_4/screens/dining/dining_detail_screen.dart';
import 'package:brl_task_4/screens/profile/saved_plans_screen.dart';
import 'package:brl_task_4/screens/profile/my_bookings_screen.dart';
import 'package:brl_task_4/widgets/seat_selection_bottom_sheet.dart';

final List<Size> testScreenSizes = [
  const Size(320, 568),  // Compact (iPhone SE / Galaxy Fold outer)
  const Size(390, 844),  // Modern standard phone
  const Size(412, 915),  // Modern tall phone
  const Size(768, 1024), // Tablet portrait
  const Size(700, 400),  // Short / Landscape
];

class FakeAuthNotifier extends StateNotifier<AuthState> implements AuthNotifier {
  FakeAuthNotifier() : super(AuthState(countryCode: '+91', phoneNumber: '9876543210'));

  @override
  void updatePhoneNumber(String number) {
    state = state.copyWith(phoneNumber: number);
  }

  @override
  Future<void> submitPhoneNumber() async {}

  @override
  Future<bool> verifyOTP(String otp) async => true;

  @override
  Future<void> resendOTP() async {}

  @override
  Future<void> signOut() async {}

  @override
  Future<void> logout() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Widget wrapWithApp(Widget child) {
  return ProviderScope(
    overrides: [
      authProvider.overrideWith((ref) => FakeAuthNotifier()),
      moviesStreamProvider.overrideWith((ref) => Stream<List<Movie>>.value([])),
      eventsStreamProvider.overrideWith((ref) => Stream<List<EventModel>>.value([])),
      restaurantsStreamProvider.overrideWith((ref) => Stream<List<Restaurant>>.value([])),
      userBookingsProvider.overrideWith((ref) => Stream<List<Booking>>.value([])),
      movieBookedSeatsProvider.overrideWith((ref, id) => Stream<Map<String, List<String>>>.value({})),
    ],
    child: MaterialApp(
      routes: {
        '/login': (context) => const Scaffold(),
        '/otp': (context) => const Scaffold(),
        '/home': (context) => const Scaffold(),
      },
      home: child,
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
  });

  for (final size in testScreenSizes) {
    final label = '${size.width.toInt()}x${size.height.toInt()}';

    group('Responsiveness at $label -', () {
      testWidgets('SplashScreen renders without overflow', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(wrapWithApp(const SplashScreen()));
        await tester.pump(const Duration(seconds: 4));

        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      });

      testWidgets('LoginScreen renders without overflow', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(wrapWithApp(const LoginScreen()));
        await tester.pump(const Duration(milliseconds: 100));

        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      });

      testWidgets('OtpVerificationScreen renders without overflow', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(wrapWithApp(const OTPVerificationScreen()));
        await tester.pump(const Duration(milliseconds: 100));

        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      });

      testWidgets('SavedPlansScreen renders without overflow', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(wrapWithApp(const SavedPlansScreen()));
        await tester.pump(const Duration(milliseconds: 100));

        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      });

      testWidgets('MyBookingsScreen renders without overflow', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(wrapWithApp(const MyBookingsScreen()));
        await tester.pump(const Duration(milliseconds: 100));

        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      });

      testWidgets('MovieDetailScreen renders without overflow', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final dummyMovie = {
          'id': 'm1',
          'title': 'Dune: Part Two',
          'genres': ['Action', 'Sci-Fi'],
          'duration': '2h 46m',
          'rating': 8.8,
          'bannerUrl': '',
          'synopsis': 'Paul Atreides unites with Chani and the Fremen while seeking revenge.',
          'director': 'Denis Villeneuve',
          'cast': [
            {'name': 'Timothée Chalamet', 'image': ''},
            {'name': 'Zendaya', 'image': ''},
          ],
          'certificate': 'UA',
          'language': 'English, Hindi',
          'showtimes': ['10:00 AM', '1:30 PM', '5:00 PM', '8:30 PM'],
          'availableDates': [
            {'date': '15', 'day': 'SAT'},
            {'date': '16', 'day': 'SUN'},
          ],
        };

        await tester.pumpWidget(wrapWithApp(MovieDetailScreen(movieData: dummyMovie)));
        await tester.pump(const Duration(milliseconds: 100));

        expect(tester.takeException(), isNull);
      });

      testWidgets('EventDetailScreen renders without overflow', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final dummyEvent = {
          'id': 'e1',
          'title': 'Coldplay Music of the Spheres Tour 2026',
          'dateTime': 'Nov 15, 2026 • 7:00 PM',
          'venue': 'DY Patil Stadium, Navi Mumbai',
          'language': 'English',
          'categories': ['Music', 'Concert', 'Live'],
          'basePrice': 2500,
          'availableDates': [
            {'date': '15', 'day': 'SAT'},
            {'date': '16', 'day': 'SUN'},
          ],
        };

        await tester.pumpWidget(wrapWithApp(EventDetailScreen(eventData: dummyEvent)));
        await tester.pump(const Duration(milliseconds: 100));

        expect(tester.takeException(), isNull);
      });

      testWidgets('DiningDetailScreen renders without overflow', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final dummyRestaurant = {
          'id': 'r1',
          'name': 'The Royal Saffron Fine Dining',
          'cuisine': 'North Indian, Mughlai',
          'location': 'Connaught Place, Central',
          'rating': 4.7,
          'totalRatings': 340,
          'priceForTwo': '₹2,500',
          'timings': '12:00 PM - 11:30 PM',
          'distance': '2.4 km',
        };

        await tester.pumpWidget(wrapWithApp(DiningDetailScreen(restaurantData: dummyRestaurant)));
        await tester.pump(const Duration(milliseconds: 100));

        expect(tester.takeException(), isNull);
      });

      testWidgets('SeatSelectionBottomSheet renders without overflow', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        const movie = Movie(
          id: 'm1',
          title: 'Oppenheimer IMAX',
          bannerUrl: '',
          certificate: 'A',
          language: 'English',
          duration: '3h 0m',
          releaseDate: '2023',
          genres: ['Biography', 'Drama'],
          synopsis: 'The story of J. Robert Oppenheimer.',
          cast: [],
          availableDates: [],
          offers: [],
          basePrice: 350,
        );

        await tester.pumpWidget(wrapWithApp(
          const Scaffold(
            body: SeatSelectionBottomSheet(
              movie: movie,
            ),
          ),
        ));
        await tester.pump(const Duration(milliseconds: 100));

        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      });

      testWidgets('HomeScreen renders without overflow', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(wrapWithApp(const HomeScreen()));
        await tester.pump(const Duration(milliseconds: 100));

        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      });
    });
  }
}
