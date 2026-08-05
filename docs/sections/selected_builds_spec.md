# PROJECT MAYANK — SELECTED BUILDS SECTION SPECIFICATION V1

## Vision

This section is not a normal project gallery.

It should feel like a premium software product showcase.

The goal:

When a recruiter reaches this section, they should think:

"This person doesn't just learn technology. He creates things."

The experience should feel closer to:

- Apple product pages
- Linear
- Vercel
- Modern SaaS showcases

NOT:

- student portfolio grids
- template cards
- basic GitHub project lists

---

# Section Identity

Name:

SELECTED BUILDS

Small label:

uppercase

letter spacing:
6px

color:
accent blue

---

Main heading:

"Things I built.
Ideas I turned into products."

Typography:

Large

Elegant

Confident

Not overly bold.

---

# Scroll Transition

When entering this section:

The Hero should transition smoothly.

Effect:

- Hero fades slightly
- Background particles continue
- New section emerges upward
- Content reveals progressively

No sudden page changes.

No hard cuts.

---

# Layout

Desktop:

Full viewport section.

Maximum width:

1200px

Large spacing.

Every element should breathe.

---

# Project Showcase

DO NOT create a normal grid.

Each project should feel like a product case study.

---

## Project Card

Structure:

Image / Visual area

↓

Project name

↓

One sentence description

↓

Technology stack

↓

Action button

---

# Card Design

Style:

Premium glass card.

Background:

rgba(255,255,255,0.04)

Border:

rgba(255,255,255,0.1)

Blur:

20px

Radius:

28px


No heavy shadows.

Use subtle glow.

---

# Hover Interaction

When mouse enters:

Card:

- moves upward 8px
- slightly scales 1.02
- border becomes brighter
- glow increases

Image:

- zoom 1.05

Duration:

300ms

Curve:

easeOutCubic


No rotation.

No excessive effects.

---

# Project Examples

Initial projects:

1.

MYK-CODES Portfolio

Description:

A cinematic Flutter portfolio website focused on engineering, design and interaction.

Technology:

Flutter Web
Dart
Animations


---

2.

AI Study Assistant

Description:

An intelligent system that organizes student knowledge and explains complex information.

Technology:

AI
OCR
Gemini
Flutter


---

3.

Future Cybersecurity Projects

Placeholder.

---

# Project Architecture

Create reusable components.

Structure:

features/projects/

presentation/

widgets/

project_card.dart

projects_view.dart


data/

project_data.dart


models/

project_model.dart


---

# Animation System

Every project card should have:

Fade animation

+
Slide upward animation


Delay:

Each card appears sequentially.


Card 1:

0ms

Card 2:

150ms

Card 3:

300ms


---

# Responsive Behaviour

Desktop:

Horizontal showcase or large cards.

Tablet:

Two-column layout.

Mobile:

Single column.


---

# Quality Rules

Avoid:

- default Flutter cards
- default buttons
- boring grids
- excessive gradients
- gaming effects

Everything should feel:

Minimal

Premium

Engineering focused

Intentional

---

# Performance

Maintain 60 FPS.

Avoid expensive blur everywhere.

Use animations carefully.
