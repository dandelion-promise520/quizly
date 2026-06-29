import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "数据库系统原理 - 综合测试",
  description: "数据库系统原理综合测试，共41题",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="zh-CN" className="font-sans">
      <body className="min-h-screen flex flex-col font-sans">{children}</body>
    </html>
  );
}
