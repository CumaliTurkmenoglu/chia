import './globals.css';
import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'Tennis Court Reservations',
  description: 'Reserve tennis courts online. Built with Next.js on Vercel.',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body>
        <div className="container py-8">
          {children}
        </div>
      </body>
    </html>
  );
}