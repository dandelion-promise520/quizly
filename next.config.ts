import type { NextConfig } from "next";
import { codeInspectorPlugin } from 'code-inspector-plugin';

const isDev = process.env.NODE_ENV !== 'production';

const nextConfig: NextConfig = {
  /* config options here */
  typescript: {
    ignoreBuildErrors: true,
  },
  ...(isDev && {
    turbopack: {
      rules: codeInspectorPlugin({
        bundler: 'turbopack',
        showSwitch: true,
        editor: 'code'
      }),
    },
  }),
};

export default nextConfig;
