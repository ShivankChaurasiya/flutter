import 'package:flutter/material.dart';
import 'explore.dart';
import 'wishlist.dart';
import 'trips.dart';
import 'inbox.dart';
import 'profile.dart';

class MainShell extends StatefulWidget {
  final int initialIndex;
  const MainShell({super.key, this.initialIndex = 0});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _index;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;

    // Pages list
    _pages = const [
      ExplorePage(),
      WishlistsPage(),
      TripsPage(),
      InboxPage(),
      ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: IndexedStack(
        index: _index,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color.fromARGB(255, 210, 83, 106),
        indicatorColor: Colors.white.withValues(alpha: 0.2),
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.search), label: 'Explore'),
          NavigationDestination(
              icon: Icon(Icons.favorite_outline), label: 'Wishlists'),
          NavigationDestination(
              icon: Icon(Icons.airplane_ticket_outlined), label: 'Trips'),
          NavigationDestination(
              icon: Icon(Icons.chat_bubble_outline), label: 'Inbox'),
          NavigationDestination(
              icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}
