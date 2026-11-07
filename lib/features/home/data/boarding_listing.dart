class BoardingListing {
  const BoardingListing({
    required this.name,
    required this.location,
    required this.price,
    required this.imageColor,
    this.distance,
    this.isVerified = false,
    this.priceValue = 15000,
    this.roomType = 'Single Room',
    this.genderPreference = 'Any',
    this.facilities = const [],
    this.availability = 'Available Now',
    this.address = '',
    this.createdAt = 0,
    this.campus = 'SLIIT (Malabe)',
    this.walkTime = '5 min walk',
    this.rating = 4.8,
    this.reviewCount = 24,
    this.description =
        'Comfortable, safe student accommodation located conveniently near campus with study desk and high-speed Wi-Fi.',
    this.ownerName = 'Mr. Somapala Perera',
    this.ownerPhone = '+94 77 123 4567',
    this.ownerRating = 4.9,
    bool? isAvailable,
    String? gender,
    List<String>? amenities,
  })  : _isAvailableOverride = isAvailable,
        _genderOverride = gender,
        _amenitiesOverride = amenities;

  final String name;
  final String location;
  final String price;
  final String? distance;
  final int imageColor;
  final bool isVerified;
  final int priceValue;
  final String roomType;
  final String genderPreference;
  final List<String> facilities;
  final String availability;
  final String address;
  final int createdAt;
  final String campus;
  final String walkTime;
  final double rating;
  final int reviewCount;
  final String description;
  final String ownerName;
  final String ownerPhone;
  final double ownerRating;

  final bool? _isAvailableOverride;
  final String? _genderOverride;
  final List<String>? _amenitiesOverride;

  bool get isAvailable =>
      _isAvailableOverride ?? (availability == 'Available Now');
  String get gender => _genderOverride ?? genderPreference;
  List<String> get amenities => _amenitiesOverride ?? facilities;
}

const sampleBoardingListings = sampleBoardings;

const popularCampuses = [
  'All Campuses',
  'SLIIT (Malabe)',
  'UoM (Moratuwa)',
  'NSBM (Homagama)',
  'USJ (Nugegoda)',
  'UOC (Colombo)',
  'Kelaniya Uni',
];

