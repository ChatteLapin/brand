/// <reference path="../.astro/types.d.ts" />

// ChatteLapin 公式サイト 型補完用 module declaration
//
// `@rollup/plugin-yaml` で yaml import した時の default export 型を、
// path pattern 別に出し分ける。 これで page 側で `import i18n from '...yaml'`
// → 厳格型補完 + tsc check で誤参照を早期検出。
//
// shime レポート (2026-05-24) 残課題 #3 = yaml 型安全化 への対応。

import type { I18nDict } from './types/i18n';
import type { BusinessInfo } from './types/business-info';

declare module '*/data/i18n/ja.yaml' {
  const dict: I18nDict;
  export default dict;
}

declare module '*/data/i18n/en.yaml' {
  const dict: I18nDict;
  export default dict;
}

declare module '*/data/business-info.yaml' {
  const info: BusinessInfo;
  export default info;
}
