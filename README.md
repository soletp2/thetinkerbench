# Pavlo Soletskyi — Personal Site

A static personal website built with [Astro](https://astro.build). Includes a blog, Q&A-style about page, and contact page.

## Local development

```bash
npm install
npm run dev
```

Open [http://localhost:4321/pavlo-soletskyi-site/](http://localhost:4321/pavlo-soletskyi-site/) in your browser.

## Build

```bash
npm run build
npm run preview
```

## Deploy to GitHub Pages

1. Create a new repository on GitHub named `pavlo-soletskyi-site`
2. Push this project to the `main` branch:

   ```bash
   git remote add origin git@github.com:<your-username>/pavlo-soletskyi-site.git
   git add .
   git commit -m "Initial site"
   git push -u origin main
   ```

3. In the repository **Settings → Pages**, set **Source** to **GitHub Actions**
4. The workflow in `.github/workflows/deploy.yml` builds and deploys on every push to `main`
5. Your site will be live at `https://<your-username>.github.io/pavlo-soletskyi-site/`

### Custom domain (optional)

Add a `public/CNAME` file with your domain, then configure DNS with your registrar.

## Configuration

Edit [`src/site.config.ts`](src/site.config.ts) to update your name, email, social links, and tagline.

## Adding blog posts

Create a new Markdown file in `src/content/blog/` with frontmatter:

```yaml
---
title: "Post title"
description: "Short summary for the blog index."
pubDate: 2026-06-10
tags:
  - tag-one
  - tag-two
---

Your content here.
```

## Project structure

```
src/
├── components/     # Header, Footer, PostCard
├── content/blog/ # Markdown blog posts
├── layouts/      # BaseLayout
├── pages/        # Routes (index, about, contact, blog)
├── styles/       # Global CSS
└── site.config.ts
```
