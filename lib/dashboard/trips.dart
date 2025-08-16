import 'package:flutter/material.dart';
import '../models/listing.dart';
import '../dashboard/explore.dart'; // For ListingCard
import '../listing/listing_detail_screen.dart';
import 'search_bar.dart';

class TripsPage extends StatefulWidget {
  const TripsPage({super.key});

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  @override
  Widget build(BuildContext context) {
    final listings = Listing.getMockListings();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const CustomSearchBar(),
        surfaceTintColor: Colors.transparent,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.tune))],
      ),
      body: Column(
        children: [
          // Trips List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: listings.length,
              itemBuilder: (context, index) {
                final listing = listings[index];
                return ListingCard(
                  listing: listing,
                  onTap: () {
                    // Navigate to listing detail
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ListingDetailScreen(listing: listing),
                      ),
                    );
                  },
                  bottomContent: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              listing.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
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
                        'Booked on Oct 12',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
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
