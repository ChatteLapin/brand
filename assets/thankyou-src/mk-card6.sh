#!/usr/bin/env bash
# 凝縮版 v6: 左右 +300px crop / ロゴ左上 / 訳語=手動座標配置 (水平・回転なし)
# stochastic placer 廃止 → 座標表で決め打ち。1 語単位の微調整が容易 + 生成高速 (mean 判定ループ無し)。
# 訳語は水平描画: 回転すると外接矩形が斜めに膨らみ実文字より広い領域を占有 → 隣と干渉して重なる。
#   水平なら外接矩形 = 文字サイズちょうど → 空きに収まり重なり減 + 可読性向上。
# 背景路線 BG_MODE: 2=装飾(マット額縁+暖色ビネット+3角枝葉、 既定) / 1=町ボカし合成 / 0=クリーム単色
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
BG_MODE=${BG_MODE:-2}              # 2=装飾(既定) / 1=町ボカし / 0=単色 (env 上書き可)
BG_IMG="$HERE/asuka_viewport.png"  # 背景/枝葉の元(talent 第1篇 逢海町 水彩)。gitignore 済(公開repo非追跡)、 regen 時は talent から cp
# -- 装飾(deco, BG_MODE=2) --
MATTE='#efe6d2'; FRAME2='#9a7a52'  # マット余白色 / 額縁内側の細罫色
MAT=40                             # マット余白幅(px) → 余白側に額縁を描き内容と非干渉
VIG_OP=0.30                        # 暖色ビネット不透明度(四隅を上品に締める)
ORN_W=240; ORN_OP=0.9; ORN_INSET=6 # 角枝葉の幅 / 不透明度 / 角からの差込み量
# -- 町ボカし(BG_MODE=1) --
BG_BLUR=42; BG_MOD="108,72"; FG_TOP=212
FG_ELL_CX=566; FG_ELL_CY=348; FG_ELL_RX=545; FG_ELL_RY=265; FG_ELL_BLUR=78
# ----------------------
GOCHI="$HERE/fonts/GochiHand-Regular.ttf"
NOTO=/usr/share/fonts/google-noto-cjk/NotoSansCJK-Medium.ttc
LOGO="$HERE/logo_trim.png"
SEPIA='#6b4423'; CREAM='#fdf8ee'
SW=$(identify -format '%w' "$SRC"); SH=$(identify -format '%h' "$SRC")
W=$((SW-CL-CR)); H=$((SH-CT))
convert "$SRC" -crop ${W}x${H}+${CL}+${CT} +repage ${T}-flat.png
echo "cropped base: ${W}x${H}"

if [ "$BG_MODE" = "2" ]; then
  # 枝葉要素を asuka から抽出(縁フェザー → クリーム地はマットに溶け、枝葉/幹だけ残す)
  convert "$BG_IMG" -crop 180x130+330+300 +repage ${T}-elraw.png
  convert -size 180x130 xc:black -fill white -draw "roundrectangle 10,10 170,120 26,26" -blur 0x13 ${T}-elmask.png
  convert ${T}-elraw.png ${T}-elmask.png -alpha off -compose CopyOpacity -composite ${T}-tree.png
  convert "$BG_IMG" -crop 180x82+330+300 +repage ${T}-canraw.png
  convert -size 180x82 xc:black -fill white -draw "roundrectangle 8,8 172,74 22,22" -blur 0x12 ${T}-canmask.png
  convert ${T}-canraw.png ${T}-canmask.png -alpha off -compose CopyOpacity -composite ${T}-canopy.png
  # 向き付き(下2角=立木、 右上=樹冠を垂らす) + 不透明度
  convert ${T}-tree.png   -resize ${ORN_W}x        -channel A -evaluate multiply ${ORN_OP} +channel ${T}-bl.png
  convert ${T}-tree.png   -resize ${ORN_W}x -flop  -channel A -evaluate multiply ${ORN_OP} +channel ${T}-br.png
  convert ${T}-canopy.png -resize ${ORN_W}x -rotate 180 -channel A -evaluate multiply ${ORN_OP} +channel ${T}-tr.png
  # cbase = クリーム + 暖色ビネット + 3角枝葉(訳語の下に敷く)
  convert ${T}-flat.png \
    \( -size ${W}x${H} radial-gradient:"rgba(107,68,35,0)"-"rgba(70,44,20,${VIG_OP})" \) -compose over -composite \
    ${T}-bl.png -gravity SouthWest -geometry +${ORN_INSET}+${ORN_INSET} -composite \
    ${T}-br.png -gravity SouthEast -geometry +${ORN_INSET}+${ORN_INSET} -composite \
    ${T}-tr.png -gravity NorthEast -geometry +${ORN_INSET}+${ORN_INSET} -composite \
    ${T}-cbase.png