const sampleBoardings = [
  BoardingListing(
    name: 'Cozy Student Room',
    location: 'Malabe',
    price: 'Rs. 15,000',
    distance: '1.2 km from campus',
    imageColor: 0xFFDCEFEA,
    isVerified: true,
    priceValue: 15000,
    roomType: 'Single Room',
    genderPreference: 'Any',
    facilities: ['Wi-Fi', 'Attached Bathroom', 'Furnished'],
    address: 'Near SLIIT Malabe Campus',
    createdAt: 3,
    campus: 'SLIIT (Malabe)',
    walkTime: '8 min walk',
  ),
  BoardingListing(
    name: 'Modern Shared Stay',
    location: 'Thalahena',
    price: 'Rs. 18,000',
    distance: '2.4 km from campus',
    imageColor: 0xFFE9E2D6,
    isVerified: true,
    priceValue: 18000,
    roomType: 'Shared Room',
    genderPreference: 'Female',
    facilities: ['Wi-Fi', 'Kitchen', 'Parking'],
    availability: 'Available Soon',
    address: 'Thalahena Main Road',
    createdAt: 2,
    campus: 'SLIIT (Malabe)',
    walkTime: '15 min walk',
  ),
  BoardingListing(
    name: 'Comfortable Boarding House',
    location: 'Kaduwela',
    price: 'Rs. 20,000',
    imageColor: 0xFFDDE7F5,
    isVerified: true,
    priceValue: 20000,
    roomType: 'Annex',
    genderPreference: 'Male',
    facilities: ['AC', 'Parking', 'Furnished'],
    address: 'Kaduwela Town',
    createdAt: 1,
    campus: 'SLIIT (Malabe)',
    walkTime: 'Short bus ride',
  ),
  BoardingListing(
    name: 'Green View Annex',
    location: 'Battaramulla',
    price: 'Rs. 25,000',
    distance: '4.8 km from campus',
    imageColor: 0xFFE4EEDB,
    priceValue: 25000,
    roomType: 'Annex',
    genderPreference: 'Any',
    facilities: ['Wi-Fi', 'Attached Bathroom', 'AC', 'Furnished'],
    address: 'Battaramulla Junction',
    createdAt: 4,
    campus: 'SLIIT (Malabe)',
    walkTime: 'Direct bus line',
  ),
  BoardingListing(
    name: 'Athurugiriya Family Home',
    location: 'Athurugiriya',
    price: 'Rs. 30,000',
    distance: '7.2 km from campus',
    imageColor: 0xFFF2E4D5,
    priceValue: 30000,
    roomType: 'Full House',
    genderPreference: 'Any',
    facilities: ['Kitchen', 'Parking', 'Furnished'],
    address: 'Athurugiriya Road',
    createdAt: 5,
    campus: 'SLIIT (Malabe)',
    walkTime: 'Highway access',
  ),
  // Boardings for other major Sri Lankan universities
  BoardingListing(
    name: 'UoM Scholar Annex',
    location: 'Katubedda',
    price: 'Rs. 14,000',
    distance: '400m from UoM Gate',
    imageColor: 0xFFD8EDE8,
    isVerified: true,
    priceValue: 14000,
    roomType: 'Single Room',
    genderPreference: 'Male',
    facilities: ['Wi-Fi', 'Study area', 'Furnished'],
    address: 'Molpe Road, Katubedda',
    createdAt: 6,
    campus: 'UoM (Moratuwa)',
    walkTime: '4 min walk to UoM',
  ),
  BoardingListing(
    name: 'NSBM Green View Studio',
    location: 'Pitipana',
    price: 'Rs. 16,500',
    distance: '800m from NSBM Gate',
    imageColor: 0xFFEBE6D8,
    isVerified: true,
    priceValue: 16500,
    roomType: 'Single Room',
    genderPreference: 'Female',
    facilities: ['Wi-Fi', 'Attached Bathroom', 'Kitchen'],
    address: 'Pitipana North, Homagama',
    createdAt: 7,
    campus: 'NSBM (Homagama)',
    walkTime: '7 min walk to NSBM',
  ),
  BoardingListing(
    name: 'Wijerama Student Residence',
    location: 'Gangodawila',
    price: 'Rs. 15,000',
    distance: '500m from USJ Campus',
    imageColor: 0xFFE0EBF5,
    isVerified: true,
    priceValue: 15000,
    roomType: 'Shared Room',
    genderPreference: 'Female',
    facilities: ['Wi-Fi', 'Furnished', 'Water supply'],
    address: 'Wijerama Junction, Nugegoda',
    createdAt: 8,
    campus: 'USJ (Nugegoda)',
    walkTime: '5 min walk to USJ',
  ),
  BoardingListing(
    name: 'Reid Avenue City Stay',
    location: 'Colombo 07',
    price: 'Rs. 22,000',
    distance: '600m from Colombo Science Faculty',
    imageColor: 0xFFEFE4D8,
    isVerified: true,
    priceValue: 22000,
    roomType: 'Single Room',
    genderPreference: 'Any',
    facilities: ['Wi-Fi', 'AC', 'Attached Bathroom'],
    address: 'Thimbirigasyaya Road, Colombo',
    createdAt: 9,
    campus: 'UOC (Colombo)',
    walkTime: '6 min walk to UOC',
  ),
  BoardingListing(
    name: 'Kelaniya Campus Haven',
    location: 'Dalugama',
    price: 'Rs. 13,500',
    distance: '350m from Kelaniya Main Gate',
    imageColor: 0xFFE1EEDB,
    isVerified: true,
    priceValue: 13500,
    roomType: 'Single Room',
    genderPreference: 'Male',
    facilities: ['Wi-Fi', 'Furnished', 'Study area'],
    address: 'Kandy Road, Dalugama, Kelaniya',
    createdAt: 10,
    campus: 'Kelaniya Uni',
    walkTime: '3 min walk to UOK',
  ),
];
