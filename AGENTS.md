# AGENTS.md - One Kind Message

## Project Overview

One Kind Message is a Flutter mobile app (Android/iOS/Web) that enables anonymous exchange of kind messages. Built with Clean Architecture, Riverpod 2.x, GoRouter, and Supabase.

---

## 1. Build / Lint / Test Commands

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Run on a specific platform
flutter run -d android
flutter run -d ios
flutter run -d chrome

# Run a single test file
flutter test test/widget_test.dart

# Run tests with coverage
flutter test --coverage

# Analyze the entire project
flutter analyze

# Analyze a specific file
flutter analyze lib/presentation/screens/settings_screen.dart

# Format code (auto-fix style issues)
dart format .
flutter format .

# Build for production
flutter build apk --release
flutter build ios --release
flutter build web --release

# Run build_runner for code generation (Riverpod)
dart run build_runner build --delete-conflicting-outputs
```

---

## 2. Architecture

The project follows **Clean Architecture** with a **layer-first** organization:

```
lib/
├── main.dart                      # Entry point
├── application/                   # Riverpod Providers & Controllers (AsyncNotifier)
│   ├── controllers/              # Business logic in AsyncNotifier classes
│   └── providers/                # Provider definitions (usecase, repository, datasource)
├── core/                         # Shared infrastructure
│   ├── constants/                # App constants, env config
│   ├── error/                    # Failure (domain) and Exception (infra) classes
│   ├── router/                   # GoRouter configuration
│   ├── services/                 # Shared services (daily limit, stats, onboarding)
│   ├── theme/                    # AppTheme, AppColors, AppTypography, AppRadius, AppShadows
│   └── utils/                   # Logger, validators, analytics
├── domain/                       # Business logic (no dependencies)
│   ├── entities/                 # Pure data classes (e.g., MessageEntity)
│   ├── repositories/             # Abstract interfaces (e.g., MessageRepository)
│   └── usecases/                # Single-responsibility use cases
├── infrastructure/              # Technical implementations
│   ├── datasources/             # Remote/local data sources
│   ├── models/                  # DTOs (e.g., MessageModel with fromJson/toJson)
│   └── repositories/            # Concrete implementations of domain interfaces
└── presentation/                # UI layer
    ├── screens/                 # Full-page screens
    └── widgets/                 # Reusable widgets (KindButton, KindCard, etc.)
```

**Dependency rule**: Each layer only depends on layers above it. `domain` has zero dependencies.

---

## 3. State Management

- **Riverpod 2.x** with `AsyncNotifier` for async state (API calls, loading/error/data states).
- Controllers are `AsyncNotifier` classes with a `FutureOr<T> build()` method.
- Use `AsyncValue.guard()` to wrap async operations and automatically set error/loading states.

```dart
// Provider definition pattern
final sendMessageControllerProvider =
    AsyncNotifierProvider<SendMessageController, MessageEntity?>(
      SendMessageController.new,
    );

// Usage in controller
state = const AsyncValue.loading();
state = await AsyncValue.guard(() async {
  final result = await someUseCase();
  return result;
});
state = AsyncError(errorMessage, StackTrace.current);

