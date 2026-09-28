import '../models/movie_model.dart';
import '../models/event_model.dart';
import '../models/dining_model.dart';

class SeedData {
  static final List<Movie> initialMovies = [
    const Movie(
      id: 'movie_001',
      title: 'Kantara: Chapter 1',
      bannerUrl: 'assets/movieimg/movies/kantara.jpeg',
      certificate: 'UA/16+',
      language: 'Kannada, Hindi',
      duration: '2 hr 49 min',
      releaseDate: '14 March 2025',
      genres: ['Adventure', 'Drama', 'Thriller'],
      synopsis:
          'Exploring the origins of Kand-bhatta Shiva during the Kadamba dynasty era, delving into the untamed wilderness and forgotten lore surrounding his past.',
      cast: [
        CastMember(name: 'Rishab Shetty', image: 'assets/movieimg/male.jpg'),
        CastMember(name: 'Sapthami Gowda', image: 'assets/movieimg/female.jpg'),
      ],
      availableDates: [
        {'date': '28', 'day': 'Mon'},
        {'date': '29', 'day': 'Tue'},
        {'date': '30', 'day': 'Wed'},
        {'date': '31', 'day': 'Thu'},
      ],
      offers: ['Flat ₹75 cashback on Paytm Movie Tickets'],
      rating: 8.9,
      basePrice: 280,
    ),
    const Movie(
      id: 'movie_002',
      title: 'Deadpool & Wolverine',
      bannerUrl: 'assets/movieimg/movies/deadpool.jpg',
      certificate: 'A',
      language: 'English, Hindi',
      duration: '2 hr 20 min',
      releaseDate: 'July 2024',
      genres: ['Action', 'Comedy', 'Sci-Fi'],
      synopsis:
          'Deadpool teams up with Wolverine for a chaotic multiverse adventure filled with humor and fourth-wall-breaking madness.',
      cast: [
        CastMember(name: 'Ryan Reynolds', image: 'assets/movieimg/male.jpg'),
        CastMember(name: 'Hugh Jackman', image: 'assets/movieimg/male.jpg'),
      ],
      availableDates: [
        {'date': '28', 'day': 'Mon'},
        {'date': '29', 'day': 'Tue'},
        {'date': '30', 'day': 'Wed'},
        {'date': '31', 'day': 'Thu'},
      ],
      offers: ['Get 10% off with SBI Credit Card'],
      rating: 8.2,
      basePrice: 320,
    ),
    const Movie(
      id: 'movie_003',
      title: 'Inside Out 2',
      bannerUrl: 'assets/movieimg/movies/inside.jpeg',
      certificate: 'U',
      language: 'English, Hindi',
      duration: '1 hr 50 min',
      releaseDate: 'June 2024',
      genres: ['Animation', 'Family', 'Comedy'],
      synopsis:
          'Riley experiences new emotions as she navigates the challenges of teenage life, with Joy and the gang back in action.',
      cast: [
        CastMember(name: 'Amy Poehler', image: 'assets/movieimg/female.jpg'),
        CastMember(name: 'Maya Hawke', image: 'assets/movieimg/female.jpg'),
      ],
      availableDates: [
        {'date': '28', 'day': 'Mon'},
        {'date': '29', 'day': 'Tue'},
        {'date': '30', 'day': 'Wed'},
        {'date': '31', 'day': 'Thu'},
      ],
      offers: ['Buy 2 tickets and get popcorn free!'],
      rating: 8.7,
      basePrice: 240,
    ),
    const Movie(
      id: 'movie_004',
      title: 'Oppenheimer',
      bannerUrl: 'assets/movieimg/movies/oppenheimer.jpg',
      certificate: 'UA/16+',
      language: 'English, Hindi',
      duration: '3 hr',
      releaseDate: 'July 2023',
      genres: ['Biography', 'Drama', 'History'],
      synopsis:
          'The story of J. Robert Oppenheimer, the physicist who led the Manhattan Project and the development of the atomic bomb.',
      cast: [
        CastMember(name: 'Cillian Murphy', image: 'assets/movieimg/male.jpg'),
        CastMember(name: 'Emily Blunt', image: 'assets/movieimg/female.jpg'),
      ],
      availableDates: [
        {'date': '28', 'day': 'Mon'},
        {'date': '29', 'day': 'Tue'},
        {'date': '30', 'day': 'Wed'},
        {'date': '31', 'day': 'Thu'},
      ],
      offers: ['50% off on weekday morning shows!'],
      rating: 9.1,
      basePrice: 300,
    ),
    const Movie(
      id: 'movie_005',
      title: 'Pushpa 2: The Rule',
      bannerUrl: 'assets/movieimg/movies/pushpa.jpg',
      certificate: 'UA',
      language: 'Telugu, Hindi',
      duration: '2 hr 45 min',
      releaseDate: 'Dec 2024',
      genres: ['Action', 'Thriller'],
      synopsis:
          'Pushpa Raj expands his syndicate empire while facing relentless opposition from Bhanwar Singh Shekhawat.',
      cast: [
        CastMember(name: 'Allu Arjun', image: 'assets/movieimg/male.jpg'),
        CastMember(name: 'Rashmika Mandanna', image: 'assets/movieimg/female.jpg'),
      ],
      availableDates: [
        {'date': '28', 'day': 'Mon'},
        {'date': '29', 'day': 'Tue'},
        {'date': '30', 'day': 'Wed'},
      ],
      offers: ['Special Premiere Discount ₹100 OFF'],
      rating: 8.4,
      basePrice: 260,
    ),
  ];

