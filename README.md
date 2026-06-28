# 🍁 Maple Street Books

A warm, beautifully crafted one-page landing site for **Maple Street Books** — Portland's beloved independent bookstore, independently owned and operated since 1987.

---

## 🌐 Live Site

> Deployed via GitHub Pages — see the **Deployments** tab or the Pages settings for the live URL once enabled.

---

## 📁 Project Structure

```
maple-street-books/
├── index.html        # Complete one-page landing site (all-in-one)
└── README.md         # This file
```

The entire site is a **single self-contained `index.html`** with inline CSS and a small inline JS snippet — no build tools, no dependencies, no frameworks. Open it in any browser and it just works.

---

## 🗂️ Page Sections

| Section | Description |
|---|---|
| **Nav** | Sticky top navigation with smooth-scroll links |
| **Hero** | Full-width welcome banner with CTAs |
| **Featured Books** | 4-card grid of hand-picked titles with cover art, author, description, and price |
| **Events** | Upcoming readings, story times, book club, and fairs with date badges |
| **Hours & Contact** | Store hours table, address, phone, email, social links, and a contact form |
| **Footer** | Address, copyright, Privacy & Accessibility links |

---

## 🎨 Design Tokens

| Token | Value | Usage |
|---|---|---|
| `--cream` | `#fdf6ec` | Page background |
| `--warm` | `#f5e6cc` | Section alternate background |
| `--maple` | `#b5451b` | Primary brand / accent colour |
| `--ink` | `#1e1a17` | Headings, nav bar |
| `--leaf` | `#4a7c59` | Success states, "today" row |
| `--muted` | `#6b5e52` | Body text, subtitles |

---

## 🚀 Running Locally

No build step required:

```bash
# Option 1 — just open the file
open index.html

# Option 2 — serve with any static server
npx serve .
# or
python3 -m http.server 8080
```

Then visit `http://localhost:8080`.

---

## 📦 Deployment

This project is configured for **GitHub Pages** deployment:

1. Go to **Settings → Pages**
2. Source: `Deploy from a branch`
3. Branch: `main` · Folder: `/ (root)`
4. Save — the site will be live at `https://skarchenllc.github.io/maple-street-books/`

---

## 🛠️ Customisation Guide

| What to change | Where |
|---|---|
| Store name / address / phone | Footer + `#info` section |
| Store hours | `<table class="hours-table">` in `#info` |
| Featured books | `.books-grid` in `#books` |
| Events | `.events-list` in `#events` |
| Brand colours | `:root` CSS variables at top of `<style>` |
| Contact form action | Replace `handleSubmit()` with a real endpoint (Formspree, Netlify Forms, etc.) |

---

## ✅ Accessibility Notes

- Semantic HTML5 landmarks (`<nav>`, `<section>`, `<footer>`)
- Colour contrast ratios meet WCAG AA
- All interactive elements keyboard-accessible
- `lang="en"` declared on `<html>`
- Responsive from 320 px up via CSS Grid + `clamp()`

---

## 📝 License

© 2025 Maple Street Books. All rights reserved.
