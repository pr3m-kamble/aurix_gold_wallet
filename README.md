# Aurix Gold Wallet

A fintech-grade Flutter mobile application for managing digital gold assets — buy, sell, transfer, and track gold-backed assets with real-time pricing. Built with Flutter 3.0+ and integrated with GoldAPI for live gold price data.

**GitHub:** https://github.com/PR3M-KAMBLE/aurix_gold_wallet

---

##  Overview

Aurix Gold Wallet is a feature-rich fintech app that allows users to:
- **Authenticate** securely with form validation
- **Monitor** real-time gold prices (EUR per gram)
- **Buy & Sell** gold with live price calculations
- **Transfer** gold to other users via email
- **Track** all transactions with detailed history
- **Manage** portfolio with balance and value charts

---

##  Screenshots

| Login | Dashboard | Buy Gold | Transactions |
|-------|-----------|----------|--------------|
| Dark fintech UI | Portfolio + chart | Real-time calculator | Filterable history |

---

##  Architecture Overview — MVVM with Riverpod

```
┌─────────────────────────────────────────────────┐
│                   UI Layer (View)               │
│   Screens: Login, Register, Dashboard,          │
│   BuyGold, SellGold, Transfer, Transactions     │
└────────────────────┬────────────────────────────┘
                     │ watches / reads
┌────────────────────▼────────────────────────────┐
│            ViewModel Layer (Providers)          │
│   AuthNotifier, TransactionNotifier,            │
│   goldPriceProvider — all via Riverpod          │
└────────────────────┬────────────────────────────┘
                     │ calls
┌────────────────────▼────────────────────────────┐
│              Service Layer (Model)              │
│   AuthService, TransactionService,              │
│   GoldPriceService (+ GoldAPI), StorageService  │
└────────────────────┬────────────────────────────┘
                     │ calls / persists
┌────────────────────▼────────────────────────────┐
│            Data Layer (External + Local)        │
│   GoldAPI (live prices) + SharedPreferences     │
└─────────────────────────────────────────────────┘
```

### Key Services

- **GoldPriceService:** Fetches live gold prices from GoldAPI (XAU/EUR) with automatic fallback to mock data
- **AuthService:** Handles user login/registration and validation
- **TransactionService:** Manages buy, sell, and transfer operations
- **StorageService:** Local persistence via SharedPreferences

---

## 📊 State Management: Riverpod

| Provider | Type | Purpose |
|---|---|---|
| `authProvider` | `StateNotifierProvider<AuthNotifier, AuthState>` | Login, register, logout, user state |
| `transactionProvider` | `StateNotifierProvider<TransactionNotifier, AsyncValue<List>>` | CRUD transactions, buy/sell/transfer |
| `goldPriceProvider` | `FutureProvider<GoldPriceData>` | **Live GoldAPI prices** (EUR/gram) with 30-day history |
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

##  Getting Started

### Prerequisites
- Flutter SDK >= 3.0.0
- Dart >= 3.0.0
- Chrome (for web testing)
- Git

### 1 Clone & Install

```bash
git clone https://github.com/PR3M-KAMBLE/aurix_gold_wallet.git
cd aurix_gold_wallet

# Install dependencies
flutter pub get
```

### 2 Get GoldAPI Key (Live Prices)

To use **live gold prices** from GoldAPI:

1. Visit **https://www.goldapi.io**
2. Sign up for a free account
3. Copy your API key from the dashboard
4. Use one of the methods below to provide the key

### 3 Run the App

#### Option A: Using `.env` file (Recommended for local dev)

```bash
# Copy the template
cp .env.example .env

# Edit .env and add your GoldAPI key
# GOLDAPI_KEY=your_actual_key_here
```

Then run:
```bash
flutter run
# or for web:
flutter run -d chrome
```

#### Option B: Using --dart-define (Recommended for CI/builds)

```bash
flutter run -d chrome --dart-define=GOLDAPI_KEY=your_actual_key_here
```

#### Option C: No API Key (Mock Data)

If you skip the API key setup, the app will automatically use mock gold prices:

```bash
flutter run
```

### 4️⃣ Build for Production

**Android APK:**
```bash
flutter build apk --release
```

**iOS App:**
```bash
flutter build ios --release
```

**Web:**
```bash
flutter build web --release
```

---

##  API Key Security

> ⚠️ **Never commit your actual API key to version control!**

