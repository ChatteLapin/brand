# ChatteLapin brand

個人事業屋号 **シャラパン (ChatteLapin)** のブランド資産集約。 ロゴ・favicon・ガイドラインを 1 箇所で管理し、 各 prj から参照する single source of truth。

## 構造

```
brand/
├── README.md           本ファイル
├── guidelines.md       ブランド使用方針
├── logo/
│   ├── chattelapin.png       メイン (= 2048x2048 PNG)
│   ├── chattelapin-512.png   高解像度 (= PWA / OG image 用)
│   ├── chattelapin-192.png   PWA アイコン用
│   └── (将来) chattelapin.svg / -mono.png / -white.png
└── favicon/            favicon 各サイズ (= 後で整備)
```

## 各 prj からの使い方

1. **ローカルに pull**: `cd /srv/chattelapin/brand && git pull`
2. **必要 file を cp**: 各 prj の `public/` や `assets/` にコピー
3. source of truth は本 repo、 各 prj は使う時にコピーする運用

### 例: talent の PWA アイコン配置

```bash
cp /srv/chattelapin/brand/logo/chattelapin-192.png /srv/chattelapin/talent/public/icons/icon-192.png
cp /srv/chattelapin/brand/logo/chattelapin-512.png /srv/chattelapin/talent/public/icons/icon-512.png
```

### 更新フロー

- メインロゴ更新時は **派生 file を再生成**:
  ```bash
  cd /srv/chattelapin/brand/logo/
  convert chattelapin.png -filter Lanczos -resize 512x512 chattelapin-512.png
  convert chattelapin.png -filter Lanczos -resize 192x192 chattelapin-192.png
  ```
- 各 prj への展開は手動 cp (= 将来 sync script 化検討)
- 更新後は git commit + push、 各 prj 側で git pull + cp + commit

## 関連 repo

- [ChatteLapin/talent](https://github.com/ChatteLapin/talent) — ゲーム公開設計
- [ChatteLapin/business](https://github.com/ChatteLapin/business) — AI 会計自動化
- [ChatteLapin/volt](https://github.com/ChatteLapin/volt) — NIKKE ユニオン Discord Bot
- [ChatteLapin/internal](https://github.com/ChatteLapin/internal) — 事業内部情報 hub
