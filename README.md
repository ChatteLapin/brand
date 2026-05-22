# ChatteLapin brand

個人事業屋号 **シャラパン (ChatteLapin)** のブランド資産集約。 各 prj から参照する single source of truth。

## 構造

```
brand/
├── README.md                       本ファイル
├── guidelines.md                    使用方針 + 派生 file 命名規約
├── source/
│   └── chattelapin-master.png       元画像 (= 2048x2048 RGB、 全派生の編集元)
├── icons/                            PWA / OS インテグレーション (= 不透明)
│   ├── icon-192.png                  PWA standalone 用
│   ├── icon-512.png                  PWA standalone 用
│   └── apple-touch-icon.png          iOS ホーム画面 (= 180x180、 慣習名)
├── favicon/                          ブラウザタブ (= 透過)
│   ├── favicon-16.png
│   ├── favicon-32.png
│   └── favicon.ico                   16+32 マルチサイズ統合
└── logo/                             一般 web embed / og image / 名刺等 (= 透過)
    ├── chattelapin-64.png
    ├── chattelapin-400.png
    └── chattelapin-600.png
```

### dir の選び方

| 用途 | dir |
|---|---|
| 編集元・派生再生成 | `source/` |
| PWA / iOS ホーム / OS アイコン | `icons/` |
| ブラウザタブ | `favicon/` |
| web embed / og image / 名刺等 | `logo/` |

透過 / 不透明は **dir で決まる** (= icons は不透明、 favicon と logo は透過)。 ファイル名に suffix なし。

## 各 prj からの使い方

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

## 関連 repo

- [ChatteLapin/talent](https://github.com/ChatteLapin/talent) — ゲーム公開設計
- [ChatteLapin/business](https://github.com/ChatteLapin/business) — AI 会計自動化
- [ChatteLapin/volt](https://github.com/ChatteLapin/volt) — NIKKE ユニオン Discord Bot
- [ChatteLapin/internal](https://github.com/ChatteLapin/internal) — 事業内部情報 hub
