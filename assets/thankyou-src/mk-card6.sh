#!/usr/bin/env bash
# 凝縮版 v6: 左右 +300px crop / ロゴ左上 / 訳語=手動座標配置 (水平・回転なし)
# stochastic placer 廃止 → 座標表で決め打ち。1 語単位の微調整が容易 + 生成高速 (mean 判定ループ無し)。
# 訳語は水平描画: 回転すると外接矩形が斜めに膨らみ実文字より広い領域を占有 → 隣と干渉して重なる。
#   水平なら外接矩形 = 文字サイズちょうど → 空きに収まり重なり減 + 可読性向上。
set -uo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
cd "$HERE"
SRC="$HERE/base-crop.png"          # 1620x576 (サラ中心版・文字なしベース)
OUT=/tmp/card-v6.png
T=/tmp/ty6                          # 中間ファイル prefix (揮発)
# --- 調整パラメータ ---
CT=56; CL=252; CR=236              # 上 / 左 / 右 crop  → W=1132 (イナリ中心)
LW=300; LOGO_X=16; LOGO_Y=12       # logo: crop後座標系で左上に直接配置
WORD_OP=0.8                        # 訳語不透明度
MPS=132                            # main text pointsize
# ----------------------
GOCHI="$HERE/fonts/GochiHand-Regular.ttf"
NOTO=/usr/share/fonts/google-noto-cjk/NotoSansCJK-Medium.ttc
LOGO="$HERE/logo_trim.png"
SEPIA='#6b4423'; CREAM='#fdf8ee'
SW=$(identify -format '%w' "$SRC"); SH=$(identify -format '%h' "$SRC")
W=$((SW-CL-CR)); H=$((SH-CT))
convert "$SRC" -crop ${W}x${H}+${CL}+${CT} +repage ${T}-cbase.png
echo "cropped base: ${W}x${H}"

# 訳語座標表: word|font(g=Gochi/n=Noto)|size|x|y   (x,y = crop後座標系 NorthWest 原点)
#   左列(x6) 5語 + Kiitos / 감사=Merci右下 人物寄り / 右側=上下に再配分(Danke Tack を下げ)
WORDS=(
 # --- 左列 (x=6 縦積み) ---
 "Спасибо|n|29|6|136"
 "Gracias|g|39|6|214"
 "Merci|g|42|6|292"
 "谢谢|n|48|6|370"
 "Ευχαριστώ|n|26|6|448"
 # --- 中央左 (Merci/谢谢 右の余白を活用・人物寄り): Kiitos 上 / ハングル 下 ---
 "Kiitos|g|37|132|312"
 "감사합니다|n|28|125|390"
 # --- 右側 (上→下に再配分) ---
 "Mahalo|g|39|856|6"
 "Grazie|g|39|992|6"
 "Obrigado|g|35|973|238"
 "Diolch|g|39|896|295"
 "Danke|g|40|992|360"
 "Tack|g|40|890|385"
 "ありがとう|n|40|890|448"
)

convert -size ${W}x${H} xc:none ${T}-wm.png
for entry in "${WORDS[@]}"; do
  IFS='|' read -r word font size x y <<< "$entry"
  ff="$GOCHI"; [ "$font" = "n" ] && ff="$NOTO"
  # cream の縁取り(下地) + sepia の本体 を重ねて「Thank You!」と同じ縁取り文字に
  convert -background none -font "$ff" -pointsize "$size" -fill "$CREAM" -stroke "$CREAM" -strokewidth 5 label:"$word" +repage ${T}-ws.png
  convert -background none -font "$ff" -pointsize "$size" -fill "$SEPIA" label:"$word" +repage ${T}-wf.png
  convert ${T}-ws.png ${T}-wf.png -gravity center -composite ${T}-w.png
  convert ${T}-wm.png ${T}-w.png -gravity NorthWest -geometry +${x}+${y} -composite ${T}-wm.png
done

convert ${T}-wm.png -channel A -evaluate multiply ${WORD_OP} +channel ${T}-wmf.png
convert ${T}-cbase.png ${T}-wmf.png -compose over -composite \
  \( "$LOGO" -fuzz 16% -transparent 'srgb(253,246,236)' -resize ${LW}x \) -gravity NorthWest -geometry +${LOGO_X}+${LOGO_Y} -composite \
  -font "$GOCHI" -gravity South -pointsize ${MPS} \
  -fill "$CREAM" -stroke "$CREAM" -strokewidth 9 -annotate +0+72 'Thank You!' \
  -fill "$SEPIA" -stroke none -annotate +0+72 'Thank You!' \
  "$OUT"
echo "v6 OK $(identify -format '%wx%h' "$OUT")"
