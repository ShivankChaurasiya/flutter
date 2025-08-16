import 'package:flutter/material.dart';
import '../models/listing.dart';
import '../listing/listing_detail_screen.dart';
import 'search_bar.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    final listings = Listing.getMockListings();

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const CustomSearchBar(),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.tune))],
      ),
      body: Column(
        children: [
          // Category Chips
          const _CategoryChips(),

          // Listings
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: listings.length,
              itemBuilder: (context, index) {
                final listing = listings[index];
                return ListingCard(
                  listing: listing,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ListingDetailScreen(listing: listing),
                      ),
                    );
                  },
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

class _CategoryChips extends StatefulWidget {
  const _CategoryChips();

  @override
  State<_CategoryChips> createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<_CategoryChips> {
  int selectedIndex = 0;
  final categories = [
    'All',
    'Beachfront',
    'Cabins',
    'Trending',
    'Countryside',
    'Amazing pools'
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(categories[index]),
              selected: selectedIndex == index,
              onSelected: (_) {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
          );
        },
      ),
    );
  }
}

// PUBLIC ListingCard class
class ListingCard extends StatelessWidget {
  final Listing listing;
  final VoidCallback? onTap;
  final Widget? bottomContent;

  const ListingCard(
      {super.key, required this.listing, this.onTap, this.bottomContent});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 200,
                  child: listing.imageUrls.first.startsWith('assets/')
                      ? Image.asset(
                          listing.imageUrls.first,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(Icons.image,
                                    size: 50, color: Colors.grey),
                              ),
                            );
                          },
                        )
                      : Image.network(
                          listing.imageUrls.first,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(Icons.image,
                                    size: 50, color: Colors.grey),
                              ),
                            );
                          },
                        ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    onPressed: () {},
                    icon:
                        const Icon(Icons.favorite_border, color: Colors.white),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: bottomContent ??
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        listing.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        listing.location,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(listing.rating.toStringAsFixed(1)),
                          const Spacer(),
                          Text(
                            '₹${listing.pricePerNight.toStringAsFixed(0)}/night',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
