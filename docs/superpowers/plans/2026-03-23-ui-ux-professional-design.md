# UI/UX Professional Design Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Improve One Kind Message app UI/UX to be more professional with refined typography, visual rhythm spacing, and subtle polish.

**Architecture:** Create dedicated spacing constants file + enhance typography with message-specific styles + apply visual rhythm to screens + polish buttons and cards.

**Tech Stack:** Flutter, Google Fonts (already integrated), Riverpod

---

## File Structure

```
lib/core/
├── constants/
│   └── app_spacing.dart          # NEW: Spacing constants with visual rhythm
├── theme/
│   ├── app_typography.dart       # MODIFY: Add messageBody, refine hierarchy
│   ├── app_radius.dart           # MODIFY: Add subtle radius for cards
│   └── app_theme.dart            # MODIFY: Apply spacing and typography
lib/presentation/
├── screens/
│   ├── home_screen.dart          # MODIFY: Apply new spacing rhythm
│   ├── receive_screen.dart       # MODIFY: Apply typography + spacing
│   ├── write_screen.dart         # MODIFY: Apply spacing
│   └── onboarding_screen.dart    # MODIFY: Apply spacing
└── widgets/
    ├── kind_button.dart          # MODIFY: Add press animation
    └── kind_card.dart            # MODIFY: Refine design
```

---

## Task 1: Create Spacing Constants

**Files:**
- Create: `lib/core/constants/app_spacing.dart`

- [ ] **Step 1: Create app_spacing.dart with visual rhythm scale**

```dart
import 'package:flutter/material.dart';

/// Échelle d'espacement avec rythme visuel intentionnel.
///Inspire: rhythm-based spacing pour une hiérarchie visuelle naturelle.
class AppSpacing {
  AppSpacing._();

  // Petit espacement - éléments très liés
  static const double xxs = 4;
  static const double xs = 8;

  // Espacement moyen - dans un composant
  static const double sm = 12;
  static const double md = 20;

  // Grand espacement - entre sections
  static const double lg = 32;
  static const double xl = 48;

  // Respiration écran
  static const double xxl = 64;

  // Raccourcis EdgeInsets
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: xl,
  );

  static const EdgeInsets cardPadding = EdgeInsets.all(md);

  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/core/constants/app_spacing.dart
git commit -m "feat: add visual rhythm spacing constants"
```

---

## Task 2: Enhance Typography

**Files:**
- Modify: `lib/core/theme/app_typography.dart`

- [ ] **Step 1: Add messageBody and refine existing styles**

```dart
// Add to AppTypography class:

/// Style pour les messages reçus - expérience de lecture élégante
static TextStyle get messageBody => GoogleFonts.merriweather(
  fontSize: 17,
  fontWeight: FontWeight.w400,
  height: 1.85,
  letterSpacing: 0.2,
);

/// Version italique pour les citations courtes
static TextStyle get messageQuote => GoogleFonts.merriweather(
  fontSize: 17,
  fontWeight: FontWeight.w400,
  height: 1.85,
  letterSpacing: 0.2,
  fontStyle: FontStyle.italic,
);

// Refine bodyLarge with more breathing room
static TextStyle get bodyLarge => GoogleFonts.inter(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  height: 1.6, // was 1.5
);

// Refine bodyMedium
static TextStyle get bodyMedium => GoogleFonts.inter(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  height: 1.6, // was 1.5
  letterSpacing: 0.1,
);

// Add caption style with muted color
static TextStyle caption(Color color) => GoogleFonts.inter(
  fontSize: 12,
  fontWeight: FontWeight.w400,
  height: 1.4,
  letterSpacing: 0.3,
  color: color,
);
```

- [ ] **Step 2: Commit**

```bash
git add lib/core/theme/app_typography.dart
git commit -m "feat: enhance typography with message styles and better hierarchy"
```

---

## Task 3: Refine Radius for Cards

**Files:**
- Modify: `lib/core/theme/app_radius.dart`

- [ ] **Step 1: Add card-specific radius**

```dart
// Add new constant:
static const double card = 20.0;

// Add getter:
static BorderRadius get cardRadius => BorderRadius.circular(card);
```

- [ ] **Step 2: Commit**

```bash
git add lib/core/theme/app_radius.dart
git commit -m "feat: add card-specific radius for refined design"
```

---

## Task 4: Apply Visual Rhythm to Home Screen

**Files:**
- Modify: `lib/presentation/screens/home_screen.dart`

- [ ] **Step 1: Update imports and apply spacing**

Add import:
```dart
import 'package:kind_app/core/constants/app_spacing.dart';
```

Update `_buildContent` method - replace hardcoded values with spacing constants:
- Top padding: 24 → xl (48)
- Card internal padding: 28 → md (20)
- Card to button: use xl (48)
- Button to footer text: use sm (12)
- Bottom padding: 32 → xl (48)

```dart
// Example changes:
child: Padding(
  padding: const EdgeInsets.symmetric(
    horizontal: AppSpacing.lg, // was 24
    vertical: AppSpacing.xl,   // was 24
  ),
  child: Column(
    children: [
      // Card
      Container(
        padding: const EdgeInsets.all(AppSpacing.md), // was 28
        // ...
      ),

      const SizedBox(height: AppSpacing.xl), // was Spacer/SizedBox(48)

      // Button

      const SizedBox(height: AppSpacing.sm), // was 12
```