  static final List<EventModel> initialEvents = [
    const EventModel(
      id: 'event_001',
      title: 'ISL 2025: Lionel Messi Exhibition Match',
      imageUrl: 'assets/images/messi_event.jpg',
      dateTime: 'Mon, 18 Dec, 1:30 PM',
      venue: 'Jawaharlal Nehru Stadium, Delhi',
      language: 'English, Hindi',
      categories: ['Sports', 'Football', 'Live'],
      description:
          'Experience the magic of football as the legendary Lionel Messi graces Delhi for an unforgettable match. Don\'t miss this once-in-a-lifetime opportunity to witness greatness on the pitch!',
      terms:
          '• Valid government-issued ID required for entry\n• Children above 3 years require a separate ticket\n• Outside food and beverages not allowed\n• Gates open 1 hour before the match',
      availableDates: [
        {'date': '18', 'day': 'Mon'},
        {'date': '19', 'day': 'Tue'},
        {'date': '20', 'day': 'Wed'},
      ],
      offer: 'Pay only 50% to reserve your tickets',
      basePrice: 1499,
    ),
    const EventModel(
      id: 'event_002',
      title: 'Rolling Loud India | Hip-Hop Festival',
      imageUrl: 'assets/images/rolling.jpeg',
      dateTime: 'Sat, 25 Nov, 8:00 PM',
      venue: 'MMRDA Grounds, Mumbai',
      language: 'English, Punjabi',
      categories: ['Music', 'Hip-Hop', 'Festival'],
      description:
          'Rolling Loud makes its grand debut in India! Featuring top international and local hip-hop artists for an electrifying night of live beats.',
      terms:
          '• Age limit: 18+\n• No refunds or exchanges\n• Security check mandatory at entry\n• Festival wristbands must be worn at all times',
      availableDates: [
        {'date': '25', 'day': 'Sat'},
        {'date': '26', 'day': 'Sun'},
      ],
      offer: 'Early bird discount - 30% off',
      basePrice: 2499,
    ),
    const EventModel(
      id: 'event_003',
      title: 'PKL 2025: Grand Finale',
      imageUrl: 'assets/images/PKL.jpeg',
      dateTime: 'Fri, 15 Dec, 7:00 PM',
      venue: 'Thyagaraj Sports Complex, Delhi',
      language: 'Hindi, English',
      categories: ['Sports', 'Kabaddi', 'Live'],
      description:
          'The ultimate showdown in Pro Kabaddi League! Watch the two best teams battle it out for the championship trophy in an electrifying atmosphere.',
      terms:
          '• Valid ID proof required\n• Gates open 2 hours before match\n• Children below 5 years free entry',
      availableDates: [
        {'date': '15', 'day': 'Fri'},
      ],
      offer: 'Buy 2 Get 1 Free',
      basePrice: 799,
    ),
    const EventModel(
      id: 'event_004',
      title: 'Enrique Iglesias Live in Concert',
      imageUrl: 'assets/images/enrique.jpg',
      dateTime: 'Wed, 20 Dec, 6:00 PM',
      venue: 'DLF CyberHub, Gurugram',
      language: 'English, Spanish',
      categories: ['Music', 'Concert', 'International'],
      description:
          'The King of Latin Pop returns to India! Experience an electrifying evening with Enrique Iglesias performing his greatest hits live.',
      terms:
          '• Age limit: 10+\n• Professional cameras not allowed\n• Show duration approximately 2.5 hours',
      availableDates: [
        {'date': '20', 'day': 'Wed'},
        {'date': '21', 'day': 'Thu'},
      ],
      offer: 'Limited VIP seats available',
      basePrice: 3999,
    ),
  ];