elif [ "$BG_MODE" = "1" ]; then
  convert "$BG_IMG" -resize ${W}x${H}^ -gravity center -extent ${W}x${H} -blur 0x${BG_BLUR} -modulate ${BG_MOD} ${T}-bg.png
  convert -size ${W}x${H} xc:black -fill white -draw "rectangle 0,0 ${W},${FG_TOP}" -draw "ellipse ${FG_ELL_CX},${FG_ELL_CY} ${FG_ELL_RX},${FG_ELL_RY} 0,360" -blur 0x${FG_ELL_BLUR} ${T}-mask.png
  convert ${T}-flat.png ${T}-mask.png -alpha off -compose CopyOpacity -composite ${T}-fg.png
  convert ${T}-bg.png ${T}-fg.png -compose over -composite ${T}-cbase.png
else
  cp ${T}-flat.png ${T}-cbase.png
fi

# 訳語座標表: word|font(g=Gochi/n=Noto)|size|x|y   (x,y = crop後座標系 NorthWest 原点)
WORDS=(
 "Спасибо|n|29|6|136"
 "Gracias|g|39|6|214"
 "Merci|g|42|6|292"
 "谢谢|n|48|6|370"
 "Ευχαριστώ|n|26|6|448"
 "Kiitos|g|37|132|312"
 "감사합니다|n|28|125|390"
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

# 訳語/ロゴ/Thank You! を cbase に乗せる → 内側カード ${T}-inner.png
convert ${T}-wm.png -channel A -evaluate multiply ${WORD_OP} +channel ${T}-wmf.png
convert ${T}-cbase.png ${T}-wmf.png -compose over -composite \
  \( "$LOGO" -fuzz 16% -transparent 'srgb(253,246,236)' -resize ${LW}x \) -gravity NorthWest -geometry +${LOGO_X}+${LOGO_Y} -composite \
  -font "$GOCHI" -gravity South -pointsize ${MPS} \
  -fill "$CREAM" -stroke "$CREAM" -strokewidth 9 -annotate +0+72 'Thank You!' \
  -fill "$SEPIA" -stroke none -annotate +0+72 'Thank You!' \
  ${T}-inner.png

# 装飾モードはマット余白 + 二重罫額縁で締める(内容と非干渉)。それ以外は内側カードをそのまま出力
if [ "$BG_MODE" = "2" ]; then
  Wt=$((W+2*MAT)); Ht=$((H+2*MAT))
  convert ${T}-inner.png -bordercolor "$MATTE" -border ${MAT} \
    -fill none -stroke "$SEPIA"  -strokewidth 3   -draw "rectangle 17,17 $((Wt-18)),$((Ht-18))" \
    -stroke "$FRAME2" -strokewidth 1.5 -draw "rectangle 26,26 $((Wt-27)),$((Ht-27))" \
    "$OUT"
else
  cp ${T}-inner.png "$OUT"
fi
echo "v6 OK ($BG_MODE) $(identify -format '%wx%h' "$OUT")"
