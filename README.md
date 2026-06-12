# Aurix Gold Wallet

A fintech-grade Flutter mobile app for managing digital gold assets — buy, sell, transfer, and track gold-backed assets in real time.

---

## Screenshots

| Login | Dashboard | Buy Gold | Transactions |
|-------|-----------|----------|--------------|
| Dark fintech UI | Portfolio + chart | Real-time calculator | Filterable history |

---

## Architecture Overview — MVVM with Riverpod

```
┌─────────────────────────────────────────────────┐
│                   UI Layer (View)                │
│   Screens: Login, Register, Dashboard,          │
│   BuyGold, SellGold, Transfer, Transactions     │
└────────────────────┬────────────────────────────┘
                     │ watches / reads
┌────────────────────▼────────────────────────────┐
│            ViewModel Layer (Providers)           │
│   AuthNotifier, TransactionNotifier,            │
│   goldPriceProvider — all via Riverpod          │
└────────────────────┬────────────────────────────┘
                     │ calls
┌────────────────────▼────────────────────────────┐
│              Service Layer (Model)               │
│   AuthService, TransactionService,              │
│   GoldPriceService, StorageService              │
└────────────────────┬────────────────────────────┘
                     │ persists
┌────────────────────▼────────────────────────────┐
│            Data Layer (Persistence)              │
│         SharedPreferences (local JSON)          │
└─────────────────────────────────────────────────┘
```

---

## State Management: Riverpod

| Provider | Type | Purpose |
|---|---|---|
| `authProvider` | `StateNotifierProvider<AuthNotifier, AuthState>` | Login, register, logout, user state |
| `transactionProvider` | `StateNotifierProvider<TransactionNotifier, AsyncValue<List>>` | CRUD transactions, buy/sell/transfer |
| `goldPriceProvider` | `Provider<GoldPriceData>` | Mock price + 30-day history |
| `storageServiceProvider` | `Provider<StorageService>` | SharedPreferences abstraction |

---

## Folder Structure

```
lib/
├── main.dart                    # App entry + ProviderScope
├── theme/
│   └── app_theme.dart           # Dark gold design system + colors
├── models/
│   ├── user_model.dart          # User data + serialization
│   ├── transaction_model.dart   # Transaction + enums
│   └── gold_price_model.dart    # Price + chart data
├── services/
│   ├── auth_service.dart        # Mock auth logic
│   ├── transaction_service.dart # Buy/sell/transfer logic
│   ├── gold_price_service.dart  # Price generation
│   └── storage_service.dart     # SharedPreferences wrapper
├── providers/
│   └── app_providers.dart       # All Riverpod providers + notifiers
├── utils/
│   └── router.dart              # go_router configuration
├── widgets/
│   └── common_widgets.dart      # GoldButton, AurixCard, TransactionItem, etc.
└── screens/
    ├── auth/
    │   ├── login_screen.dart
    │   └── register_screen.dart
    ├── dashboard/
    │   └── dashboard_screen.dart
    ├── buy_sell/
    │   ├── buy_gold_screen.dart
    │   └── sell_gold_screen.dart
    ├── transfer/
    │   └── transfer_screen.dart
    └── transactions/
        └── transactions_screen.dart
```

---

## Getting Started

### Prerequisites
- Flutter SDK >= 3.0.0
- Dart >= 3.0.0

### Run

```bash
# Clone and open
cd aurix_gold_wallet

# Install dependencies
flutter pub get

# Run on device/emulator
flutter run

# Build APK
flutter build apk --release
```

### Run with local `.env`
Copy `.env.example` to `.env` and set your key:
```env
GOLDAPI_KEY=your_goldapi_key_here
```
Then run:
```bash
flutter run -d chrome
```

### Run with live gold price API via dart-define
```bash
flutter run -d chrome --dart-define=GOLDAPI_KEY=your_goldapi_key_here
```

### Default Login (Demo)
- **Email:** `demo@aurix.com`
- **Password:** `password123`

---

## Features

| Part | Feature | Status |
|------|---------|--------|
| 1 | Login + Registration with form validation | ✅ |
| 2 | Dashboard: balance, gold price, portfolio value | ✅ |
| 3 | Buy Gold: EUR → gold with real-time calc | ✅ |
| 3 | Sell Gold: gold → EUR with real-time calc | ✅ |
| 4 | Transfer Gold: email + amount validation | ✅ |
| 5 | Transaction History with type filters | ✅ |
| 6 | MVVM architecture + Riverpod | ✅ |
| Bonus | Dark mode (only mode) | ✅ |
| Bonus | Local persistence (SharedPreferences) | ✅ |
| Bonus | Portfolio value chart (fl_chart) | ✅ |
| Bonus | Animations (flutter_animate) | ✅ |

---

## Assumptions

- Authentication is mocked (no Firebase backend)
- Gold price is mock-seeded at €65/gram with realistic 30-day variation
- All persistence is local (SharedPreferences JSON)
- EUR deposits/withdrawals are out of scope (balance set at login)
- "Receive" transactions are seeded for demo purposes

## Future Improvements

- Firebase Auth + Firestore for real backend
- Real-time gold price API (e.g. Metals API)
- Biometric authentication (local_auth)
- Push notifications for price alerts
- Portfolio analytics with date range filters
- Multi-currency support
- KYC flow and identity verification
- Unit + widget test coverage
