---
name: حياة المسلم (Muslim-Life)
description: Calm Arabic daily-worship UI — Quiet Mosque Courtyard with content-first Mushaf accents
colors:
  brand: "#0FAFAF"
  brand-dark: "#0A8A8A"
  surface: "#FAFBFC"
  surface-variant: "#F3F4F6"
  on-surface: "#1F2937"
  on-surface-muted: "#6B7280"
  error: "#B91C1C"
  white: "#FFFFFF"
  legacy-main: "#0FAFAF"
typography:
  display:
    fontFamily: "ArbFONTS"
    fontSize: "22px"
    fontWeight: 700
    lineHeight: 1.3
  headline:
    fontFamily: "ArbFONTS"
    fontSize: "18px"
    fontWeight: 600
    lineHeight: 1.35
  title:
    fontFamily: "ArbFONTS"
    fontSize: "16px"
    fontWeight: 600
    lineHeight: 1.4
  body:
    fontFamily: "ArbFONTS"
    fontSize: "14px"
    fontWeight: 400
    lineHeight: 1.5
  label:
    fontFamily: "ArbFONTS"
    fontSize: "12px"
    fontWeight: 500
    lineHeight: 1.35
rounded:
  sm: "8px"
  md: "12px"
  lg: "16px"
spacing:
  xs: "4px"
  sm: "8px"
  md: "16px"
  lg: "24px"
  xl: "32px"
components:
  button-primary:
    backgroundColor: "{colors.brand}"
    textColor: "{colors.white}"
    rounded: "{rounded.md}"
    padding: "16px 24px"
  button-outlined:
    backgroundColor: "{colors.white}"
    textColor: "{colors.brand}"
    rounded: "{rounded.md}"
    padding: "16px 24px"
  card:
    backgroundColor: "{colors.white}"
    textColor: "{colors.on-surface}"
    rounded: "{rounded.md}"
    padding: "8px"
  app-bar:
    backgroundColor: "{colors.brand}"
    textColor: "{colors.white}"
    typography: "{typography.headline}"
  section-header:
    textColor: "{colors.brand-dark}"
    typography: "{typography.title}"
  snackbar-error:
    backgroundColor: "{colors.error}"
    textColor: "{colors.white}"
    rounded: "{rounded.sm}"
---

# Design System: حياة المسلم (Muslim-Life)

## Overview

**Creative North Star: "The Quiet Mosque Courtyard"** (primary ~70%), with **Open Mushaf** content-first reading (~20%) and a light **Teal Minaret** brand chrome (~10%).

حياة المسلم should feel like stepping into a calm courtyard: soft light surfaces, clear paths to prayer / azkar / Quran, and teal used as a respectful accent—not a loud theme skin. Worship content (Arabic text, prayer countdown, dhikr audio controls) leads; chrome stays quiet. App bars and primary actions may carry teal (Minaret 10%) so the brand remains recognizable to Tasbeeh switchers without recreating Tasbeeh’s denser chrome.

Built for **Operate** mode on adaptive Flutter (iOS + Android), Arabic RTL. Tokens live in `lib/core/theme/app_tokens.dart` + `buildAppTheme()`; shared widgets in `lib/core/widgets/dls/`.

**Key Characteristics:**
- Soft gray-white courtyard surfaces, white cards
- Teal brand reserved for app bar, primary actions, section accents
- ArbFONTS everywhere; generous body line-height for Arabic
- Low elevation (≈1) — depth from surface contrast, not heavy shadows
- Shared DLS primitives: AppScaffold, AppCard, SectionHeader, EmptyState, showAppSnackBar

## Colors

Courtyard neutrals dominate; teal is the single accent voice.

