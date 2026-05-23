// Astro v5 + Tailwind v4 (= Vite plugin 形式)
// ChatteLapin 公式サイト / chattelapin.orz.cc + cl.orz.cc
// build target: Cloudflare Pages (= static output)

import { defineConfig } from 'astro/config';
import tailwindcss from '@tailwindcss/vite';

export default defineConfig({
  site: 'https://chattelapin.orz.cc',
  output: 'static',
  vite: {
    plugins: [tailwindcss()],
  },
  build: {
    inlineStylesheets: 'auto',
  },
  trailingSlash: 'never',
});
