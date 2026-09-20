# Product

<!-- impeccable:product-schema 1 -->

## Platform

adaptive

## Users

Arabic-speaking Muslims who used **Tasbeeh-Al-Muslim** and want the **same worship toolkit** under a cleaner **حياة المسلم (Muslim-Life)** brand. Primary job when opening the app: complete daily Islamic routines—azkar/hisn, sibha, prayer times, qibla, Quran reading/listening, and scheduled dhikr—without learning a new feature set.

## Product Purpose

حياة المسلم is a Flutter daily-worship companion that ports Tasbeeh’s capabilities into a calmer, branded Muslim-Life experience. Success means: a Tasbeeh user can do every familiar job here, audio and notifications work reliably, and the UI feels like one coherent product—not a patchwork of screens.

## Positioning

**Same features as Tasbeeh-Al-Muslim, cleaner Muslim-Life brand**—not a reduced clone and not a rebrand-only shell. The durable claim is continuity of worship workflows plus a distinct visual/product identity (teal حياة المسلم, ArbFONTS, website-only contact).

## Operating Context

- Mobile, Arabic RTL first (iOS and Android).
- Offline-heavy content: local SQLite catalogs, bundled dhikr mp3s, offline tafsir where shipped.
- Prayer times / location / qibla depend on device location and network when needed.
- Home hub: prayer card + full feature grid; deep links into azkar, Quran, sibha, qibla, dhikr audio/schedule, favorites, about.
- Reference implementation for structure/features/data: **Tasbeeh-Al-Muslim** (locked; do not restructure Tasbeeh to “fix” Muslim-Life).

## Capabilities and Constraints

**Capabilities (shipped / in PR):** azkar & Hisn Muslim, sibha, prayer times, qibla, Quran reader + streamed audio, dhikr audio & schedule, favorites, about/update, home widgets (where enabled).

**Constraints:**
- Feature behavior should stay at parity with Tasbeeh unless the user explicitly narrows scope.
- Bundle / application id continuity: `com.anany.azkar`; display name حياة المسلم.
- Contact: website **https://www.abdoanany.com/** only — leave email / phone / WhatsApp empty; do not copy leftover Tasbeeh author contacts.
- Brand teal rooted in `0xff0fafaf` / `kMainColor`; Arabic font family **ArbFONTS**.
- No secrets or service-account keys in the repo.
- Open: App Store numeric id in about/contact when available.

## Brand Commitments

- Name: **حياة المسلم** (Muslim-Life).
- Visual identity direction (binding): cleaner brand than Tasbeeh — teal palette, ArbFONTS, website-only contact (`abdoanany.com`).
- Voice: brief, respectful Arabic UI; avoid English-primary chrome on user-facing strings.

## Evidence on Hand

- App copy / config: `lib/core/config/app_contact.dart`, onboarding “مرحباً في حياة المسلم”.
- Partial DLS already in tree: `lib/core/theme/app_theme.dart`, `app_tokens.dart`, `lib/core/widgets/dls/*` (not yet consistently applied — user reports UI still inconsistent).
- Audio work in progress on PR branch `cursor/tasbeeh-upgrade-muslim-life-cca1` (dhikr `just_audio`, Android raw sync); user still reports silent/broken audio — treat as unresolved until proven.
- Feature reference: local/GitHub **Tasbeeh-Al-Muslim**.
- Do **not** fabricate testimonials, store rankings, or contact channels that are empty in config.

## Product Principles

1. **Parity first** — a Tasbeeh switcher must not lose a daily ritual.
2. **One brand, one system** — shared tokens and components; no one-off screen languages.
3. **Worship clarity** — hierarchy favors prayer, azkar, and Quran over chrome.
4. **Honest feedback** — audio/location failures surface in Arabic; never fail silently.
5. **Respect the lock** — Tasbeeh remains the feature/data reference; Muslim-Life owns the brand experience.

## Accessibility & Inclusion

Arabic RTL is the default. Prefer readable type sizes for continuous Quran/azkar reading; support system text scaling where Flutter theme allows. No separate accessibility standard was mandated beyond usable mobile worship UX.
