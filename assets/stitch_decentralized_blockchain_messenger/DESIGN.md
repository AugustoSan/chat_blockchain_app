---
name: Secure Protocol Aesthetics
colors:
  surface: '#0f1418'
  surface-dim: '#0f1418'
  surface-bright: '#343a3e'
  surface-container-lowest: '#0a0f12'
  surface-container-low: '#171c20'
  surface-container: '#1b2024'
  surface-container-high: '#252b2e'
  surface-container-highest: '#303539'
  on-surface: '#dee3e8'
  on-surface-variant: '#bdc8d1'
  inverse-surface: '#dee3e8'
  inverse-on-surface: '#2c3135'
  outline: '#87929a'
  outline-variant: '#3e484f'
  surface-tint: '#7bd0ff'
  primary: '#8ed5ff'
  on-primary: '#00354a'
  primary-container: '#38bdf8'
  on-primary-container: '#004965'
  inverse-primary: '#00668a'
  secondary: '#bec6e0'
  on-secondary: '#283044'
  secondary-container: '#3f465c'
  on-secondary-container: '#adb4ce'
  tertiary: '#45e3ce'
  on-tertiary: '#003731'
  tertiary-container: '#07c7b2'
  on-tertiary-container: '#004d44'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#c4e7ff'
  primary-fixed-dim: '#7bd0ff'
  on-primary-fixed: '#001e2c'
  on-primary-fixed-variant: '#004c69'
  secondary-fixed: '#dae2fd'
  secondary-fixed-dim: '#bec6e0'
  on-secondary-fixed: '#131b2e'
  on-secondary-fixed-variant: '#3f465c'
  tertiary-fixed: '#62fae3'
  tertiary-fixed-dim: '#3cddc7'
  on-tertiary-fixed: '#00201c'
  on-tertiary-fixed-variant: '#005047'
  background: '#0f1418'
  on-background: '#dee3e8'
  surface-variant: '#303539'
typography:
  h1:
    fontFamily: Space Grotesk
    fontSize: 40px
    fontWeight: '700'
    lineHeight: '1.2'
    letterSpacing: -0.02em
  h2:
    fontFamily: Space Grotesk
    fontSize: 32px
    fontWeight: '600'
    lineHeight: '1.2'
  h3:
    fontFamily: Space Grotesk
    fontSize: 24px
    fontWeight: '500'
    lineHeight: '1.3'
  body-lg:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '400'
    lineHeight: '1.6'
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: '1.5'
  label-caps:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '600'
    lineHeight: '1'
    letterSpacing: 0.05em
  mono-data:
    fontFamily: monospace
    fontSize: 14px
    fontWeight: '400'
    lineHeight: '1.4'
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 4px
  xs: 0.5rem
  sm: 0.75rem
  md: 1rem
  lg: 1.5rem
  xl: 2rem
  gutter: 1rem
  margin-mobile: 1rem
  margin-desktop: 2.5rem
---

## Brand & Style

This design system is built for a high-security, blockchain-centric messaging environment. The visual identity balances technical sophistication with user-friendly accessibility, aiming to evoke a sense of "encrypted calm." 

The design movement is a hybrid of **Glassmorphism** and **Corporate Modern**. It utilizes translucent layers to represent the transparency of the blockchain, while maintaining a rigid, structured layout that suggests stability and defense-grade security. The target audience includes crypto-natives, security professionals, and tech enthusiasts who value privacy without sacrificing a premium aesthetic.

## Colors

The palette is anchored in a deep, nocturnal spectrum to minimize eye strain and reinforce the "dark mode" tech aesthetic. 

- **Primary:** A vibrant Sky Blue (#38BDF8) used for active states, primary actions, and branding.
- **Secondary:** Deep Slate (#0F172A) serves as the foundation for containers and structural elements.
- **Tertiary:** A Teal/Mint (#2DD4BF) highlight used for success states and blockchain confirmation indicators.
- **Neon Accents:** Subtle Indigo-Violets are used sparingly for notification pips and high-priority encryption status indicators.
- **Neutral:** Grays are cool-toned to maintain harmony with the blue-base.

## Typography

This design system utilizes a dual-font strategy. **Space Grotesk** provides a technical, geometric edge for headlines and branding, reflecting the blockchain's innovative nature. **Inter** is the workhorse for all functional text, ensuring maximum legibility in message bubbles and data tables.

For wallet addresses and transaction hashes, a monospaced fallback is required to ensure character alignment and prevent misreading of secure strings.

## Layout & Spacing

The system follows a **Fluid Grid** model based on an 8px rhythm. On mobile, a single-column layout persists with 16px side margins. On desktop, a 12-column grid is used for the main dashboard, with a fixed-width left sidebar for navigation and a flexible middle column for message threads.

Spacing is generous to avoid visual clutter, which is critical in apps handling complex data like crypto balances or encryption keys. Information density should be managed through "visual breathing room" rather than shrinking elements.

## Elevation & Depth

Hierarchy is established through **Glassmorphism** and tonal layering rather than traditional heavy shadows.

- **Level 0 (Background):** Solid `#020617`.
- **Level 1 (Panels):** Semi-transparent `#1E293B` at 80% opacity with a `20px` backdrop blur.
- **Level 2 (Modals/Popovers):** Higher contrast surfaces with a subtle `1px` inner border (stroke) using a low-opacity version of the Primary color to simulate a "light leak" on the edge.
- **Shadows:** Only used for floating action buttons, employing a highly diffused, tinted shadow (`rgba(56, 189, 248, 0.15)`) to create a soft neon glow effect.

## Shapes

The design system uses a "Rounded" philosophy to soften the technical nature of the app. 

- **Containers & Cards:** 1rem (`rounded-lg`) for a friendly but modern feel.
- **Buttons & Inputs:** 0.5rem (`rounded-md`) to maintain a sense of precision.
- **Message Bubbles:** Asymmetric rounding (1rem on most corners, 0.25rem on the origin corner) to distinguish sender/receiver.
- **Icons:** Minimalist 2px line art with slightly rounded caps and joins to match the UI's geometry.

## Components

- **Buttons:** Primary buttons use a solid gradient from Primary to Tertiary. Secondary buttons use an "outline-glass" style—a transparent background with a 1px primary border and backdrop blur.
- **Message Bubbles:** User messages use a Primary color tint with white text; incoming messages use the Level 1 surface color with gray text. All bubbles include a tiny "encrypted" lock icon in the metadata row.
- **Input Fields:** Fields are dark with a 1px border that glows (box-shadow) when focused. Labels always sit above the field in `label-caps` typography.
- **Chips:** Used for wallet tags or "Verified" statuses. These should be small, high-radius (pill-shaped) with a subtle neon glow.
- **Security Indicators:** A persistent "Signal" bar at the top of chat threads showing the current encryption strength or blockchain sync status.
- **Wallet Cards:** High-contrast cards with glassmorphic backgrounds and blurred "blobs" of color behind them to differentiate between various asset types (e.g., ETH, BTC).