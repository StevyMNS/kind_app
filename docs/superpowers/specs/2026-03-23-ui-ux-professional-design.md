# UI/UX Professional Design - Specification

## Overview

Improve the One Kind Message app UI/UX to achieve a more professional, polished look while maintaining the minimalist, contemplative essence of the app.

## Approved Design Direction

- **Approach**: Minimaliste Raffiné (Minimalist Elegant)
- **Focus**: Subtle details, breathing room, refined typography
- **Philosophy**: Less is more — every element should have purpose and space

---

## 1. Typography Improvements

### 1.1 Message Font (Messages Received)

**Current state**: Default system font
**Goal**: Elegant, book-like reading experience

**Changes:**
- Use a refined serif font for all message content (e.g., Merriweather, Playfair Display, or similar)
- Increase line-height to 1.8-2.0 for comfortable reading
- Add subtle letter-spacing (0.2-0.3px)
- Font size: 16-18sp for body, with option to adjust

**Implementation:**
```dart
// Example approach in app_typography.dart
static TextStyle messageBody = TextStyle(
  fontFamily: 'Merriweather', // or Google Fonts loaded
  fontSize: 17,
  height: 1.85,
  letterSpacing: 0.2,
  fontStyle: FontStyle.italic,
);
```

### 1.2 Global Hierarchy

**Current state**: Basic text styles
**Goal**: Clear visual hierarchy with refined typography

**Changes:**
- **Display/Headlines**: Larger, more confident (24-32sp)
- **Body text**: More breathing room, better contrast
- **Labels/Captions**: Smaller, more discrete, muted colors
- **Buttons**: Clear, readable, consistent weight

**Scale proposal:**
```
Display:   32sp, weight 700, letter-spacing: -0.5px
Headline:  24sp, weight 600, letter-spacing: -0.3px
Title:     20sp, weight 600
Body:      16sp, weight 400, height 1.6
Label:     14sp, weight 500, letter-spacing: 0.5px
Caption:   12sp, weight 400, muted color
```

---

## 2. Visual Rhythm Spacing

### 2.1 Principle

**Goal**: Create intentional, varied spacing that guides the eye and creates visual interest.

### 2.2 Spacing Scale

Introduce a more nuanced spacing scale:

```dart
// Current (basic)
static const double xs = 4;
static const double sm = 8;
static const double md = 16;
static const double lg = 24;
static const double xl = 32;

// Proposed (refined with rhythm)
static const double xxs = 4;   // Between very related elements
static const double xs = 8;     // Icon + label
static const double sm = 12;    // Within component
static const double md = 20;    // Standard component padding
static const double lg = 32;    // Between related sections
static const double xl = 48;     // Major section breaks
static const double xxl = 64;   // Screen-level breathing
```

### 2.3 Application Rules

| Context | Spacing | Example |
|---------|---------|---------|
| Icon + label in button | `xs` (8px) | Icon and text together |
| Title + subtitle | `sm` (12px) | Related text elements |
| Card internal padding | `md` (20-24px) | Content inside cards |
| Between cards | `lg` (32px) | Separate cards |
| Section breaks | `xl` (48px) | Major visual sections |
| Screen top/bottom | `xxl` (64px) | SafeArea breathing |

### 2.4 Visual Rhythm Patterns

**Home Screen example:**
- Top: 48px padding (large breathing)
- Quote card: 32px internal padding
- Card to button: 48px (emphasis)
- Button to footer text: 12px (subtle connection)

**This creates**: Large → Medium → Large → Small pattern

---

## 3. Additional Refinements

### 3.1 Typography Notes

**Italic usage**: Apply `FontStyle.italic` sparingly - ideal for short quotes/verses, but not for longer message body. Consider a toggle or default to regular style with italic as accent.

**Accessibility**: Support `MediaQuery.textScaleFactor` - avoid fixed font sizes that break with system accessibility settings.

### 3.2 Card Design

- Subtle border radius (16-20px)
- Very soft shadow (or none, relying on subtle borders)
- Clean internal padding (20-24px)
- Consider subtle border instead of shadow for lighter feel

### 3.2 Button Refinement

- Consistent height (48-56px)
- Clear tap states
- Subtle press animation (scale 0.98)
- Loading state with subtle spinner

### 3.3 Iconography

- Consistent stroke width (2px)
- Rounded corners
- Same visual weight throughout

### 3.4 Animations

- Duration: 200-400ms (not too slow)
- Curve: `Curves.easeOutCubic` for natural feel
- Page transitions: Fade + subtle slide
- Micro-interactions: Button press, card tap

---

## 4. Implementation Priority

### Phase 1: Foundation (High Impact)
1. Update spacing scale in `app_constants.dart`
2. Enhance typography hierarchy in `app_typography.dart`
3. Apply new spacing to main screens

### Phase 2: Polish (Medium Impact)
4. Refine card designs
5. Improve button states and animations
6. Add subtle visual enhancements

### Phase 3: Finishing Touches (Low Impact, High Feel)
7. Icon refinements
8. Transition animations
9. Dark mode polish

---

## Files to Modify

- `lib/core/theme/app_typography.dart` — Typography scale
- `lib/core/constants/app_constants.dart` — Spacing scale
- `lib/presentation/screens/home_screen.dart` — Apply spacing
- `lib/presentation/screens/receive_screen.dart` — Apply typography + spacing
- `lib/presentation/screens/write_screen.dart` — Apply spacing
- `lib/presentation/screens/onboarding_screen.dart` — Apply typography
- `lib/presentation/widgets/kind_button.dart` — Polish
- `lib/presentation/widgets/kind_card.dart` — Refine design

---

## Success Criteria

### 3.3 Dark Mode Refinements

For dark mode (existing `app_colors.dart`):
- Surface: `#121826` (already defined as `darkSurface`)
- Card: `#1C2538` (already defined as `darkCard`)
- Text: `#E8EDF3` (already defined as `darkText`)
- Keep contrast ratios accessible (4.5:1 minimum)
- Consider subtle warm tint for dark backgrounds to reduce eye strain

### 3.4 Animation Guidelines

- Duration: 200-400ms for micro-interactions
- Duration: 300-500ms for page transitions
- Use `Curves.easeOutCubic` for natural feel
- Button press: subtle scale (0.98) with 100ms duration

---

## Success Criteria

- [ ] Typography creates clear hierarchy and elegant reading experience
- [ ] Spacing has intentional rhythm (not uniform)
- [ ] App feels more professional without losing minimal essence
- [ ] Both light and dark modes benefit from improvements
- [ ] `flutter analyze` passes with 0 issues