- `.env` file is in `.gitignore` — it's safe to store local keys here
- `.env.example` shows the template (no real key)
- Use `--dart-define` for CI/CD pipelines
- For production, store keys in secure environment variables

---

##  Demo Login Credentials

```
Email:    demo@aurix.com
Password: password123
```

---

##  Features

| # | Feature | Status |
|---|---------|--------|
| 1 | Login + Registration with validation | ✅ Complete |
| 2 | Dashboard with portfolio overview | ✅ Complete |
| 3 | **Live Gold Prices (GoldAPI)** | ✅ Complete |
| 4 | Buy Gold with real-time calculations | ✅ Complete |
| 5 | Sell Gold with real-time calculations | ✅ Complete |
| 6 | Transfer Gold to users via email | ✅ Complete |
| 7 | Transaction History with filters | ✅ Complete |
| 8 | MVVM architecture with Riverpod | ✅ Complete |
| 9 | Dark mode fintech UI | ✅ Complete |
| 10 | Local persistence (SharedPreferences) | ✅ Complete |
| 11 | Portfolio value chart (fl_chart) | ✅ Complete |
| 12 | Smooth animations (flutter_animate) | ✅ Complete |
| 13 | Responsive design | ✅ Complete |

---

##  Dependencies

### Core Framework
- **flutter** - Google's UI framework
- **flutter_riverpod** (2.6.1) - State management
- **go_router** (13.2.5) - Navigation & routing

### API & Networking
- **http** (1.6.0) - HTTP client for GoldAPI calls
- **flutter_dotenv** (5.2.1) - Environment variable management

### UI & Animations
- **fl_chart** - Portfolio value charts
- **flutter_animate** - Smooth UI animations

### Persistence
- **shared_preferences** (2.2.2) - Local key-value storage

### Analysis & Formatting
- **flutter_lints** - Dart linting rules

---

## 💡 Project Details

### Real vs Mock

| Component | Type | Details |
|-----------|------|---------|
| **Gold Prices** | 🌐 Live API | GoldAPI (XAU/EUR) — real-time quotes with 30-day history |
| **Authentication** | Mock | Demo-only, no backend database |
| **Balance** | Mock | Set at login (€10,000 initial) |
| **Transactions** | Local | Stored in SharedPreferences, seeded with sample data |
| **User Deposits/Withdrawals** | N/A | Out of scope — balance is set at login |

### API Integration Details

**GoldAPI Endpoint:** `https://www.goldapi.io/api/XAU/EUR`

```dart
// Auto-fallback to mock data if:
// - No API key provided
// - API key is invalid
// - Network request fails
// - API is unreachable
```

The app gracefully handles all API failures and seamlessly falls back to mock prices for demo purposes.

### Assumptions & Scope

- Authentication is mocked (no Firebase backend)
- All persistence is local (SharedPreferences JSON)
- EUR deposits/withdrawals are out of scope
- "Receive" transactions are demo-seeded
- Web/Android/iOS supported (tested on Chrome)
- Dark mode only (theme system extensible to light mode)

---

##  Future Enhancements

- [ ] Firebase Auth + Firestore for production backend
- [ ] Real account verification & KYC flow
- [ ] Biometric authentication (fingerprint/face)
- [ ] Push notifications for price alerts
- [ ] Advanced portfolio analytics with date-range filters
- [ ] Multi-currency support (USD, GBP, etc.)
- [ ] Payment gateway integration (Stripe, PayPal)
- [ ] Savings/investment plans
- [ ] Referral program
- [ ] Unit & widget test coverage (80%+ target)
- [ ] Performance optimization & caching
- [ ] Offline mode with sync

---

##  Supported Platforms

- ✅ **Android** (API 21+)
- ✅ **iOS** (12.0+)
- ✅ **Web** (Chrome, Firefox, Safari)
- ✅ **macOS** (10.14+)
- ✅ **Windows** (10+)
- ✅ **Linux** (Ubuntu 18.04+)

---

##  Testing

```bash
# Run analyzer
flutter analyze

# Run tests (when added)
flutter test

# Build and test
flutter build web
```

---

## 📄 License

This project is licensed under the MIT License — see the LICENSE file for details.

---

## 👨‍💻 Author

**PR3M-KAMBLE**  
GitHub: https://github.com/PR3M-KAMBLE

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

## 📞 Support

For issues, questions, or suggestions, please open a GitHub issue at:  
https://github.com/PR3M-KAMBLE/aurix_gold_wallet/issues

---

**Last Updated:** June 2026  
**Status:** Active Development ✅
