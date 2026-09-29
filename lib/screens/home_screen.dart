import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';
import 'profile_screen.dart';
import '../providers/content_provider.dart';
import '../utils/colors.dart';
import 'sub_screens/activities_page.dart';
import 'sub_screens/dining_page.dart';
import 'sub_screens/for_you_page.dart';
import 'movies/movie_page.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedTabIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  String _city = "Loading...";
  String _country = "";

  late final AnimationController _headerAnimController;
  late final Animation<double> _headerAnimation;
  bool _isHeaderVisible = true;

  final List<String> _tabs = [
    'FOR YOU',
    'DINING',
    'MOVIES',
    'ACTIVITIES',
  ];

  final List<Color> _tabColors = [
    AppColors.forYouPurple,
    AppColors.diningRed,
    AppColors.moviesBlue,
    AppColors.activitiesOrange,
  ];

  final List<Widget> _pages = [
    ForYouPage(),
    DiningPage(),
    MoviesPage(),
    ActivitiesPage(),
  ];

  final List<String> _searchHints = [
    'Search for events, movies, restaurants...',
    'Search for restaurants, cuisines, dishes...',
    'Search for movies, showtimes, theaters...',
    'Search for activities, experiences, fun...',
  ];

  @override
  void initState() {
    super.initState();
    _headerAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      value: 1.0,
    );
    _headerAnimation = CurvedAnimation(
      parent: _headerAnimController,
      curve: Curves.easeInOutCubic,
    );
    _getUserLocation();
  }

  @override
  void dispose() {
    _headerAnimController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _getUserLocation() async {
    try {
      loc.Location location = loc.Location();

      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          setState(() {
            _city = "Location Off";
            _country = "";
          });
          return;
        }
      }

      loc.PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == loc.PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != loc.PermissionStatus.granted) {
          setState(() {
            _city = "Unknown";
            _country = "";
          });
          return;
        }
      }

      // ✅ Get current location with timeout to avoid blocking main thread
      loc.LocationData myLocation = await location.getLocation().timeout(
        const Duration(seconds: 4),
        onTimeout: () => throw Exception('Location request timed out'),
      );
      double lat = myLocation.latitude ?? 28.5700;
      double lon = myLocation.longitude ?? 77.3200;

      // ✅ Get full placemark info
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon).timeout(
        const Duration(seconds: 4),
        onTimeout: () => [],
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        // Get clean city and area info
        String cityName =
            place.locality ?? place.subAdministrativeArea ?? "Delhi NCR";

        // Combine plus code / name and administrative area
        String areaDetails = [
          if (place.name != null && place.name!.isNotEmpty)
            place.name,
          if (place.subAdministrativeArea != null &&
              place.subAdministrativeArea!.isNotEmpty)
            place.subAdministrativeArea,
        ].join(', ');

        if (mounted) {
          setState(() {
            _city = cityName;
            _country = areaDetails.isNotEmpty ? areaDetails : 'Delhi NCR';
          });
        }
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _city = "Delhi NCR";
          _country = "Connaught Place";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(color: const Color(0xFF000000)),

          // Top gradient fades with header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _headerAnimation,
              child: Container(
                height: screenHeight * 0.25,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topCenter,
                    radius: 1.2,
                    colors: [
                      _tabColors[_selectedTabIndex].withValues(alpha: 0.4),
                      _tabColors[_selectedTabIndex].withValues(alpha: 0.2),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is UserScrollNotification) {
                  if (notification.direction == ScrollDirection.reverse) {
                    // Scrolling down into content -> hide header
                    if (notification.metrics.pixels > 20 &&
                        _isHeaderVisible &&
                        _searchController.text.isEmpty) {
                      _isHeaderVisible = false;
                      _headerAnimController.reverse();
                    }
                  } else if (notification.direction == ScrollDirection.forward) {
                    // Scrolling back up -> reveal header
                    if (!_isHeaderVisible) {
                      _isHeaderVisible = true;
                      _headerAnimController.forward();
                    }
                  }
                } else if (notification is ScrollUpdateNotification) {
                  // Reveal header if user reaches near or at top
                  if (notification.metrics.pixels <= 10 && !_isHeaderVisible) {
                    _isHeaderVisible = true;
                    _headerAnimController.forward();
                  }
                }
                return false;
              },
              child: Column(
                children: [
                  // Animated collapsible top navigation bar
                  SizeTransition(
                    sizeFactor: _headerAnimation,
                    axisAlignment: -1.0,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, -1.0),
                        end: Offset.zero,
                      ).animate(_headerAnimation),
                      child: FadeTransition(
                        opacity: _headerAnimation,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Top location bar
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      _city,
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  const Icon(
                                                    Icons.keyboard_arrow_down,
                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                _country,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Profile icon
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const ProfileScreen(),
                                        ),
                                      );
                                    },
                                    child: CircleAvatar(
                                      radius: 18,
                                      backgroundColor: Colors.grey.shade800,
                                      child: const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Search bar
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2A2A2A),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextField(
                                  controller: _searchController,
                                  style: const TextStyle(color: Colors.white),
                                  onChanged: (val) {
                                    ref.read(searchQueryProvider.notifier).state = val;
                                    if (val.isNotEmpty && !_isHeaderVisible) {
                                      _isHeaderVisible = true;
                                      _headerAnimController.forward();
                                    }
                                    setState(() {});
                                  },
                                  decoration: InputDecoration(
                                    hintText: _searchHints[_selectedTabIndex],
                                    hintStyle: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 14,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Colors.grey.shade500,
                                    ),
                                    suffixIcon: _searchController.text.isNotEmpty
                                        ? IconButton(
                                            icon: const Icon(
                                              Icons.clear,
                                              color: Colors.grey,
                                              size: 18,
                                            ),
                                            onPressed: () {
                                              _searchController.clear();
                                              ref.read(searchQueryProvider.notifier).state = '';
                                              _isHeaderVisible = true;
                                              _headerAnimController.forward();
                                              setState(() {});
                                            },
                                          )
                                        : null,
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Tabs row
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: List.generate(_tabs.length, (index) {
                                  final isSelected = _selectedTabIndex == index;
                                  final List<IconData> icons = [
                                    Icons.auto_awesome,
                                    Icons.restaurant,
                                    Icons.movie_creation_outlined,
                                    Icons.local_activity_outlined,
                                  ];

                                  return Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedTabIndex = index;
                                          _isHeaderVisible = true;
                                          _headerAnimController.forward();
                                        });
                                      },
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              icons[index],
                                              size: (screenWidth * 0.065).clamp(20.0, 28.0),
                                              color: isSelected
                                                  ? _tabColors[index]
                                                  : Colors.grey,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              _tabs[index],
                                              style: TextStyle(
                                                color: isSelected
                                                    ? _tabColors[index]
                                                    : Colors.grey.shade400,
                                                fontSize: (screenWidth * 0.028).clamp(10.0, 13.0),
                                                fontWeight: FontWeight.w600,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 4),
                                            Container(
                                              height: 2,
                                              width: (screenWidth * 0.08).clamp(22.0, 36.0),
                                              color: isSelected
                                                  ? _tabColors[index]
                                                  : Colors.transparent,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Content view
                  Expanded(
                    child: IndexedStack(
                      index: _selectedTabIndex,
                      children: _pages,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
