# 🛍️ SwiftShop — Modern Flutter E-Commerce Application

[![Flutter](https://img.shields.io/badge/Flutter-3.44+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.12+-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Auth%20%7C%20Firestore-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![Vercel](https://img.shields.io/badge/Deployed%20on-Vercel-black?style=for-the-badge&logo=vercel&logoColor=white)](https://ecommerce-app-gules-theta.vercel.app)

> **Live Production Web Demo:** [https://ecommerce-app-gules-theta.vercel.app](https://ecommerce-app-gules-theta.vercel.app)

---

## 📱 Project Overview

**SwiftShop** is a full-featured, cross-platform E-Commerce application developed with **Flutter** and backed by **Firebase Authentication** and **Cloud Firestore**. 
The app is engineered with responsive mobile-framing on web, real-time database synchronization, smooth gesture interactions, and a clean modular architecture.

---

## ✨ Key Features

### 🔐 Authentication & User Management
- **Email & Password Authentication**: Secure sign-in and sign-up with real-time validation.
- **Google Sign-In**: Cross-platform OAuth support (`signInWithPopup` on Web, native on Mobile).
- **Password Reset**: Automated password recovery flow via Firebase Auth.
- **User Profiles**: Automatic profile synchronization with Firestore (`users` collection).

### 🛍️ Storefront & Browsing
- **Dynamic Banners & Promotions**: Auto-sliding promotional carousels with smooth indicator dots.
- **Featured & Most Popular Sections**: Horizontal scrollable product catalogs.
- **Instant Search & Filtering**: Real-time product search with keyword matching.
- **Detailed Product Screen**: Dynamic size selector, quantity control, and full description.

### 🛒 Shopping Cart & Orders
- **Real-Time Cart Stream**: Reactive badge counter on bottom navigation that updates instantly.
- **Quantity Management & Swipe-to-Delete**: Incremental quantity update and swipe gestures.
- **Checkout Workflow**: Automated order generation, subtotal & delivery calculation, and batch order logging.
- **Order History (`My Orders`)**: Full previous orders tracking with order IDs, timestamps, and status chips.

### ❤️ Wishlist / Favorites
- **Real-Time Favorites**: Save and remove liked products to Firestore with live status reflection across all screens.

### 👤 Profile & App Utilities
- **Account Information Bottom Sheet**: View user ID, email, and authentication provider.
- **Interactive Contact Support**: Direct customer support info and email dialog.
- **Share App Action**: Instant clipboard link sharing.
- **Help & FAQs**: Modal answering common shipping, payment, and return policies.

---

## 🛠️ Technology Stack & Architecture

- **Framework**: [Flutter](https://flutter.dev) (Channel Stable)
- **Language**: [Dart](https://dart.dev)
- **Backend as a Service**:
  - **Firebase Authentication**: User identity & Google OAuth.
  - **Cloud Firestore**: Real-time NoSQL database for users, cart items, favorites, and orders.
- **Hosting & Deployment**: [Vercel](https://vercel.com) (Optimized Static SPA with automated rewrites and `.vercelignore`).
- **UI & Animation Libraries**:
  - `google_nav_bar`: Modern interactive floating bottom navigation bar.
  - `carousel_slider`: Smooth auto-sliding promotional banners.
  - `smooth_page_indicator`: Animated dot indicators.

---

## 📂 Project Structure

```text
lib/
├── firebase_options.dart         # Generated FlutterFire multi-platform configuration
├── main.dart                     # App entry point, responsive web wrapper, themes
├── welcome/
│   └── splash_screen.dart        # Branded animated splash screen & auth routing
├── signIn/
│   ├── login_screen.dart         # Email & Google Sign-In
│   └── forgot_password_screen.dart # Password reset flow
├── register/
│   └── signup_screen.dart        # Registration with validation
├── home_nav/
│   ├── main_nav_screen.dart      # Bottom navigation with real-time Cart badge
│   ├── home_screen.dart          # Storefront, banners, and product sections
│   ├── search_screen.dart        # Live search and category filters
│   ├── cart_screen.dart          # Shopping cart, summary, and checkout logic
│   ├── favorites_screen.dart     # Wishlist screen connected to Firestore
│   ├── orders_screen.dart        # Orders history and status tracking
│   ├── product_details_screen.dart # Product specifications, sizes, & actions
│   └── products_list_screen.dart # Full product catalog grid
└── widgets/
    ├── custom_button.dart        # Reusable primary action button with loading state
    ├── custom_text_field.dart    # Styled form input field with validation
    ├── discount_banner.dart      # Promotional banner card
    └── product_card.dart         # Product item card with favorite & cart triggers
```

---

## 🚀 Getting Started Locally

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version 3.24.0 or higher)
- [Dart SDK](https://dart.dev/get-dart)
- An active [Firebase Project](https://console.firebase.google.com/)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/AlaaZaitoon/final-iti.git
   cd final-iti
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run on your preferred device:**
   - **Chrome / Web:**
     ```bash
     flutter run -d chrome
     ```
   - **Android Device / Emulator:**
     ```bash
     flutter run
     ```

4. **Build for Web Release:**
   ```bash
   flutter build web --release
   ```

---

## 👨‍💻 Author
- **Developer**: Alaa Abdelmagid (Alaa Zaitoon)
- **Live Demo**: [https://ecommerce-app-gules-theta.vercel.app](https://ecommerce-app-gules-theta.vercel.app)
