import 'package:flutter/material.dart';

void main() {
  runApp(const AirbnbGuestCloneApp());
}

/// Simple in-memory auth flag
class AuthState extends ValueNotifier<bool> {
  AuthState() : super(false);
}

final authState = AuthState();

class AirbnbGuestCloneApp extends StatelessWidget {
  const AirbnbGuestCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Staybnb',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF385C)),
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const AuthGate());
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case '/otp':
            final phone = settings.arguments as String?;
            return MaterialPageRoute(
                builder: (_) => OTPScreen(phoneNumber: phone ?? ''));
          case '/home':
            return MaterialPageRoute(builder: (_) => const MainShell());
          case '/listing':
            final args = settings.arguments as ListingArgs;
            return MaterialPageRoute(
                builder: (_) => ListingDetailScreen(listing: args.listing));
          case '/booking':
            final listing = settings.arguments as Listing;
            return MaterialPageRoute(
                builder: (_) => BookingScreen(listing: listing));
          default:
            return MaterialPageRoute(
              builder: (_) => Scaffold(
                body: Center(child: Text('Unknown route: ${settings.name}')),
              ),
            );
        }
      },
    );
  }
}

/// Decides whether to show Login or Home
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: authState,
      builder: (context, loggedIn, _) {
        if (loggedIn) return const MainShell();
        return const LoginScreen();
      },
    );
  }
}

