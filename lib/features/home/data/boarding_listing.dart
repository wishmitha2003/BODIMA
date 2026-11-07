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
  });

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
}

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
  ),
];
