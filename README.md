This is a [Next.js](https://nextjs.org) project bootstrapped with [`create-next-app`](https://nextjs.org/docs/app/api-reference/cli/create-next-app).

## Getting Started

First, run the development server:

```bash
npm run dev
# or
yarn dev
# or
pnpm dev
# or
bun dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

You can start editing the page by modifying `app/page.tsx`. The page auto-updates as you edit the file.

This project uses [`next/font`](https://nextjs.org/docs/app/building-your-application/optimizing/fonts) to automatically optimize and load [Geist](https://vercel.com/font), a new font family for Vercel.

## Learn More

To learn more about Next.js, take a look at the following resources:

- [Next.js Documentation](https://nextjs.org/docs) - learn about Next.js features and API.
- [Learn Next.js](https://nextjs.org/learn) - an interactive Next.js tutorial.

You can check out [the Next.js GitHub repository](https://github.com/vercel/next.js) - your feedback and contributions are welcome!

## Deploy on Vercel

The easiest way to deploy your Next.js app is to use the [Vercel Platform](https://vercel.com/new?utm_medium=default-template&filter=next.js&utm_source=create-next-app&utm_campaign=create-next-app-readme) from the creators of Next.js.

Check out our [Next.js deployment documentation](https://nextjs.org/docs/app/building-your-application/deploying) for more details.

## Continuous Integration: DB Seed Test

This project includes a GitHub Actions workflow `.github/workflows/db-seed-test.yml` that runs a test to verify the seeded Monday dinner exists in your Supabase database.

- Add the Postgres connection string as a repository secret named `SUPABASE_PG_CONN` (example URI):

  `postgresql://postgres:<password>@db.<project>.supabase.co:5432/postgres?sslmode=require`

- The workflow uses this secret as `PG_CONN` during the test run. For Supabase's cert chain the CI sets `PG_ALLOW_SELF_SIGNED=true`.

Security guidance:

- Use a short-lived or restricted DB user if possible (avoid using your main DB password in CI).
- After adding the secret, rotate/revoke it when no longer needed.
- In GitHub: Repository → Settings → Secrets → Actions → New repository secret. Name it `SUPABASE_PG_CONN` and paste the connection string.

Local test:

```powershell
$env:PG_CONN = "postgresql://postgres:<password>@db.<project>.supabase.co:5432/postgres?sslmode=require"
$env:PG_ALLOW_SELF_SIGNED = "true"  # if you need to allow the cert
npm test --silent
```

The test asserts that a DINNER item for Monday references the seeded "Spaghetti with Tomato Sauce" recipe. If the test fails, check the migrations and seed SQL in `supabase/migrations` and `supabase/seeds`.


