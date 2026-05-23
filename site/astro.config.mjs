// Astro v5 + Tailwind v4 (= Vite plugin 形式)
// ChatteLapin 公式サイト / chattelapin.orz.cc + cl.orz.cc
// build target: Cloudflare Pages (= static output)

import { defineConfig } from 'astro/config';
import tailwindcss from '@tailwindcss/vite';
import yaml from '@rollup/plugin-yaml';

export default defineConfig({
  site: 'https://chattelapin.orz.cc',
  output: 'static',
  i18n: {
    defaultLocale: 'ja',
    locales: ['ja', 'en'],
    routing: {
      prefixDefaultLocale: false,
    },
  },
  vite: {
    plugins: [tailwindcss(), yaml()],
  },
  build: {
    inlineStylesheets: 'auto',
    format: 'file',
  },
  trailingSlash: 'never',
});
