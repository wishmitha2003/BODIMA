class BoardingListing {
  const BoardingListing({
    required this.name,
    required this.location,
    required this.price,
    required this.imageColor,
    this.distance,
    this.isVerified = false,
  });

  final String name;
  final String location;
  final String price;
  final String? distance;
  final int imageColor;
  final bool isVerified;
}

const sampleBoardings = [
  BoardingListing(
    name: 'Cozy Student Room',
    location: 'Malabe',
    price: 'Rs. 15,000',
    distance: '1.2 km from campus',
    imageColor: 0xFFDCEFEA,
    isVerified: true,
  ),
  BoardingListing(
    name: 'Modern Shared Stay',
    location: 'Thalahena',
    price: 'Rs. 18,000',
    distance: '2.4 km from campus',
    imageColor: 0xFFE9E2D6,
    isVerified: true,
  ),
  BoardingListing(
    name: 'Comfortable Boarding House',
    location: 'Kaduwela',
    price: 'Rs. 20,000',
    imageColor: 0xFFDDE7F5,
    isVerified: true,
  ),
];
