class Listing {
  final String title;
  final String location;
  final List<String> imageUrls;
  final double rating;
  final double pricePerNight;
  final String category;
  final double distanceKm;

  Listing({
    required this.title,
    required this.location,
    required this.imageUrls,
    required this.rating,
    required this.pricePerNight,
    required this.category,
    required this.distanceKm,
  });

  static List<Listing> getMockListings() {
    return [
      // All / Beachfront Listings
      Listing(
        title: 'Sunny Beach House',
        location: 'Goa',
        imageUrls: [
          'assets/images/sunny.jpg',
        ],
        rating: 4.8,
        pricePerNight: 5000,
        category: 'Beachfront',
        distanceKm: 2.5,
      ),
      Listing(
        title: 'Coastal Retreat Villa',
        location: 'Kerala',
        imageUrls: [
          'assets/images/Coastal.jpeg',
        ],
        rating: 4.7,
        pricePerNight: 6000,
        category: 'Beachfront',
        distanceKm: 3.0,
      ),

      // Cabins
      Listing(
        title: 'Cozy Cabin in the Woods',
        location: 'Manali',
        imageUrls: [
          'assets/images/cozy_cabin.jpeg',
        ],
        rating: 4.5,
        pricePerNight: 3500,
        category: 'Cabins',
        distanceKm: 5.0,
      ),
      Listing(
        title: 'Mountain View Cabin',
        location: 'Shimla',
        imageUrls: [
          'assets/images/mountain_cabin.jpeg',
        ],
        rating: 4.6,
        pricePerNight: 4000,
        category: 'Cabins',
        distanceKm: 6.0,
      ),

      // Trending
      Listing(
        title: 'Trending Urban Apartment',
        location: 'Mumbai',
        imageUrls: [
          'assets/images/trending_apartment.jpeg',
        ],
        rating: 4.3,
        pricePerNight: 4500,
        category: 'Trending',
        distanceKm: 1.8,
      ),
      Listing(
        title: 'Popular City Loft',
        location: 'Bengaluru',
        imageUrls: [
          'assets/images/city_loft.png',
        ],
        rating: 4.4,
        pricePerNight: 4800,
        category: 'Trending',
        distanceKm: 2.0,
      ),

      // Countryside
      Listing(
        title: 'Luxury Countryside Villa',
        location: 'Udaipur',
        imageUrls: [
          'assets/images/countryside_villa.jpeg',
        ],
        rating: 4.9,
        pricePerNight: 8000,
        category: 'Countryside',
        distanceKm: 10.2,
      ),
      Listing(
        title: 'Peaceful Farmhouse',
        location: 'Jaipur',
        imageUrls: [
          'assets/images/peaceful_farmhouse.jpeg',
        ],
        rating: 4.7,
        pricePerNight: 6500,
        category: 'Countryside',
        distanceKm: 8.5,
      ),

      // Amazing pools
      Listing(
        title: 'Amazing Pool Villa',
        location: 'Jaipur',
        imageUrls: [
          'assets/images/amazing_pool_villa.jpeg',
        ],
        rating: 4.7,
        pricePerNight: 7000,
        category: 'Amazing pools',
        distanceKm: 4.5,
      ),
      Listing(
        title: 'Infinity Pool Retreat',
        location: 'Goa',
        imageUrls: [
          'assets/images/infinity_pool_retreat.jpg',
        ],
        rating: 4.8,
        pricePerNight: 7500,
        category: 'Amazing pools',
        distanceKm: 3.2,
      ),
    ];
  }
}
