import type { Metadata } from "next";
import { Inter } from 'next/font/google';
import { headers } from 'next/headers' // added
import './globals.css';
import ContextProvider from '@/context'

const inter = Inter({ 
  subsets: ['latin'],
  display: 'swap',
  variable: '--font-inter'
})

export const metadata: Metadata = {
  title: "ZK Travel History Management",
  description: "Privacy-preserving travel history management using Zero-Knowledge proofs",
};

export default async function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  const headersData = await headers();
  const cookies = headersData.get('cookie');

  return (
    <html lang="en" className={inter.variable}>
      <body className={`${inter.className} antialiased`}>
        <ContextProvider cookies={cookies}>{children}</ContextProvider>
      </body>
    </html>
  );
}
