import 'package:flutter/material.dart';
import '../models/listing.dart';
import '../dashboard/main_shell.dart';

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
          // Dates
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

          // Guests
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
                  min: 1,
                  onChanged: (v) => setState(() => adults = v)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Expanded(child: Text('Children')),
              _Counter(
                  value: children,
                  min: 0,
                  onChanged: (v) => setState(() => children = v)),
            ],
          ),
          const SizedBox(height: 24),

          // Price details
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

          // Request to Book Button
          FilledButton(
            onPressed: () {
              // Step 1: Show "Are you sure to book?" popup
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => AlertDialog(
                  title: const Text('Are you sure to book?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close popup
                      },
                      child: const Text('No'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close popup
                        // Step 2: Open Booking Successful screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookingSuccessfulScreen(
                              listing: widget.listing,
                              range: range,
                              adults: adults,
                              children: children,
                            ),
                          ),
                        );
                      },
                      child: const Text('Yes'),
                    ),
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

// Counter Widget
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

// Booking Successful Screen (inside BookingScreen.dart)
class BookingSuccessfulScreen extends StatelessWidget {
  final Listing listing;
  final DateTimeRange? range;
  final int adults;
  final int children;

  const BookingSuccessfulScreen({
    super.key,
    required this.listing,
    this.range,
    required this.adults,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Booking Status'),
        backgroundColor: const Color.fromARGB(255, 210, 83, 106),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Check Icon
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green[100],
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 80,
                ),
              ),
              const SizedBox(height: 30),

              // Booking Successful Text
              const Text(
                'Booking Successful!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              // Subtext
              const Text(
                'Your booking has been confirmed.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 40),

              // Buttons in Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 210, 83, 106),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        // Home → MainShell Explore tab
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MainShell(initialIndex: 0),
                          ),
                          (route) => false,
                        );
                      },
                      child: const Text(
                        'Home',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        // Back → go to BookingScreen with same listing
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookingScreen(listing: listing),
                          ),
                        );
                      },
                      child: const Text(
                        'Back',
                        style: TextStyle(fontSize: 18, color: Colors.black87),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
