# ブランド使用ガイドライン

ChatteLapin (= 個人事業屋号シャラパン) のブランド資産使用方針。

## ロゴ

- **マスター**: [`source/chattelapin-master.png`](./source/chattelapin-master.png) (= 2048x2048 RGB)
- 全派生 file はマスターから生成
- 改変禁止 (= 切り抜き / 色変更 / 反転 / 文字追加は派生 file を新規作成する形で対応)

## ファイル命名規約

| dir | パターン | 例 | 透明度 |
|---|---|---|---|
| source/ | `chattelapin-master.png` | – | RGB / RGBA いずれも (= 編集元) |
| icons/ | `icon-<size>.png` または web 慣習名 | `icon-192.png`、 `apple-touch-icon.png` | 不透明 (= OS が背景を期待) |
| favicon/ | `favicon-<size>.png` または `favicon.ico` | `favicon-16.png`、 `favicon.ico` | 透過 |
| logo/ | `chattelapin-<size>.png` | `chattelapin-400.png` | 透過 |

### 将来追加する派生 file (= 未作成、 必要時に追加)

| 派生 file | 用途 | 配置 |
|---|---|---|
| `chattelapin.svg` | ベクター版 (= 拡大耐性) | logo/ |
| `chattelapin-mono.png` | モノクロ版 (= 印刷物・名刺) | logo/ (= サイズ別なら logo/mono/) |
| `chattelapin-white.png` | 反転版 (= 暗背景用) | logo/ (= サイズ別なら logo/white/) |
| `og-image.png` | OG 画像 (= 1200x630 推奨、 SNS 共有用) | logo/ または専用 dir |
| `maskable-192.png` / `maskable-512.png` | Android Adaptive Icon (= 透過 + safe zone) | icons/ |

## 再生成コマンド

`source/chattelapin-master.png` を編集したら、 以下を実行して全派生 file を再生成:

```bash
cd /srv/chattelapin/brand
M=source/chattelapin-master.png

# icons (= 不透明、 #fdf6ec 背景合成。 PWA standalone 用)
convert "$M" -filter Lanczos -resize 512x512 icons/icon-512.png
convert "$M" -filter Lanczos -resize 192x192 icons/icon-192.png
convert "$M" -filter Lanczos -resize 180x180 -background "#fdf6ec" -flatten icons/apple-touch-icon.png

# logo (= 透過。 source が不透明なら別途透過版マスターから生成、 ここでは現状の透過版を維持)
# 注意: 現在の logo/*.png はユーザー手作業の透過版。 source からの完全自動再生成には透過版マスターが必要

# favicon (= 透過、 source から再生成する場合は透過版マスターから)
# 注意: favicon/*.png も透過版マスターからの派生想定

# favicon.ico (= 16+32 マルチサイズ統合)
convert favicon/favicon-16.png favicon/favicon-32.png favicon/favicon.ico
```

### 透過版マスター不足の TODO

現状 `source/chattelapin-master.png` は **不透明 RGB**。 透過版が必要な favicon / logo の自動再生成にはユーザー手作業 (= GIMP / Photoshop で背景透過化) が必要。

将来 `source/chattelapin-master-transparent.png` (= 2048x2048 RGBA) を追加して、 透過版派生も自動化したい。

## 使用許諾

- ChatteLapin org 配下の prj は自由に使用可 (= talent / business / volt / internal / brand)
- 外部利用 (= 取材・記事掲載等) はユーザー (= 金井大延) に都度連絡

## 配色 (= 将来確立、 暫定)

- メインカラー (暫定): `#3a6ea5` (= 紺青、 talent の theme_color に採用中)
- 背景 (暫定): `#fdf6ec` (= 暖かい白、 talent の background_color、 apple-touch-icon flatten 用)
- アクセント: (= 未確定)

talent / business / volt 等の各 prj で配色が確定したら、 整合性を取って本ファイルに集約。

## タイポグラフィ (= 将来確立)

- 和文: Noto Sans JP / Noto Serif JP (= Google Fonts、 暫定)
- 欧文: (= 未確定)

## 使用禁止事項

- ロゴの過度な変形 (= 縦横比率を崩す、 大幅にトリミングする)
- 他事業者・他ブランドの近接配置 (= ChatteLapin と無関係な印象を与える表現)
- ネガティブな文脈での使用 (= 攻撃的 / 風評 / 反社会的表現と組み合わせる)

## 更新履歴

- 2026-05-22: 初版 + 用途別 dir 整理 (`source/` / `icons/` / `favicon/` / `logo/`) + 慣習命名採用
