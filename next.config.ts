import type { NextConfig } from "next";
import { codeInspectorPlugin } from 'code-inspector-plugin';


const nextConfig: NextConfig = {
  /* config options here */
  turbopack: {
    rules: codeInspectorPlugin({
      bundler: 'turbopack',
      showSwitch: true,
      editor: 'code'
    }),
  },
};

export default nextConfig;
