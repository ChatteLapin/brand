# ChatteLapin brand

**シャラパン (ChatteLapin)** の **ブランド・広報資産** を集約する公開 repo。 ロゴ等のデザイン資産から、 公式サイトのソースコード、 将来の名刺・チラシ・プレスリリース等の広報物までを single source of truth として一元管理する。

## 役割

- **デザイン資産の source of truth**: ロゴ・favicon・アイコン・ガイドライン。 各 prj は本 repo から `cp` で取り込む
- **公式サイトのソース**: <https://chattelapin.orz.cc/> の Astro ソースコード (= `site/` 配下、 Cloudflare Pages へデプロイ)
- **広報物の集約 (= 将来)**: 名刺・チラシ・パンフレット・プレスリリース等の対外配布物

## 構造

```
brand/
├── README.md                       本ファイル
├── guidelines.md                   ブランド使用方針 + 派生 file 命名規約
├── source/
│   └── chattelapin-master.png      元画像 (= 2048x2048 RGB、 全派生の編集元)
├── icons/                          PWA / OS インテグレーション (= 不透明)
│   ├── icon-192.png                PWA standalone 用
│   ├── icon-512.png                PWA standalone 用
│   └── apple-touch-icon.png        iOS ホーム画面 (= 180x180、 慣習名)
├── favicon/                        ブラウザタブ (= 透過)
│   ├── favicon-16.png
│   ├── favicon-32.png
│   └── favicon.ico                 16+32 マルチサイズ統合
├── logo/                           web embed / og image / 名刺等 (= 透過)
│   ├── chattelapin-64.png
│   ├── chattelapin-400.png
│   └── chattelapin-600.png
├── site/                           公式サイト (= Astro + Cloudflare Pages デプロイ元)
│   ├── src/                        Astro source
│   ├── public/                     静的アセット (= favicon / og image)
│   ├── astro.config.mjs            Astro 設定
│   └── package.json
├── print/  (= 将来追加)             名刺・チラシ・パンフレット
└── pr/     (= 将来追加)             プレスリリース・取材対応資料
```

### dir の選び方 (= デザイン資産)

| 用途 | dir |
|---|---|
| 編集元・派生再生成 | `source/` |
| PWA / iOS ホーム / OS アイコン | `icons/` |
| ブラウザタブ | `favicon/` |
| web embed / og image / 名刺等 | `logo/` |

透過 / 不透明は **dir で決まる** (= icons は不透明、 favicon と logo は透過)。 ファイル名に suffix なし。

## 公式サイト (= `site/`)

シャラパン (ChatteLapin) の公式サイト <https://chattelapin.orz.cc/> のソースコード。

- フレームワーク: Astro v5 (= 静的サイトジェネレータ)
- スタイル: Tailwind CSS
- デプロイ: Cloudflare Pages (= 本 repo を接続、 Build root = `site/`)
- 開発: `cd site && npm install && npm run dev` (= localhost:5176 で HMR)
- 本番ビルド: `cd site && npm run build` → `site/dist/` 生成

### 公式サイトの構成
- `/` — 事業者紹介 + 主力プロダクト + 周辺活動 + 事業概要 + 事業者プロフィール + お問合せ (= single-page スクロール構造)
- `/products/talent` — 主力プロダクト Talent 紹介ページ (= talent docs 公開可能部分のサブセット、 talent の成長に合わせて同期更新)
- `/products/volt` — 実験プロダクト紹介ページ
- `/products/business-automation` — AI 会計自動化基盤紹介ページ
- `/products/brand` — ブランド・広報資産基盤紹介ページ (= 本 repo 自身)

## 各 prj への展開 (= デザイン資産の cp 取り込み)

source of truth = 本 repo。 各 prj は使う時に `cp` で取り込む運用。

### 例: talent への展開

```bash
cd /srv/chattelapin/brand && git pull
# PWA / iOS icon
cp icons/icon-192.png         /srv/chattelapin/talent/public/icons/icon-192.png
cp icons/icon-512.png         /srv/chattelapin/talent/public/icons/icon-512.png
cp icons/apple-touch-icon.png /srv/chattelapin/talent/public/apple-touch-icon.png
# favicon
cp favicon/favicon-16.png /srv/chattelapin/talent/public/favicon-16.png
cp favicon/favicon-32.png /srv/chattelapin/talent/public/favicon-32.png
cp favicon/favicon.ico    /srv/chattelapin/talent/public/favicon.ico
```

各 prj は `public/` 配下に同名で配置することで、 web 慣習通り `<link rel>` で参照できる。

### 各 prj の HTML 設定例

```html
<link rel="icon" type="image/x-icon" href="/favicon.ico" />
<link rel="icon" type="image/png" sizes="16x16" href="/favicon-16.png" />
<link rel="icon" type="image/png" sizes="32x32" href="/favicon-32.png" />
<link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png" />
```

PWA manifest の場合:
```json
{
  "icons": [
    { "src": "/icons/icon-192.png", "sizes": "192x192", "type": "image/png" },
    { "src": "/icons/icon-512.png", "sizes": "512x512", "type": "image/png" }
  ]
}
```

## 派生 file の再生成

`source/chattelapin-master.png` が更新されたら、 全派生 file を再生成する。 詳細は [`guidelines.md`](./guidelines.md) の「再生成コマンド」 セクション参照。

## ブランド使用許諾

[`guidelines.md`](./guidelines.md) の「使用許諾」 セクション参照。 外部利用 (= 取材・記事掲載・コラボ・引用等) は本 repo の [Issues](https://github.com/ChatteLapin/brand/issues/new) または公式サイト <https://chattelapin.orz.cc/#contact> から都度ご連絡ください。

## ChatteLapin Organization 構成

| repo | 公開 | 役割 |
|---|---|---|
| [talent](https://github.com/ChatteLapin/talent) | private (= v1.0 後 OSS 化判断) | 主力プロダクト (= 国際文化 × 経営シム × 教育 PWA) |
| [volt](https://github.com/ChatteLapin/volt) | private | 実験 Bot |
| [business](https://github.com/ChatteLapin/business) | public | AI 駆動 会計自動化基盤 |
| [brand](https://github.com/ChatteLapin/brand) | **public** | 本 repo / ブランド・広報資産・公式サイト |
| [internal](https://github.com/ChatteLapin/internal) | private | 事業内部情報 (= 戦略・収益・競合分析) |
