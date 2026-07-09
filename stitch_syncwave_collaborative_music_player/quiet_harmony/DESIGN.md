---
name: Quiet Harmony
colors:
  surface: '#f9f9fc'
  surface-dim: '#d9dadd'
  surface-bright: '#f9f9fc'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f3f3f6'
  surface-container: '#edeef1'
  surface-container-high: '#e8e8eb'
  surface-container-highest: '#e2e2e5'
  on-surface: '#1a1c1e'
  on-surface-variant: '#464554'
  inverse-surface: '#2f3133'
  inverse-on-surface: '#f0f0f3'
  outline: '#777585'
  outline-variant: '#c7c4d6'
  surface-tint: '#4f4ccd'
  primary: '#3f3bbd'
  on-primary: '#ffffff'
  primary-container: '#5856d6'
  on-primary-container: '#e7e4ff'
  inverse-primary: '#c2c1ff'
  secondary: '#5c5e66'
  on-secondary: '#ffffff'
  secondary-container: '#e2e2ec'
  on-secondary-container: '#62646c'
  tertiary: '#4e4f53'
  on-tertiary: '#ffffff'
  tertiary-container: '#66676c'
  on-tertiary-container: '#e7e6eb'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#e2dfff'
  primary-fixed-dim: '#c2c1ff'
  on-primary-fixed: '#0c006a'
  on-primary-fixed-variant: '#3631b4'
  secondary-fixed: '#e2e2ec'
  secondary-fixed-dim: '#c5c6cf'
  on-secondary-fixed: '#191b22'
  on-secondary-fixed-variant: '#45464e'
  tertiary-fixed: '#e3e2e7'
  tertiary-fixed-dim: '#c6c6cb'
  on-tertiary-fixed: '#1a1b1f'
  on-tertiary-fixed-variant: '#46464b'
  background: '#f9f9fc'
  on-background: '#1a1c1e'
  surface-variant: '#e2e2e5'
typography:
  headline-lg:
    fontFamily: Inter
    fontSize: 40px
    fontWeight: '600'
    lineHeight: 48px
    letterSpacing: -0.02em
  headline-lg-mobile:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Inter
    fontSize: 28px
    fontWeight: '500'
    lineHeight: 36px
    letterSpacing: -0.01em
  title-lg:
    fontFamily: Inter
    fontSize: 22px
    fontWeight: '500'
    lineHeight: 28px
  body-lg:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-lg:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
    letterSpacing: 0.1px
  label-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.5px
rounded:
  sm: 0.5rem
  DEFAULT: 1rem
  md: 1.5rem
  lg: 2rem
  xl: 3rem
  full: 9999px
spacing:
  unit: 4px
  gutter-sm: 16px
  gutter-md: 24px
  margin-mobile: 16px
  margin-desktop: 32px
  max-width: 1280px
---

## Brand & Style

The design system is anchored in the philosophy of "Quiet technology. Emotional music." It is designed to feel like a high-end sanctuary—unobtrusive yet deeply resonant. The target audience values focus, intentionality, and aesthetic refinement, typically found in premium wellness or audio-focused applications.

The visual style is **Corporate Modern with a Minimalist lean**, borrowing the soft, organic structural integrity of Material 3 but stripping away industrial rigidity. It emphasizes spaciousness, soft transitions, and a serene interface that recedes into the background to allow content to breathe. The emotional response is one of calm, reliability, and sophisticated warmth.

## Colors

The palette is centered around **Periwinkle (#5856D6)**, a primary color that balances technical precision with a dreamlike, melodic quality. 

- **Primary:** Used for key actions, active states, and focal branding elements.
- **Background:** A warm off-white (#F9F9FC) provides a softer, more human alternative to pure white, reducing eye strain and establishing a tactile feel.
- **Surface:** Elevated layers utilize a pure white or very light periwinkle tint to create subtle contrast against the warm background.
- **Typography:** Deep slate and charcoal are used for text to maintain high legibility without the harshness of true black.

## Typography

This design system uses **Inter** exclusively to leverage its systematic, neutral, and highly legible characteristics. The hierarchy is established through intentional scale and weight shifts rather than decorative font changes.

Headlines feature tighter letter spacing and heavier weights to feel "grounded," while body text maintains a generous line height for maximum readability. Labels and utility text use medium weights to ensure they remain functional even at smaller sizes.

## Layout & Spacing

The layout philosophy follows a **fluid grid** model with soft constraints. It utilizes a 12-column system for desktop and a 4-column system for mobile. 

- **Rhythm:** An 8px linear scale is used for structural spacing, with a 4px half-step used for tight component internals.
- **Margins:** Generous outer margins are required to maintain the "Quiet" narrative. On desktop, content should rarely touch the edges of the viewport.
- **Reflow:** Layouts should transition seamlessly between breakpoints, favoring the stacking of cards and the expansion of internal padding rather than drastic structural shifts.

## Elevation & Depth

Visual hierarchy is conveyed through **tonal layers** and **ambient shadows**. 

1. **Base:** The warm off-white (#F9F9FC) acts as the canvas.
2. **Elevated Surfaces:** Cards and containers use a pure white fill.
3. **Shadows:** Shadows are extra-diffused and low-opacity (2-8%), with a very slight Periwinkle tint (#5856D6) mixed into the shadow color to maintain a cohesive atmospheric feel.
4. **Interaction:** Upon hover or focus, surfaces should lift slightly (increasing shadow spread) or gain a subtle inner stroke to signal interactivity without breaking the calm aesthetic.

## Shapes

In alignment with the Material 3 "Extra Large" rounding style, this design system uses a primary corner radius of **24px** for cards and major containers. This high level of roundedness evokes a friendly, organic, and safe environment.

Smaller elements like buttons or chips may scale down to 12px or 16px, but should always remain noticeably rounded. Avoid sharp corners entirely to maintain the soft "Harmony" visual language.

## Components

- **Buttons:** Primary buttons are pill-shaped with the Periwinkle background and white text. Secondary buttons use a light periwinkle tint (#EBEBF5) with primary colored text. 
- **Input Fields:** Search bars and text inputs feature the 24px radius and a subtle 1px border in a light neutral shade. Icons within inputs should use a medium-grey tint.
- **Cards:** Cards are the primary container. They must feature the 24px corner radius and a soft ambient shadow. Internal padding should be generous (24px to 32px).
- **Navigation:** A bottom navigation bar (mobile) or sidebar (desktop) uses active state indicators consisting of a primary-colored pill behind the icon, ensuring the user's location is always clear.
- **Chips:** Used for filtering or tags, these should be fully rounded (pill-shaped) with low-contrast backgrounds to keep the interface clean and uncluttered.