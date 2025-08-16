import 'package:flutter/material.dart';
import '../models/listing.dart';
import '../dashboard/explore.dart'; // For ListingCard

class WishlistsPage extends StatefulWidget {
  const WishlistsPage({super.key});

  @override
  State<WishlistsPage> createState() => _WishlistsPageState();
}

class _WishlistsPageState extends State<WishlistsPage> {
  String searchQuery = ''; // Store search text

  @override
  Widget build(BuildContext context) {
    // Filter listings based on search query
    final listings = Listing.getMockListings()
        .where((listing) =>
            listing.title.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Wishlists'),
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search in wishlists...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Wishlist Items
          Expanded(
            child: listings.isEmpty
                ? const Center(
                    child: Text(
                      'No listings found in wishlists.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: listings.length,
                    itemBuilder: (context, index) {
                      final listing = listings[index];
                      return ListingCard(
                        listing: listing,
                        bottomContent: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    listing.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const Icon(Icons.star,
                                    size: 16, color: Colors.black87),
                                const SizedBox(width: 4),
                                Text(listing.rating.toStringAsFixed(1)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${listing.location} · ${listing.distanceKm} km away',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Saved on Oct 12',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '₹${listing.pricePerNight.toStringAsFixed(0)} / night',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                  ),
          ),
        ],
      ),
    );
  }
}