// =================== LOGIN & OTP ===================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController();

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: SafeArea(
        child: Center(
          // centers vertically and horizontally
          child: SingleChildScrollView(
            // prevents overflow
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // vertical center
              crossAxisAlignment:
                  CrossAxisAlignment.center, // horizontal center
              children: [
                Image.asset(
                  'images/logo.jpg', // your logo path
                  height: 100, // adjust size
                ),
                const SizedBox(height: 20), // spacing
                Text(
                  'Welcome to Staybnb',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center, // center text
                ),
                const SizedBox(height: 8),
                const SizedBox(height: 12),
                Form(
                  key: _formKey,
                  child: SizedBox(
                    width: 400, // fixed width for consistency
                    child: TextFormField(
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      // textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        labelText: 'Enter Your Phone number',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      validator: (v) {
                        if ((v ?? '').trim().isEmpty) {
                          return 'Enter phone number';
                        }
                        if ((v ?? '').trim().length < 8) {
                          return 'Enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                // Continue button - small and centered
                const SizedBox(height: 30), // spacing
                Center(
                  child: SizedBox(
                    width: 400, // same as phone number box
                    child: FilledButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.pushNamed(
                            context,
                            '/otp',
                            arguments: _phoneCtrl.text.trim(),
                          );
                        }
                      },
                      child: const Text('Continue'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OTPScreen extends StatefulWidget {
  final String phoneNumber;
  const OTPScreen({super.key, required this.phoneNumber});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _otpCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _otpCtrl.dispose();
    super.dispose();
  }

  void _verify() {
    if (!_formKey.currentState!.validate()) return;
    final code = _otpCtrl.text.trim();
    if (code == '1111') {
      authState.value = true;
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP. Try 1111.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: SafeArea(
        child: Center(
          // centers vertically
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title
                Text(
                  'Verify OTP',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // Subtitle
                Text(
                  'We sent a code to ${widget.phoneNumber}',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),

                // OTP input
                Form(
                  key: _formKey,
                  child: SizedBox(
                    width: 250,
                    child: TextFormField(
                      controller: _otpCtrl,
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      decoration: const InputDecoration(
                        labelText: 'Enter OTP (try 1111)',
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      validator: (v) {
                        if ((v ?? '').length != 4) return 'Enter 4-digit OTP';
                        return null;
                      },
                      onFieldSubmitted: (_) => _verify(),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Verify button
                SizedBox(
                  width: 250,
                  child: FilledButton(
                    onPressed: _verify,
                    child: const Text('Verify'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =================== MAIN SHELL (BOTTOM NAV) ===================
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  final _pages = const [
    ExplorePage(),
    WishlistsPage(),
    TripsPage(),
    InboxPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color.fromARGB(255, 210, 83, 106), // Airbnb pink
        indicatorColor: Colors.white.withOpacity(0.2), // selected tab highlight
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

// =================== EXPLORE (HOME) ===================
class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: _SearchBar(),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.tune))],
      ),
      body: Column(
        children: [
          const _CategoryChips(),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final listing = mockListings[index % mockListings.length];
                return ListingCard(listing: listing);
              },
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemCount: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => const _SearchBottomSheet(),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(32),
        ),
        child: const Row(
          children: [
            Icon(Icons.search),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Where to? Anywhere · Any week · Add guests',
                style: TextStyle(
                  fontSize: 14, // ↓ smaller font size
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBottomSheet extends StatelessWidget {
  const _SearchBottomSheet();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      minChildSize: 0.5,
      builder: (context, controller) {
        return Scaffold(
          appBar: AppBar(title: const Text('Search')),
          body: ListView(
            controller: controller,
            padding: const EdgeInsets.all(16),
            children: [
              const _FieldTile(
                  icon: Icons.place_outlined,
                  title: 'Where',
                  subtitle: 'Search destinations'),
              const SizedBox(height: 12),
              const _FieldTile(
                  icon: Icons.calendar_month_outlined,
                  title: 'When',
                  subtitle: 'Add dates'),
              const SizedBox(height: 12),
              const _FieldTile(
                  icon: Icons.people_outline,
                  title: 'Who',
                  subtitle: 'Add guests'),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Show places'),
              )
            ],
          ),
        );
      },
    );
  }
}

class _FieldTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _FieldTile(
      {required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips();

  @override
  Widget build(BuildContext context) {
    final cats = [
      'Trending',
      'Beach',
      'Countryside',
      'City',
      'Cabins',
      'Pools',
      'Amazing views'
    ];
    return SizedBox(
      height: 56,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, i) => FilterChip(
          label: Text(cats[i]),
          selected: i == 0,
          onSelected: (_) {},
        ),
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: cats.length,
      ),
    );
  }
}

class ListingCard extends StatelessWidget {
  final Listing listing;
  const ListingCard({super.key, required this.listing});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/listing',
            arguments: ListingArgs(listing));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: _ImageCarousel(imageUrls: listing.imageUrls, height: 220),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(listing.title,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
              const Icon(Icons.star, size: 16),
              const SizedBox(width: 4),
              Text(listing.rating.toStringAsFixed(2)),
            ],
          ),
          Text('${listing.location} · ${listing.distanceKm} km away',
              style: Theme.of(context).textTheme.bodySmall),
          Text('Oct 12 - 17', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 4),
          Text('₹${listing.pricePerNight.toStringAsFixed(0)} night',
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _ImageCarousel extends StatefulWidget {
  final List<String> imageUrls;
  final double height;
  const _ImageCarousel({required this.imageUrls, required this.height});

  @override
  State<_ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<_ImageCarousel> {
  final _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          height: widget.height,
          width: double.infinity,
          child: PageView.builder(
            controller: _controller,
            onPageChanged: (i) => setState(() => _page = i),
            itemCount: widget.imageUrls.length,
            itemBuilder: (_, i) =>
                Image.network(widget.imageUrls[i], fit: BoxFit.cover),
          ),
        ),
        Positioned(
          bottom: 8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.imageUrls.length, (i) {
              final selected = i == _page;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 2),
                height: 6,
                width: selected ? 16 : 6,
                decoration: BoxDecoration(
                  color: selected ? Colors.white : Colors.white70,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

// =================== LISTING DETAILS ===================
class ListingDetailScreen extends StatelessWidget {
  final Listing listing;
  const ListingDetailScreen({super.key, required this.listing});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 300,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.ios_share_outlined)),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.favorite_border)),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background:
                  _ImageCarousel(imageUrls: listing.imageUrls, height: 300),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(listing.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            Text(listing.location,
                                style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ),
                      const Icon(Icons.star, size: 18),
                      const SizedBox(width: 4),
                      Text(listing.rating.toStringAsFixed(2)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _AmenityChip('Wifi'),
                      _AmenityChip('Kitchen'),
                      _AmenityChip('Washer'),
                      _AmenityChip('Free parking'),
                      _AmenityChip('Air conditioning'),
                      _AmenityChip('Dedicated workspace'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  Text('Where you\'ll be',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Container(
                    height: 160,
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(child: Icon(Icons.map, size: 48)),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  Text('Reviews',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  const _ReviewTile(
                      author: 'Aarav', text: 'Lovely stay with amazing views!'),
                  const _ReviewTile(
                      author: 'Meera',
                      text: 'Very clean and close to everything.'),
                  const SizedBox(height: 100), // space for bottom bar
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('₹${listing.pricePerNight.toStringAsFixed(0)} night',
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    Text('Oct 12 - 17 · 2 guests',
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              FilledButton(
                onPressed: () => Navigator.pushNamed(context, '/booking',
                    arguments: listing),
                child: const Text('Reserve'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AmenityChip extends StatelessWidget {
  final String label;
  const _AmenityChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      avatar: const Icon(Icons.check, size: 16),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final String author;
  final String text;
  const _ReviewTile({required this.author, required this.text});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const CircleAvatar(child: Icon(Icons.person)),
      title: Text(author, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(text),
    );
  }
}

// =================== BOOKING (UI ONLY) ===================
class BookingScreen extends StatefulWidget {
  final Listing listing;
  const BookingScreen({super.key, required this.listing});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTimeRange? range;
  int adults = 2;
  int children = 0;

  @override
  Widget build(BuildContext context) {
    final nights = range == null ? 0 : range!.duration.inDays;
    return Scaffold(
      appBar: AppBar(title: const Text('Request to book')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.calendar_month_outlined),
            title: const Text('Dates'),
            subtitle: Text(range == null
                ? 'Add dates'
                : '${_fmt(range!.start)} - ${_fmt(range!.end)} ($nights nights)'),
            trailing: TextButton(
              onPressed: () async {
                final now = DateTime.now();
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: now,
                  lastDate: DateTime(now.year + 1),
                );
                if (picked != null) setState(() => range = picked);
              },
              child: const Text('Edit'),
            ),
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.people_outline),
            title: const Text('Guests'),
            subtitle: Text('$adults adults · $children children'),
          ),
          Row(
            children: [
              const Expanded(child: Text('Adults')),
              _Counter(
                  value: adults,
                  onChanged: (v) => setState(() => adults = v),
                  min: 1),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Expanded(child: Text('Children')),
              _Counter(
                  value: children,
                  onChanged: (v) => setState(() => children = v),
                  min: 0),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Price details',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                _priceRow(
                    '${widget.listing.pricePerNight.toStringAsFixed(0)} × ${nights == 0 ? 1 : nights} nights',
                    widget.listing.pricePerNight * (nights == 0 ? 1 : nights)),
                _priceRow('Cleaning fee', 800),
                _priceRow('Service fee', 600),
                const Divider(),
                _priceRow(
                    'Total (before taxes)',
                    widget.listing.pricePerNight * (nights == 0 ? 1 : nights) +
                        1400,
                    isBold: true),
              ],
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Request sent'),
                  content: const Text(
                      'This is a UI-only demo. No payment is processed.'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'))
                  ],
                ),
              );
            },
            child: const Text('Request to book'),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, double amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text('₹${amount.toStringAsFixed(0)}',
              style: TextStyle(
                  fontWeight: isBold ? FontWeight.w700 : FontWeight.w400)),
        ],
      ),
    );
  }

  String _fmt(DateTime d) => '${d.day}/${d.month}/${d.year}';
}

class _Counter extends StatelessWidget {
  final int value;
  final int min;
  final ValueChanged<int> onChanged;
  const _Counter(
      {required this.value, required this.onChanged, required this.min});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: value > min ? () => onChanged(value - 1) : null,
          icon: const Icon(Icons.remove_circle_outline),
        ),
        Text(value.toString(),
            style: const TextStyle(fontWeight: FontWeight.w700)),
        IconButton(
          onPressed: () => onChanged(value + 1),
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }
}

// =================== OTHER TABS (SIMPLE UI) ===================
class WishlistsPage extends StatelessWidget {
  const WishlistsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // light background
      appBar: AppBar(
        title: const Text('Wishlists'),
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final listing = mockListings[index % mockListings.length];
          return WishlistCard(listing: listing);
        },
        separatorBuilder: (_, __) => const SizedBox(height: 20),
        itemCount: mockListings.length,
      ),
    );
  }
}

class WishlistCard extends StatelessWidget {
  final Listing listing;
  const WishlistCard({super.key, required this.listing});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // white card background
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: _ImageCarousel(
              imageUrls: listing.imageUrls,
              height: 200,
            ),
          ),

          // Content section
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        listing.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const Icon(Icons.star, size: 16, color: Colors.black87),
                    const SizedBox(width: 4),
                    Text(
                      listing.rating.toStringAsFixed(2),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${listing.location} · ${listing.distanceKm} km away',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 2),
                Text(
                  'Saved on Oct 12', // custom text for wishlists
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 6),
                Text(
                  '₹${listing.pricePerNight.toStringAsFixed(0)} night',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TripsPage extends StatelessWidget {
  const TripsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // light background
      appBar: AppBar(
        title: const Text('Trips'),
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final listing = mockListings[index % mockListings.length];
          return TripCard(listing: listing);
        },
        separatorBuilder: (_, __) => const SizedBox(height: 20),
        itemCount: mockListings.length,
      ),
    );
  }
}

class TripCard extends StatelessWidget {
  final Listing listing;
  const TripCard({super.key, required this.listing});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // white background
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: _ImageCarousel(
              imageUrls: listing.imageUrls,
              height: 200,
            ),
          ),

          // Content section
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  listing.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${listing.location} · ${listing.distanceKm} km away',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                Text(
                  'Oct 12 - 17, 2024', // trip dates
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 6),
                Text(
                  '₹${listing.pricePerNight.toStringAsFixed(0)} night',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: () {
                    // Add navigation to trip details if needed
                  },
                  child: const Text('View Trip Details'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InboxPage extends StatelessWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> chats = [
      {
        "name": "Shivank - Host",
        "lastMessage": "Looking forward to your stay!",
        "image": "https://via.placeholder.com/150"
      },
      {
        "name": "Gaurav - Guest",
        "lastMessage": "Can I check in early?",
        "image": "https://via.placeholder.com/150"
      },
      {
        "name": "Aman - Host",
        "lastMessage": "Looking forward to your stay!",
        "image": "https://via.placeholder.com/150"
      },
      {
        "name": "Sneha - Host",
        "lastMessage": "Looking forward to your stay!",
        "image": "https://via.placeholder.com/150"
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Inbox'),
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView.separated(
        itemCount: chats.length,
        separatorBuilder: (_, __) => const Divider(height: 0),
        itemBuilder: (context, index) {
          final chat = chats[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(chat["image"]!),
              radius: 24,
            ),
            title: Text(chat["name"]!,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(chat["lastMessage"]!),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(
                    name: chat["name"]!,
                    image: chat["image"]!,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String name;
  final String image;

  const ChatScreen({super.key, required this.name, required this.image});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, dynamic>> messages = [
    {"text": "Hi, welcome to my property!", "isMe": false},
    {"text": "Thank you! Excited for my stay.", "isMe": true},
  ];

  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      messages.add({"text": _controller.text.trim(), "isMe": true});
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.image),
            ),
            const SizedBox(width: 10),
            Text(widget.name),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return Align(
                  alignment: msg["isMe"]
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: msg["isMe"]
                          ? Colors.pinkAccent.shade100
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(msg["text"]),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.pinkAccent),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          const CircleAvatar(radius: 36, child: Icon(Icons.person, size: 36)),
          const SizedBox(height: 8),
          Center(
              child: Text('Guest User',
                  style: Theme.of(context).textTheme.titleMedium)),
          const SizedBox(height: 24),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              onTap: () {}),
          ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Help Center'),
              onTap: () {}),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign out'),
            onTap: () {
              authState.value = false;
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);
            },
          ),
        ],
      ),
    );
  }
}

// =================== DATA ===================
//
class ListingsView extends StatelessWidget {
  const ListingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: mockListings.length,
      separatorBuilder: (_, __) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        final listing = mockListings[index];
        return Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 121, 46, 46),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 3, 3, 3).withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image carousel
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: SizedBox(
                  height: 200,
                  child: PageView(
                    children: listing.imageUrls
                        .map((url) => Image.network(
                              url,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ))
                        .toList(),
                  ),
                ),
              ),

              // Details section
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + Rating
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            listing.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const Icon(Icons.star, size: 16, color: Colors.black87),
                        const SizedBox(width: 4),
                        Text(listing.rating.toStringAsFixed(2)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Location + Distance
                    Text(
                      '${listing.location} · ${listing.distanceKm} km away',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 2),
                    // Price
                    Text(
                      '₹${listing.pricePerNight.toStringAsFixed(0)} night',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// =================== DATA MODELS ===================
class Listing {
  final String id;
  final String title;
  final String location;
  final double rating;
  final double distanceKm;
  final double pricePerNight;
  final List<String> imageUrls;
  final String description;
  final String hostName;
  final int maxGuests;
  final int bedrooms;
  final int bathrooms;
  final List<String> amenities;

  const Listing({
    required this.id,
    required this.title,
    required this.location,
    required this.rating,
    required this.distanceKm,
    required this.pricePerNight,
    required this.imageUrls,
    required this.description,
    required this.hostName,
    required this.maxGuests,
    required this.bedrooms,
    required this.bathrooms,
    required this.amenities,
  });
}

class ListingArgs {
  final Listing listing;
  const ListingArgs(this.listing);
}

// =================== MOCK DATA ===================
final List<Listing> mockListings = [
  const Listing(
    id: '1',
    title: 'Cozy Apartment in Mumbai',
    location: 'Bandra, Mumbai',
    rating: 4.8,
    distanceKm: 2.5,
    pricePerNight: 3500,
    imageUrls: [
      'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800',
      'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800',
      'https://images.unsplash.com/photo-1484154218962-a197022b5858?w=800',
    ],
    description:
        'Beautiful apartment with modern amenities in the heart of Bandra.',
    hostName: 'Priya',
    maxGuests: 4,
    bedrooms: 2,
    bathrooms: 2,
    amenities: ['WiFi', 'Kitchen', 'Air conditioning', 'Parking'],
  ),
  const Listing(
    id: '2',
    title: 'Beach House in Goa',
    location: 'Calangute, Goa',
    rating: 4.9,
    distanceKm: 1.2,
    pricePerNight: 5500,
    imageUrls: [
      'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800',
      'https://images.unsplash.com/photo-1520637836862-4d197d17c90a?w=800',
      'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800',
    ],
    description: 'Stunning beach house just steps away from Calangute Beach.',
    hostName: 'Raj',
    maxGuests: 6,
    bedrooms: 3,
    bathrooms: 2,
    amenities: ['WiFi', 'Beach access', 'Pool', 'Kitchen', 'Parking'],
  ),
  const Listing(
    id: '3',
    title: 'Mountain Retreat in Manali',
    location: 'Old Manali, Himachal Pradesh',
    rating: 4.7,
    distanceKm: 5.8,
    pricePerNight: 2800,
    imageUrls: [
      'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
      'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=800',
      'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800',
    ],
    description:
        'Peaceful mountain retreat with breathtaking views of the Himalayas.',
    hostName: 'Amit',
    maxGuests: 4,
    bedrooms: 2,
    bathrooms: 1,
    amenities: ['WiFi', 'Fireplace', 'Mountain view', 'Kitchen'],
  ),
  const Listing(
    id: '4',
    title: 'Heritage Villa in Jaipur',
    location: 'Pink City, Jaipur',
    rating: 4.6,
    distanceKm: 3.2,
    pricePerNight: 4200,
    imageUrls: [
      'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=800',
      'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=800',
      'https://images.unsplash.com/photo-1571003123894-1f0594d2b5d9?w=800',
    ],
    description:
        'Traditional Rajasthani villa with authentic architecture and modern comforts.',
    hostName: 'Sunita',
    maxGuests: 8,
    bedrooms: 4,
    bathrooms: 3,
    amenities: [
      'WiFi',
      'Pool',
      'Garden',
      'Kitchen',
      'Parking',
      'Heritage architecture'
    ],
  ),
  const Listing(
    id: '5',
    title: 'Modern Loft in Bangalore',
    location: 'Koramangala, Bangalore',
    rating: 4.5,
    distanceKm: 4.1,
    pricePerNight: 3200,
    imageUrls: [
      'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800',
      'https://images.unsplash.com/photo-1560185007-cde436f6a4d0?w=800',
      'https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=800',
    ],
    description:
        'Stylish loft in the tech hub of Bangalore with all modern amenities.',
    hostName: 'Karthik',
    maxGuests: 3,
    bedrooms: 1,
    bathrooms: 1,
    amenities: [
      'WiFi',
      'Air conditioning',
      'Kitchen',
      'Workspace',
      'Gym access'
    ],
  ),
];