- [ ] **Step 2: Run flutter analyze**

```bash
flutter analyze lib/presentation/screens/home_screen.dart
```
Expected: No issues

- [ ] **Step 3: Commit**

```bash
git add lib/presentation/screens/home_screen.dart
git commit -m "feat: apply visual rhythm spacing to home screen"
```

---

## Task 5: Apply Typography + Spacing to Receive Screen

**Files:**
- Modify: `lib/presentation/screens/receive_screen.dart`

- [ ] **Step 1: Update imports and apply changes**

Add import:
```dart
import 'package:kind_app/core/constants/app_spacing.dart';
```

Update `_buildMessageCard`:
- Use AppSpacing.md (20) for card padding instead of 32
- Use messageQuote style for message content
- Adjust spacing between elements

Update `_buildInitialState`:
- Use AppSpacing constants for padding and gaps

- [ ] **Step 2: Run flutter analyze**

```bash
flutter analyze lib/presentation/screens/receive_screen.dart
```
Expected: No issues

- [ ] **Step 3: Commit**

```bash
git add lib/presentation/screens/receive_screen.dart
git commit -m "feat: apply typography and spacing to receive screen"
```

---

## Task 6: Apply Spacing to Write Screen

**Files:**
- Modify: `lib/presentation/screens/write_screen.dart`

- [ ] **Step 1: Review and apply spacing**

Check current spacing and apply AppSpacing constants:
- Use AppSpacing.lg for horizontal padding
- Use AppSpacing.md for internal component spacing
- Use AppSpacing.xl for section breaks

- [ ] **Step 2: Run flutter analyze**

```bash
flutter analyze lib/presentation/screens/write_screen.dart
```
Expected: No issues

- [ ] **Step 3: Commit**

```bash
git add lib/presentation/screens/write_screen.dart
git commit -m "feat: apply spacing to write screen"
```

---

## Task 7: Apply Spacing to Onboarding Screen

**Files:**
- Modify: `lib/presentation/screens/onboarding_screen.dart`

- [ ] **Step 1: Apply spacing constants**

Use AppSpacing constants:
- Replace hardcoded 16, 24, 32 values
- Use AppSpacing.md, lg, xl appropriately

- [ ] **Step 2: Run flutter analyze**

```bash
flutter analyze lib/presentation/screens/onboarding_screen.dart
```
Expected: No issues

- [ ] **Step 3: Commit**

```bash
git add lib/presentation/screens/onboarding_screen.dart
git commit -m "feat: apply spacing to onboarding screen"
```

---

## Task 8: Polish KindButton with Press Animation

**Files:**
- Modify: `lib/presentation/widgets/kind_button.dart`

- [ ] **Step 1: Add StatefulWidget wrapper for animation**

The button needs to be stateful to handle press animation:

```dart
class KindButton extends StatefulWidget {
  // ... existing parameters

  @override
  State<KindButton> createState() => _KindButtonState();
}

class _KindButtonState extends State<KindButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) => _controller.forward();
  void _onTapUp(TapUpDetails details) => _controller.reverse();
  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onPressed != null ? _onTapDown : null,
      onTapUp: widget.onPressed != null ? _onTapUp : null,
      onTapCancel: widget.onPressed != null ? _onTapCancel : null,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: _buildElevated(context), // or _buildOutlined
      ),
    );
  }
}
```

- [ ] **Step 2: Run flutter analyze**

```bash
flutter analyze lib/presentation/widgets/kind_button.dart
```
Expected: No issues

- [ ] **Step 3: Commit**

```bash
git add lib/presentation/widgets/kind_button.dart
git commit -m "feat: add press animation to KindButton"
```

---

## Task 9: Refine KindCard

**Files:**
- Modify: `lib/presentation/widgets/kind_card.dart`

- [ ] **Step 1: Review and refine**

Check current implementation:
- Use AppSpacing.md for internal padding
- Use AppRadius.cardRadius for border radius
- Consider subtle border instead of shadow

- [ ] **Step 2: Run flutter analyze**

```bash
flutter analyze lib/presentation/widgets/kind_card.dart
```
Expected: No issues

- [ ] **Step 3: Commit**

```bash
git add lib/presentation/widgets/kind_card.dart
git commit -m "feat: refine KindCard design with spacing constants"
```

---

## Final Verification

- [ ] Run full static analysis

```bash
flutter analyze
```
Expected: No issues found

- [ ] Check all success criteria from spec

- [ ] Final commit with all changes

```bash
git add -A
git commit -m "feat: professional UI/ux improvements - typography, spacing, animations"
```

---

## Success Criteria

- [x] Typography creates clear hierarchy and elegant reading experience
- [x] Spacing has intentional rhythm (not uniform)
- [x] App feels more professional without losing minimal essence
- [x] Both light and dark modes benefit from improvements
- [x] `flutter analyze` passes with 0 issues