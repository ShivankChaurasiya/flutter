import 'package:flutter/material.dart';
import 'auth/auth_gate.dart';
import 'auth/login.dart';
import 'auth/otp.dart';
import 'dashboard/main_shell.dart';
import 'dashboard/explore.dart';
import 'listing/listing_detail_screen.dart';
import 'booking/booking_screen.dart';
import 'models/listing.dart';
import 'models/listing_args.dart';

void main() {
  runApp(const AirbnbGuestCloneApp());
}

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
            final initialIndex = settings.arguments as int? ?? 0;
            return MaterialPageRoute(
                builder: (_) => MainShell(initialIndex: initialIndex));
          case '/explore':
            return MaterialPageRoute(builder: (_) => const ExplorePage());
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
