# Airbnb Guest Clone (Flutter) — UI & Navigation Only

A clean Flutter starter that mimics the **Guest-side** experience of Airbnb:
- Phone **login** → **OTP (1111)** → **Home** (Explore)
- **Bottom navigation**: Explore, Wishlists, Trips, Inbox, Profile
- **Explore**: search sheet, category chips, listing cards, image carousel
- **Listing details**: amenities, map placeholder, reviews, sticky bottom bar with “Reserve”
- **Booking UI**: date range picker, guest counters, price breakdown (no payments)
- **Profile**: sign out

> Pure UI — no backend, DB, or APIs.

## Quick Start

```bash
# 1) Unzip, cd into the project
cd airbnb_guest_clone_flutter

# Optional but recommended: ensure Flutter >= 3.19
flutter --version

# 2) (If platforms folders are missing) Scaffold them once:
flutter create .

# 3) Get packages
flutter pub get

# 4) Run
flutter run
```

## Notes
- OTP is **1111**.
- Placeholder images via picsum.photos.
- Change primary color in `ThemeData` (seedColor).
- Compatible with Material 3.
