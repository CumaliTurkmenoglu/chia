# Tennis Court Reservations

A minimal online tennis court reservation web app built with Next.js (App Router, TypeScript, Tailwind). Ready to deploy on Vercel.

- UI: Select a date and court, then book an available one-hour slot
- API: Serverless functions for listing and creating reservations
- Storage: File-based in development (`.data/reservations.json`), in-memory in production (ephemeral on Vercel). For persistence, connect a database like Vercel Postgres.

## Quickstart

```bash
npm install
npm run dev
```

Open http://localhost:3000

## Deploy to Vercel

1. Push this repo to GitHub/GitLab/Bitbucket
2. Import the project in Vercel
3. Framework Preset: Next.js
4. Build Command: `npm run build`
5. Output: `.next`

No extra configuration is required. In production, storage is in-memory (demo only). For persistent storage, provision a database and update the store in `lib/reservationsStore.ts`.

## Environment

- Node.js >= 18.18
- Next.js 14

## Notes

- The filesystem is not persistent on Vercel, so reservations will reset on redeploy. Use a real database in production.