  static final List<Restaurant> initialRestaurants = [
    const Restaurant(
      id: 'dining_001',
      name: 'Masala Synergy',
      imageUrl: 'assets/images/masala-synergy.jpeg',
      galleryUrls: [
        'assets/images/masala-synergy.jpeg',
        'assets/images/food.jpg',
      ],
      rating: 4.5,
      totalRatings: 620,
      cuisine: 'North Indian, Continental, Mughlai',
      location: 'Logix Mall, Sector 32, Noida',
      timings: 'Open • 12:00 PM to 11:30 PM',
      distance: '3.5 km',
      priceForTwo: '₹1,200',
      whatsGoodHere: 'Butter Chicken, Dal Makhani, Paneer Tikka, Biryani',
      offers: [
        DiningOffer(
          title: 'FLAT 30% OFF',
          validFrom: 'From 1:45 PM, today',
          details: 'Valid on food bill above ₹1,000',
          buttonText: 'Book now',
        ),
      ],
      menuUpdated: 'Updated 3 days ago',
      description:
          'Masala Synergy offers an exquisite blend of traditional Indian flavors with a modern twist. Authentic spices and fresh ingredients.',
      highlights: ['Live Music', 'Outdoor Seating', 'Pet-Friendly', 'Valet Parking'],
    ),
    const Restaurant(
      id: 'dining_002',
      name: 'Bold Flavours Bistro',
      imageUrl: 'assets/images/bold-flavor.jpg',
      galleryUrls: [
        'assets/images/bold-flavor.jpg',
        'assets/images/food.jpg',
      ],
      rating: 4.3,
      totalRatings: 450,
      cuisine: 'Italian, Mediterranean, Wood-fired',
      location: 'Cyber Hub, Gurugram',
      timings: 'Open • 11:00 AM to 11:00 PM',
      distance: '5.2 km',
      priceForTwo: '₹1,500',
      whatsGoodHere: 'Wood-fired Pizza, Pasta Carbonara, Tiramisu',
      offers: [
        DiningOffer(
          title: 'FLAT 25% OFF',
          validFrom: 'All day',
          details: 'Valid on total food bill',
          buttonText: 'Book now',
        ),
      ],
      menuUpdated: 'Updated 1 week ago',
      description:
          'Experience authentic Italian cuisine in a cozy Mediterranean ambiance with fresh artisanal pizzas and pastas.',
      highlights: ['Romantic Setting', 'Wine Collection', 'Private Dining'],
    ),
    const Restaurant(
      id: 'dining_003',
      name: 'Spice Route',
      imageUrl: 'assets/images/spice-route.jpeg',
      galleryUrls: [
        'assets/images/spice-route.jpeg',
        'assets/images/food.jpg',
      ],
      rating: 4.7,
      totalRatings: 890,
      cuisine: 'South Indian, Coastal Kerala',
      location: 'Connaught Place, New Delhi',
      timings: 'Open • 12:00 PM to 10:30 PM',
      distance: '2.8 km',
      priceForTwo: '₹900',
      whatsGoodHere: 'Appam, Kerala Fish Curry, Ghee Roast Dosa',
      offers: [
        DiningOffer(
          title: 'FLAT 20% OFF',
          validFrom: 'Lunch hours',
          details: 'Valid till 4 PM',
          buttonText: 'Book now',
        ),
      ],
      menuUpdated: 'Updated 2 days ago',
      description:
          'A rich culinary journey through the authentic flavors and spices of Coastal South India.',
      highlights: ['Authentic Recipes', 'Family-Friendly', 'Lunch Buffet'],
    ),
    const Restaurant(
      id: 'dining_004',
      name: 'The Burger Hub & Cafe',
      imageUrl: 'assets/images/burger_hub.jpg',
      galleryUrls: [
        'assets/images/burger_hub.jpg',
        'assets/images/food.jpg',
      ],
      rating: 4.2,
      totalRatings: 320,
      cuisine: 'American, Gourmet Burgers, Shakes',
      location: 'Sector 18, Noida',
      timings: 'Open • 11:00 AM to 11:30 PM',
      distance: '4.1 km',
      priceForTwo: '₹600',
      whatsGoodHere: 'Smash Burger, Loaded Truffle Fries, Thick Shakes',
      offers: [
        DiningOffer(
          title: 'BUY 1 GET 1',
          validFrom: 'Today only',
          details: 'On all gourmet burgers',
          buttonText: 'Order now',
        ),
      ],
      menuUpdated: 'Updated yesterday',
      description:
          'Juicy smash burgers, crispy sides, and handcrafted shakes in a vibrant casual setting.',
      highlights: ['Quick Service', 'Delivery Available', 'Student Discounts'],
    ),
    const Restaurant(
      id: 'dining_005',
      name: 'Sushi Palace & Asian Kitchen',
      imageUrl: 'assets/images/sushi_palace.jpg',
      galleryUrls: [
        'assets/images/sushi_palace.jpg',
        'assets/images/food.jpg',
      ],
      rating: 4.6,
      totalRatings: 540,
      cuisine: 'Japanese, Pan-Asian, Sushi',
      location: 'DLF Mall of India, Noida',
      timings: 'Open • 12:00 PM to 11:00 PM',
      distance: '6.0 km',
      priceForTwo: '₹2,000',
      whatsGoodHere: 'Salmon Nigiri, Dragon Roll, Tonkotsu Ramen',
      offers: [
        DiningOffer(
          title: 'FLAT 15% OFF',
          validFrom: 'All day',
          details: 'On bill above ₹1,500',
          buttonText: 'Reserve table',
        ),
      ],
      menuUpdated: 'Updated 4 days ago',
      description:
          'Fresh premium sushi, sashimi, and authentic ramen crafted by experienced sushi masters.',
      highlights: ['Live Sushi Bar', 'Teppanyaki Counter', 'Private Dining'],
    ),
  ];
}