### Primary
- **Courtyard Teal** (#0FAFAF / `AppTokens.brand`): App bars, primary buttons, selected accents, prayer cue highlights. Alias `kMainColor` / `legacy-main` must stay in sync.
- **Deep Courtyard Teal** (#0A8A8A / `AppTokens.brandDark`): Status bar, section titles, pressed/emphasis brand moments.

### Neutral
- **Courtyard Mist** (#FAFBFC / `surface`): Scaffold background.
- **Courtyard Stone** (#F3F4F6 / `surfaceVariant`): Subtle grouped backgrounds.
- **Ink** (#1F2937 / `onSurface`): Primary Arabic text.
- **Quiet Ink** (#6B7280 / `onSurfaceMuted`): Secondary labels, empty-state copy.
- **White** (#FFFFFF): Cards, sheets.
- **Error Clay** (#B91C1C / `error`): Destructive / audio failure snackbars.

**The One Teal Rule.** Teal is the only chromatic accent. Do not introduce purple gradients, gold-as-primary, or multi-accent rainbows from leftover Tasbeeh screens.

**The Courtyard Field Rule.** ≥70% of any screen should read as surface/white; teal occupies sparse brand moments (app bar, FABs, key CTAs, prayer accent).

## Typography

**Display / Body / Label Font:** ArbFONTS (Arabic-first; system fallback only if font missing)

**Character:** Clear, respectful, readable at prayer-time glance and long azkar/Quran sessions. Prefer weight and size for hierarchy—not color shouting.

### Hierarchy
- **Display** (bold, ~22): Rare — onboarding welcome, about title.
- **Headline** (semi-bold, 18): App bar titles.
- **Title** (semi-bold, 16): Section headers, card titles (`SectionHeader` uses brand-dark).
- **Body** (regular, 14, height 1.5): Azkar lines, list content, descriptions.
- **Label** (medium, 12): Meta, muted helper text.

**The Reading Breath Rule.** Body Arabic keeps ~1.5 line-height; never crush Quran/azkar into tight leading for density.

## Layout

RTL `Directionality` is mandatory on scaffolds (`AppScaffold`). Spacing rhythm: 4 / 8 / 16 / 24 / 32 (`spaceXs`→`spaceXl`). Cards stack with small bottom margin (`spaceSm`). Home: prayer card above a feature grid — calm hierarchy, not a dense icon dump. Prefer padding from tokens over magic numbers.

**The Path Rule.** One primary worship path per screen (play dhikr, next prayer, open surah); secondary actions stay visually quieter.

## Elevation & Depth

Mostly flat courtyard: cards use elevation **1** (`elevationCard`). Prefer white card on mist surface over stacked shadows. No heavy Material 6+ elevation.

**The Soft Lift Rule.** Depth = surface contrast (mist vs white) first; shadow only as a whisper on cards.

## Shapes

Gently curved — 8 / 12 / 16 (`radiusSm/Md/Lg`). Cards and buttons default to **12**. Snackbars use **8**. Avoid sharp 0-radius tool chrome and oversized 24+ “pill everything” looks.

## Components

### Buttons
- **Shape:** 12px (`radiusMd`)
- **Primary:** Brand teal fill, white label, padding 16×24
- **Outlined:** Brand stroke + brand label on white
- **Focus / feedback:** Rely on Material 3 theme; keep teal identity

### Cards / Containers (`AppCard`)
- White surface, radius 12, elevation 1, padding default 8; optional `onTap` ink
- Use for menu tiles, content blocks, settings groups

### App bar (`AppScaffold` + theme)
- Teal bar, white centered title (ArbFONTS 18 w600), zero elevation
- Status bar uses brand-dark

### Section headers (`SectionHeader`)
- Brand-dark title; optional muted subtitle

### Empty / error
- `EmptyState`: muted icon + centered body
- `showAppSnackBar`: floating; error uses Error Clay — **required for audio/load failures** (no silent fails)

### Navigation
- Home grid of feature cards into pushed routes; keep icon+label tiles consistent via tokens (replace one-off colors)

### Signature: Prayer card
- Courtyard calm: next-prayer countdown and location on a clear card; teal accent sparingly (countdown / active prayer), not a full teal slab unless needed for glanceability

## Do's and Don'ts

### Do:
- **Do** use `AppTokens` + `buildAppTheme()` + `lib/core/widgets/dls/*` for new/changed screens.
- **Do** keep Arabic RTL and ArbFONTS on user-facing UI.
- **Do** surface audio/location failures with `showAppSnackBar` (Arabic).
- **Do** treat teal as rare brand chrome; let content breathe (Mushaf 20%).
- **Do** keep website-only contact chrome consistent with PRODUCT.md.

### Don't:
- **Don't** paste Tasbeeh screen chrome wholesale (dense multi-color headers, leftover author contacts).
- **Don't** invent a second accent (purple, neon, gold-primary).
- **Don't** hard-code random greens/teals that drift from `#0FAFAF` / `#0A8A8A`.
- **Don't** ship screens that bypass DLS scaffolds when an equivalent exists.
- **Don't** fail audio silently — courtyard calm is not silence-on-error.
