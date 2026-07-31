# Vocabik — Design System

> **Vocabik** turns YouTube videos into interactive fill-in-the-blank English exercises.
> Watch a video, the player pauses at key moments, and you type or pick the missing
> word from the transcript. Structured around CEFR levels (A1–C1), a curated video
> library, a freemium subscription, and a gamification layer that builds a daily habit.

- **Domain:** vocabik.com
- **Primary market:** Vietnam & Southeast Asia (~80% mobile)
- **Revenue:** Freemium — Free (5 exercises/day, curated library) · Premium ($5/mo or $40/yr — unlimited, any YouTube URL, all features)
- **Positioning:** sits between an entertainment app and a learning tool. Premium, dark-by-default, music-native — but clear and trustworthy.

## Sources

This system was authored from the **Vocabik Product Description brief** (2026-06-15), derived from
`IDEA-20260507-001 development.md` and `pages-inventory.md`. No codebase or Figma file was provided —
the visual language below is an original interpretation of the written brand direction. Colors,
typography, and theme behaviour follow the brief's explicit specs; component and screen designs are
new work grounded in those foundations. **If a codebase or Figma exists, re-attach it so screens can
be matched pixel-for-pixel.**

---

## CONTENT FUNDAMENTALS — how Vocabik writes

**Voice:** Smart, modern, energetic, music-native. A motivating coach, never a stern teacher.
Not childish, not corporate.

