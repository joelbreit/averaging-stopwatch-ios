# Averaging Stopwatch - Design System

A minimal, focused design inspired by professional timing equipment and analog instrumentation.

## Design Philosophy

**"Precision Without Distraction"**

The app should feel like a trusted tool—reliable, precise, and calm. Every element serves the core purpose: measuring time accurately and presenting data clearly.

## Color Palette

### Primary Colors

| Name | Light Mode | Dark Mode | Usage |
|------|------------|-----------|-------|
| **Background** | `#FAFAFA` | `#0A0A0A` | Main canvas |
| **Surface** | `#FFFFFF` | `#1C1C1E` | Cards, list rows |
| **Primary Text** | `#1A1A1A` | `#F5F5F5` | Timer display, headings |
| **Secondary Text** | `#6B6B6B` | `#8E8E93` | Labels, cumulative times |

### Accent Colors

| Name | Hex | Usage |
|------|-----|-------|
| **Active Green** | `#34C759` | Start button, fastest lap |
| **Stop Red** | `#FF3B30` | Stop button, slowest lap |
| **Action Blue** | `#007AFF` | Complete/Done button, export |
| **Neutral Gray** | `#8E8E93` | Lap button, reset button |

### Gradients (Optional Enhancement)

```
Timer Background Glow (when running):
  Radial gradient from center
  Light: rgba(52, 199, 89, 0.05) → transparent
  Dark: rgba(52, 199, 89, 0.08) → transparent
```

## Typography

### Font Stack

**Primary**: SF Pro (system default)
- Leverages Apple's optimized rendering
- Excellent monospaced digit support

### Type Scale

| Element | Weight | Size | Style |
|---------|--------|------|-------|
| **Main Timer** | Ultralight | 72pt | Monospaced digits |
| **Current Lap Timer** | Regular | 20pt | Monospaced digits |
| **Statistics** | Medium | 17pt | Monospaced digits |
| **Labels** | Regular | 15pt | Default |
| **Lap Number** | Medium | 17pt | Default |
| **Lap Times** | Regular | 17pt | Monospaced digits |

### Timer Display Format

```
00:00.00
├─ Minutes (2 digits, leading zero)
├─ Colon separator
├─ Seconds (2 digits, leading zero)
├─ Decimal point
└─ Hundredths (2 digits)
```

## Layout & Spacing

### Grid System

- Base unit: **8pt**
- Content margins: **16pt** (2 units)
- Section spacing: **24pt** (3 units)
- Component spacing: **12pt** (1.5 units)

### Screen Hierarchy

```
┌─────────────────────────────────┐
│         Navigation Bar          │  44pt
├─────────────────────────────────┤
│                                 │
│         Main Timer              │  120pt
│          00:00.00               │
│                                 │
│       Current Lap Label         │  32pt
│        Lap 1: 00:00.00          │
│                                 │
├─────────────────────────────────┤
│        Statistics Row           │  48pt
│   Avg Lap: 00:00   Overall: ... │
├─────────────────────────────────┤
│                                 │
│      ○        ○        ○        │  100pt
│     Lap    Start    Done        │
│                                 │
├─────────────────────────────────┤
│                                 │
│          Lap List               │  Flexible
│     (scrollable, fills rest)    │
│                                 │
└─────────────────────────────────┘
```

## Components

### Control Buttons

**Shape**: Circle (80pt diameter)
**Border**: None
**Shadow**: Subtle on light mode only

```
┌──────────────────────────────────────────────────────┐
│  State          Background              Text Color   │
├──────────────────────────────────────────────────────┤
│  Start          Green 15% opacity       Green        │
│  Stop           Red 15% opacity         Red          │
│  Lap            Gray 10% opacity        Primary      │
│  Reset          Gray 10% opacity        Primary      │
│  Done           Blue 15% opacity        Blue         │
│  Disabled       Gray 5% opacity         Gray 40%     │
└──────────────────────────────────────────────────────┘
```

**Touch Feedback**: Scale to 95% on press, spring back

### Lap Row

```
┌─────────────────────────────────────────────────────┐
│  Lap 1          00:32.45              00:32.45      │
│  ├─ Label       ├─ Lap Duration       └─ Cumulative │
│  │  Secondary   │  Primary/Accent        Secondary  │
│  │  Left align  │  Center                Right      │
└─────────────────────────────────────────────────────┘

Min/Max States:
  Fastest → All text in Active Green
  Slowest → All text in Stop Red
```

### Statistics Bar

```
┌─────────────────────────────────────────────────────┐
│     Avg Lap: 00:32.15    │    Overall: 00:31.89     │
│     └─ Label: Secondary  │    └─ Value: Primary     │
└─────────────────────────────────────────────────────┘
```

## Motion & Animation

### Principles

- **Purposeful**: Animation indicates state change
- **Quick**: 200-300ms duration max
- **Subtle**: No bouncing or dramatic effects

### Specifications

| Action | Animation | Duration | Curve |
|--------|-----------|----------|-------|
| Button press | Scale to 0.95 | 100ms | ease-out |
| Button release | Scale to 1.0 | 200ms | spring (damping: 0.6) |
| Lap row insert | Slide from top + fade | 250ms | ease-out |
| Timer start | Subtle green pulse on display | 300ms | ease-in-out |
| Timer stop | No animation (immediate feedback) | - | - |
| Reset | Fade out laps sequentially | 150ms each | ease-out |

### Timer Display

- No animation on digit changes (instant update for precision feel)
- Optional: Subtle colon blink every second when running

## Iconography

Use SF Symbols for consistency:

| Action | Symbol | Weight |
|--------|--------|--------|
| Export/Share | `square.and.arrow.up` | Regular |
| Timer (app icon concept) | `stopwatch` | - |

## Dark Mode Considerations

- Reduce pure white usage—use `#F5F5F5` for primary text
- Increase accent color saturation slightly for visibility
- Surface colors should have subtle elevation (lighter = higher)
- Green/Red accents remain consistent across modes

## Accessibility

- Minimum touch target: 44pt × 44pt
- Timer contrast ratio: 7:1 minimum (AAA)
- Support Dynamic Type for labels (not main timer)
- VoiceOver labels for all controls
- Reduce Motion: Disable all animations except essential feedback

## Future Enhancements

### Visual Polish
- Subtle texture or noise on background (very low opacity)
- Thin separator lines between lap rows (1pt, 5% opacity)
- Haptic feedback on button press and lap recording

### Advanced Features
- Customizable accent color
- Optional analog-style timer face
- Widget design matching main app aesthetic

---

## Quick Reference

```swift
// Colors
static let activeGreen = Color(hex: "34C759")
static let stopRed = Color(hex: "FF3B30")
static let actionBlue = Color(hex: "007AFF")

// Typography
.font(.system(size: 72, weight: .ultraLight, design: .monospaced))  // Main timer
.font(.system(size: 17, weight: .medium))                           // Lap labels
.monospacedDigit()                                                  // All numbers

// Spacing
let baseUnit: CGFloat = 8
let contentMargin: CGFloat = 16
let sectionSpacing: CGFloat = 24

// Animation
.animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
```