// Usage in UI
final state = ref.watch(sendMessageControllerProvider);
state.when(
  data: (message) => ContentWidget(message: message),
  loading: () => const LoadingWidget(),
  error: (e, st) => ErrorWidget(message: e.toString()),
);
```

---

## 4. Routing

- **GoRouter** with named routes (`name: 'home'`, `path: '/home'`).
- Navigation via `context.goNamed('home')` or `context.pushNamed('settings')`.
- `StatefulShellRoute.indexedStack` for bottom navigation with persistent state.
- Transitions defined per route (e.g., `FadeTransition` for onboarding, `SlideTransition` for settings).

---

## 5. Error Handling Pattern

### Domain Layer — Failures (sealed class)
Located in `lib/core/error/failures.dart`:
- `ServerFailure`, `AuthFailure`, `CacheFailure`, `ValidationFailure`, `UnknownFailure`

### Infrastructure Layer — Exceptions
Located in `lib/core/error/exceptions.dart`:
- `ServerException`, `AppAuthException`, `CacheException`, `ValidationException`, `NetworkTimeoutException`

### Repository Implementation Pattern
```dart
@override
Future<MessageEntity> sendMessage(String content) async {
  try {
    final model = await _datasource.sendMessage(content);
    return model.toEntity();
  } on ServerException {
    rethrow;  // Let it bubble up if already typed
  } catch (e, st) {
    AppLogger.error('MessageRepositoryImpl.sendMessage', e, st);
    throw ServerException('Erreur envoi message: ${e.toString()}');
  }
}
```

---

## 6. Model / Entity Pattern

- **Entities** (`domain/entities/`): Pure Dart classes with `const` constructor, no JSON/Supabase logic.
- **Models** (`infrastructure/models/`): DTOs with `fromJson()`, `toJson()`, and bidirectional conversion via `toEntity()` / `fromEntity()`.
- Always convert Model -> Entity before passing to domain/presentation layers.

```dart
// Entity
class MessageEntity {
  final String id;
  final String senderId;
  final String content;
  final DateTime createdAt;
  const MessageEntity({required this.id, required this.senderId, required this.content, required this.createdAt});
  @override bool operator ==(Object other) => ...;
  @override int get hashCode => id.hashCode;
}

// Model
class MessageModel {
  final String id;
  final String senderId;
  final String content;
  final DateTime createdAt;
  const MessageModel({required this.id, required this.senderId, required this.content, required this.createdAt});
  factory MessageModel.fromJson(Map<String, dynamic> json) => ...;
  Map<String, dynamic> toJson() => ...;
  MessageEntity toEntity() => MessageEntity(...);
  factory MessageModel.fromEntity(MessageEntity entity) => ...;
}
```

---

## 7. Code Style & Conventions

### General
- Dart 3.x with **null safety** enforced everywhere.
- No comments unless explaining non-obvious logic. Never add TODO comments without a ticket reference.
- Use `library;` directive in files that don't need a name.
- Private members use `_` prefix.
- No trailing whitespace.

### Naming Conventions
- Classes: `PascalCase` (e.g., `MessageEntity`, `KindButton`)
- Variables & methods: `camelCase` (e.g., `sendMessage`, `dailyLimitService`)
- Private fields: `_camelCase` with `_` prefix (e.g., `_datasource`)
- Constants: `camelCase` (e.g., `appRouter`, `supabaseUrl`)
- Enums & sealed classes: `PascalCase`
- File names: `snake_case.dart` matching the class name (e.g., `message_entity.dart`)

### Imports
- **Order**: `dart:` -> `package:` -> `package:kind_app/` relative imports
- Always use absolute `package:` imports for `kind_app` code (e.g., `package:kind_app/core/...`).
- Use `const` constructors wherever possible.
- No relative imports within `lib/`.

### Formatting
- Follow rules in `analysis_options.yaml` (included via `package:flutter_lints/flutter.yaml`).
- Key rules enforced:
  - `always_declare_return_types`
  - `prefer_const_constructors` / `prefer_const_constructors_in_immutables`
  - `prefer_final_fields` / `prefer_final_locals`
  - `prefer_single_quotes`
  - `require_trailing_commas` (use on multi-line collections/calls)
  - `curly_braces_in_flow_control_structures`
  - `sort_child_properties_last`
  - `annotate_overrides`
  - `avoid_print` (use `AppLogger` instead)

### UI / Widgets
- Use design system tokens: `AppColors`, `AppTypography`, `AppRadius`, `AppShadows`.
- Never hardcode colors, font sizes, or border radii — use the theme tokens.
- Material 3: `useMaterial3: true` in `ThemeData`.
- Use `const` constructors for widgets where possible.

### Testing
- Tests live in `test/`. Mirror the `lib/` structure: `test/domain/...`, `test/infrastructure/...`.
- Use `WidgetTester` for widget tests.
- Keep tests focused and named descriptively: `testWidgets('App initializes correctly', ...)`.

---

## 8. Environment & Secrets

- Environment variables stored in `.env` (loaded via `flutter_dotenv`).
- Template in `.env.example`.
- **Never commit `.env`** — it is in `.gitignore`.
- Access via `EnvConfig` class in `lib/core/constants/env_config.dart`.
