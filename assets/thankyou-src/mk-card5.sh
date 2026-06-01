#!/usr/bin/env bash
set -uo pipefail
cd /tmp
SRC=/tmp/base-crop.png            # 1620x576 (サラ中心版)
# --- 調整パラメータ ---
CT=56; CL=104; CR=120              # 上 / 左 / 右 crop
LW=360; LOGO_X=292; LOGO_Y=126     # logo 位置: 13/14版 base(216,122) から +180右/+60下 = base(396,182)、 現crop(CL104/CT56)換算
WORD_OP=0.8                        # 訳語不透明度
CORE=42                            # 訳語ブロック核(% , 小さいほど重なり許容)
# ----------------------
GOCHI=/tmp/fonts/GochiHand-Regular.ttf
NOTO=/usr/share/fonts/google-noto-cjk/NotoSansCJK-Medium.ttc
SEPIA='#6b4423'; CREAM='#fdf8ee'
SW=$(identify -format '%w' "$SRC"); SH=$(identify -format '%h' "$SRC")
W=$((SW-CL-CR)); H=$((SH-CT))
convert "$SRC" -crop ${W}x${H}+${CL}+${CT} +repage /tmp/cbase.png
echo "cropped base: ${W}x${H}"
Wm1=$((W-3)); Hm1=$((H-3)); Wh=$((W/2)); Hh=$((H/2))
LH=$((LW/3))

# main text block (gravity South +92, pointsize 132)
MTW=860; MTX0=$(((W-MTW)/2)); MTX1=$(((W+MTW)/2)); MTY0=$((H-92-150)); MTY1=$((H-78))
# logo block
LBX0=$((LOGO_X-10)); LBY0=$((LOGO_Y-10)); LBX1=$((LOGO_X+LW+10)); LBY1=$((LOGO_Y+LH+10))

convert /tmp/cbase.png -fuzz 10% -fill '#ff00ff' \
  -draw "color 2,2 floodfill" -draw "color ${Wm1},2 floodfill" \
  -draw "color 2,${Hm1} floodfill" -draw "color ${Wm1},${Hm1} floodfill" \
  -draw "color ${Wh},2 floodfill" -draw "color ${Wh},${Hm1} floodfill" \
  -draw "color 2,${Hh} floodfill" -draw "color ${Wm1},${Hh} floodfill" \
  -fill white -opaque '#ff00ff' -fill black +opaque white \
  -fill black -draw "rectangle ${LBX0},${LBY0} ${LBX1},${LBY1}" \
  -draw "rectangle ${MTX0},${MTY0} ${MTX1},${MTY1}" /tmp/free.png

WORDS=(
 "谢谢|n|54" "ありがとう|n|46" "Merci|g|48" "Danke|g|46" "Gracias|g|44"
 "Grazie|g|44" "Obrigado|g|40" "감사합니다|n|32" "Спасибо|n|33" "Mahalo|g|44"
 "Ευχαριστώ|n|30" "Tack|g|46" "Kiitos|g|42" "Diolch|g|44"
)
CANDS=()
for ((yy=6; yy<=H-40; yy+=30)); do for ((xx=6; xx<=W-60; xx+=38)); do CANDS+=("$xx,$yy"); done; done
mapfile -t CANDS < <(printf '%s\n' "${CANDS[@]}" | awk 'BEGIN{srand(13)}{print rand()"\t"$0}' | sort -k1,1n | cut -f2-)

convert -size ${W}x${H} xc:none /tmp/wm.png
ANGLES=(-16 11 -7 6 -12 9 0 14 -10 5 -6 13 -14 8)
i=0; placed=0
for entry in "${WORDS[@]}"; do
  IFS='|' read -r word font size <<< "$entry"
  ff="$GOCHI"; [ "$font" = "n" ] && ff="$NOTO"
  angle=${ANGLES[$((i % ${#ANGLES[@]}))]}; i=$((i+1))
  # 縁取り(クリーム halo)+ sepia fill の二段描画
  convert -background none -font "$ff" -pointsize "$size" -fill "$CREAM" -stroke "$CREAM" -strokewidth 5 label:"$word" -rotate "$angle" +repage /tmp/ws.png
  convert -background none -font "$ff" -pointsize "$size" -fill "$SEPIA" label:"$word" -rotate "$angle" +repage /tmp/wf.png
  convert /tmp/ws.png /tmp/wf.png -gravity center -composite /tmp/w.png
  read -r ww hh < <(identify -format '%w %h\n' /tmp/w.png) || true
  bw=$((ww+8)); bh=$((hh+8)); ok=0; checks=0
  for c in "${CANDS[@]}"; do
    checks=$((checks+1)); [ $checks -gt 260 ] && break
    IFS=',' read -r cx cy <<< "$c"
    [ $((cx+bw)) -gt $W ] && continue
    [ $((cy+bh)) -gt $H ] && continue
    mn=$(convert /tmp/free.png -crop ${bw}x${bh}+${cx}+${cy} +repage -format '%[fx:minima]' info: 2>/dev/null || echo 0)
    if awk "BEGIN{exit !($mn>=0.999)}"; then
      convert /tmp/wm.png /tmp/w.png -gravity NorthWest -geometry +${cx}+${cy} -composite /tmp/wm.png
      sbw=$((bw*CORE/100)); sbh=$((bh*CORE/100)); sx=$((cx+(bw-sbw)/2)); sy=$((cy+(bh-sbh)/2))
      convert /tmp/free.png -fill black -draw "rectangle ${sx},${sy} $((sx+sbw)),$((sy+sbh))" /tmp/free.png
      ok=1; placed=$((placed+1)); break
    fi
  done
  [ $ok -eq 0 ] && echo "skip: $word"
done
echo "placed $placed / ${#WORDS[@]}"

convert /tmp/wm.png -channel A -evaluate multiply ${WORD_OP} +channel /tmp/wm_final.png
convert /tmp/cbase.png /tmp/wm_final.png -compose over -composite \
  \( /tmp/logo_trim.png -fuzz 16% -transparent 'srgb(253,246,236)' -resize ${LW}x \) -gravity NorthWest -geometry +${LOGO_X}+${LOGO_Y} -composite \
  -font "$GOCHI" -gravity South -pointsize 132 \
  -fill "$CREAM" -stroke "$CREAM" -strokewidth 9 -annotate +0+92 'Thank You!' \
  -fill "$SEPIA" -stroke none -annotate +0+92 'Thank You!' \
  /tmp/card-v5.png
echo "v5 OK $(identify -format '%wx%h' /tmp/card-v5.png)"
