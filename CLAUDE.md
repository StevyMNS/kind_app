# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**One Kind Message** (kind_app) is a minimalist, contemplative Flutter app for spreading kindness anonymously. Users write positive messages and receive messages from others - no likes, comments, or public profiles.

## Common Commands

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Run static analysis (required before any PR - must return 0 issues)
flutter analyze

# Run a single test
flutter test test/widget_test.dart

# Run tests with coverage
flutter test --coverage

# Generate Riverpod providers (after modifying provider files)
dart run build_runner build

# Build for iOS simulator
flutter build ios --simulator --no-codesign
```

## Architecture

This is a **Clean Architecture** Flutter project with 4 main layers:

```
lib/
├── application/       # Riverpod Providers & Controllers (AsyncNotifier)
├── core/              # Shared: Theme, Router, Errors, Utils, Constants
├── domain/            # Business Logic: Entities, Repository interfaces, Use Cases
├── infrastructure/   # Technical: DTOs/Models, DataSources, Repository implementations
└── presentation/      # UI: Screens & reusable Widgets
```

### Domain Layer (innermost)
- **Entities**: `UserEntity`, `MessageEntity`, `DeliveryEntity`
- **Repositories**: Interface definitions (`AuthRepository`, `MessageRepository`)
- **Use Cases**: Business logic classes (`SignInAnonymously`, `SendMessage`, `ReceiveRandomMessage`, `GetMessageHistory`)

### Infrastructure Layer
- **Models**: DTOs that map to/from Supabase (`UserModel`, `MessageModel`, `DeliveryModel`)
- **Datasources**: Supabase API calls (`AuthRemoteDatasource`, `MessageRemoteDatasource`)
- **Repository Implementations**: Concrete implementations of domain interfaces

### Application Layer
- **Providers**: Riverpod provider definitions (`supabase_providers`, `repository_providers`, `usecase_providers`)
- **Controllers**: `AsyncNotifier` classes managing state (`AuthController`, `SendMessageController`, `ReceiveMessageController`, `HistoryController`)

### Presentation Layer
- **Screens**: `HomeScreen`, `WriteScreen`, `ReceiveScreen`, `HistoryScreen`, `SettingsScreen`, `OnboardingScreen`, `SplashScreen`
- **Widgets**: Reusable UI components (`KindButton`, `KindCard`, `KindTextField`, `LoadingOverlay`, `EmptyState`, `ScaffoldWithBottomNav`)

## Key Technical Stack

- **State Management**: Riverpod 2.x with `AsyncNotifier`
- **Routing**: GoRouter with `StatefulShellRoute` for persistent bottom navigation
- **Backend**: Supabase (Anonymous Auth, PostgreSQL, RLS)
- **Environment**: `.env` file with `SUPABASE_URL` and `SUPABASE_ANON_KEY`

## Development Standards

1. **Never bypass Clean Architecture** - don't call Supabase directly from Widgets or Controllers
2. **Use `ref.watch()` in `build()` and `ref.read()` in callbacks** (e.g., `onPressed`)
3. **Use `flutter analyze`** before any PR - must pass with 0 issues
4. **No hardcoded colors** - use `AppColors` from `lib/core/theme/app_colors.dart`
5. **No `print()` statements** - use `AppLogger` from `lib/core/utils/logger.dart`
6. **Use `const`** where possible for performance
7. **Support both light and dark themes** - UI should adapt via `Theme.of(context)`
8. **Add Dart doc comments (`///`)** to Use Cases and Controllers