**Person:** Second person — talk to the learner as **"you"** ("You're on a 5-day streak", "Practice
any YouTube video"). The product refers to itself by name ("Vocabik") rarely, mostly in the logo and
Score Card. First person ("I") is never used by the UI.

**Casing:** Sentence case everywhere — buttons, headings, labels ("Start exercise", "Back to library",
not "Start Exercise"). ALL-CAPS is reserved for tiny eyebrow labels and badge text (level codes "A1",
status chips "NEW", "PREMIUM") with wide letter-spacing.

**Tone by moment** (emotional register is core):
- **Correct answer** → celebratory, warm. "Nice!" / "Exactly." Green flash + chime.
- **Wrong answer** → gentle, never punitive. "Almost — it was *between*." Soft red shake, reveal the answer.
- **Level-up / badge** → genuine excitement. "Badge unlocked: Pop Star 🎵" Pop + glow.
- **Premium upsell** → aspirational, not pressuring. "Unlock any YouTube video." Purple, subtle, dismissible.
- **Daily limit** → motivating, not punishing. "You've done all 5 today! More unlock at midnight." Countdown + clear upgrade path.

**Numbers & social proof:** Compact and concrete — "1.2k practiced", "2 of 5 today", "🔥 5 days",
"⚡ 1,240 XP", "Save 33%". Always meaningful, never decorative stat-slop.

**Microcopy patterns:**
- CTAs are verbs: "Start exercise", "Try version 2", "Accept the challenge", "Connect".
- Empty states are encouraging + actionable: "No saved words yet — tap the bookmark on any blank to start your notebook."
- Locks explain the path: "Unlock with Premium" / "Complete version 1 to unlock".

**Emoji:** Used deliberately as *functional iconography* in a small, fixed set — never as decoration.
Gamification: 🔥 streak, ⚡ XP. Community reactions: 💪 Challenging · 🎵 Enjoyable · 📚 Vocabulary-rich.
Hints: 💡. Do not introduce new emoji outside these roles.

---

## VISUAL FOUNDATIONS

**Overall feel:** A dark, premium "music night" canvas where vivid YouTube thumbnails pop. The dark
surface is the stage; video artwork is the star. Rounded, friendly geometry (Nunito + generous radii)
keeps it approachable rather than clinical.

**Themes:** Dual-theme via a full CSS custom-property layer. **Dark ("Music Night") is default**;
**Light ("Study Day")** is a user toggle (`[data-theme="light"]`). Every component is theme-aware —
no hardcoded colors anywhere.

**Color:**
- **Dark** — near-black blue-tinted surfaces (`--surface-base #0D0D1A`, `--surface-card #1A1A2E`),
  **electric teal `#00E5CC`** as the single primary action color, **purple `#A855F7`** reserved
  *exclusively* for Premium.
- **Light** — white / light-gray surfaces with a **deeper teal `#0891B2`** for AA contrast.
- **CEFR scale** — A1 green → A2 teal → B1 blue → B2 purple → C1 coral. Consistent, color-coded badges.
- **Feedback** — green correct, soft red wrong, amber streak/warning.
- **Genre gradients** (Score Card) — Pop pink→orange, Rap dark-teal, News navy.
- Use brand tokens; never invent ad-hoc colors.

**Typography:** Display/headings **Nunito** (extrabold/black, tight tracking, rounded warmth);
body/UI **Inter** (clean, legible); IPA phonetics **Noto Sans**. Body min 15px, transcript 17–18px
(read while watching). Big celebratory numbers (score %, XP) go up to 48–64px in Nunito black.

**Spacing & layout:** 4px base grid. Mobile-first at 375px → tablet 768 → desktop 1280+. Bottom tab
bar (56px) on mobile, top nav (64px) on desktop. 44px minimum touch targets, always.

**Corner radii:** Generous and rounded — inputs/cards 14px, video cards/panels 18px, sheets & modals
24px, chips / MC pills / badges fully pill (999px). Roundness is a brand signature.

**Cards:** Solid `--surface-card` fill, 1px `--border-subtle` hairline, `--radius-lg`, soft deep
shadow (`--shadow-md`). No colored left-border accents. Video cards lead with a 16:9 thumbnail, bottom
protection scrim for overlaid text, metadata below.

**Backgrounds:** Flat dark surfaces, not gradients — except (a) genre gradients on Score Cards,
(b) a subtle radial brand wash (`--wash-brand`) behind heroes, (c) protection scrims over thumbnails.
No noisy textures or patterns. The vividness comes from real video imagery, not background decoration.

**Elevation:** Signalled three ways on dark — deeper drop shadow, a slightly *lighter* card fill
(`--surface-card-2`), and, for celebratory/active moments, a colored **glow** (`--glow-accent`,
`--glow-premium`, `--glow-success`, `--glow-gold`).

**Transparency & blur:** Glass surfaces (`--glass-fill` + `--blur-md`) for sticky bars and the bottom
sheet header. Scrims dim the video 30% while the answer sheet is open. Modals sit over a `--surface-overlay` scrim.

**Borders:** Hairline, low-opacity white-on-dark (`--border-subtle/-default/-strong`). Focus uses a
3px teal ring (`--ring-focus`) on every interactive element.

**Imagery vibe:** Vivid, saturated, full-color YouTube thumbnails — never desaturated or grain-filtered.
They are meant to glow against the dark canvas. Locked content is the only place imagery goes greyscale.

**Motion** (purposeful, never decorative):
- Micro (hover/focus) 120–150ms · state transitions 200–300ms · spring (sheet, score card) 350–450ms
  · celebration (confetti, XP count-up) 600–1000ms.
- Signature patterns: bottom-sheet springs up (`--ease-spring`, overshoot); correct = green flash;
  wrong = horizontal shake; XP counts up from 0; badge pops in with bounce then a single glow pulse;
  confetti burst; desktop video-card hover lifts `translateY(-2px)`.
- **Hover** (desktop only, never the sole affordance): subtle lift + shadow increase, or brighten to
  `--accent-hover`. **Press:** shrink slightly (`scale(0.97)`) and deepen color (`--accent-press`).
- Everything degrades under `prefers-reduced-motion` to a plain fade.

---

## ICONOGRAPHY

Vocabik has **two icon layers**:

1. **Line icons — [Lucide](https://lucide.dev)** (CDN: `lucide@latest`). Clean 2px-stroke, rounded
   line icons that match Nunito's friendly geometry. Used for all UI affordances: navigation (home,
   compass, bar-chart, user), controls (play, pause, volume, settings, search, bookmark, share,
   chevrons), and states (lock, check, x, flame, zap). Stroke `currentColor` so they inherit theme
   text colors. This is a **substitution** — no proprietary icon set was provided; Lucide was chosen
   as the closest fit to the rounded brand personality. *Flag: swap if a house icon set exists.*

2. **Functional emoji** — a small, fixed, meaningful set (NOT decoration): 🔥 streak · ⚡ XP ·
   💡 hint · 💪 / 🎵 / 📚 community reactions · ⭐ star rating · 🏆 leaderboard. These carry brand
   warmth and are part of the product's music-app personality. Do not expand this set.

Level badges use **typographic codes** ("A1"–"C1") in Nunito, color-coded by `--cefr-*` — not icons.
The Vocabik logo mark (`assets/logo.svg`) pairs a play-triangle with a blank underscore — the core
"watch → fill the blank" metaphor.

> Never hand-draw UI icons as inline SVG. Use Lucide; use the fixed emoji set where specified.

---

## INDEX — what's in this system

**Foundations**
- `styles.css` — global entry point (import list only; consumers link this).
- `tokens/` — `fonts.css` · `colors.css` · `typography.css` · `spacing.css` · `effects.css` · `motion.css` · `base.css`
- `guidelines/` — foundation specimen cards (Design System tab: Type, Colors, Spacing, Brand).

**Assets** — `assets/logo.svg`, `assets/logo-mark.svg`, sample thumbnail imagery.

**Components** (`components/`) — see each directory's `.prompt.md`:
- `core/` — Button, IconButton, Input, Badge, Tag, Avatar, Toast, ProgressBar, Switch, StarRating, Skeleton
- `media/` — VideoCard, LevelBadge, VersionSelector, StatCard, FilterChip, CommunityReactions

**UI Kits** (`ui_kits/`)
- `app/` — Vocabik learner app: Home, Exercise Player (pre-play + active), Score Card, Progress.

**Meta** — `readme.md` (this file) · `SKILL.md` (Agent-Skill wrapper).

The compiler exposes components under `window.VocabikDesignSystem_0b21db`.
