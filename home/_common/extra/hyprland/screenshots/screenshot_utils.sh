#!/usr/bin/env zsh

set -euo pipefail

_tmp() { mktemp --suffix=.png; }
_out() {
	local suffix=${1:-screenshot}
	local dir="$HOME/Media/images/Screenshots"
	mkdir -p "$dir"
	echo "$dir/$(date '+%F-%H%M%S')_${suffix}.png"
}
_notify() {
	local msg="$1"
	local custom_icon="$HOME/.config/hypr/icons/screenshot.png"

	if [[ -f $custom_icon ]]; then
		local icon=(-i "$custom_icon")
	else
		local icon=(-i camera-photo)
	fi

	notify-send "${icon[@]}" "Screenshot" "$msg"
}

full() {
	local tmp=$(_tmp) out=$(_out full)
	local monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused).name')
	grim -o "$monitor" "$tmp"
	satty --filename "$tmp" --output-filename "$out" --save-after-copy --early-exit --disable-notifications
	if [[ -f $out ]]; then
		_notify "Full saved & copied" "camera-photo"
	else
		echo "Cancelled"
	fi
	rm -f "$tmp"
}

region() {
	local out=$(_out region)
	local monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused).name')
	local frozen=$(mktemp /tmp/frozen-XXXXXX.png)
	local tmpws="tmp_freeze"

	grim -c -o "$monitor" "$frozen"

	hyprctl keyword workspace "$tmpws,gapsin:0,gapsout:0,bordersize:0,rounding:0"

	hyprctl dispatch workspace "$tmpws"

	hyprctl dispatch exec \
		"[float; size 100% 100%; move 0 0; fullscreen 1; nofocus; noanim; pin; layer top] \
         mpv --loop=inf --no-osc --really-quiet --panscan=1.0 \
             --vo=gpu --gpu-context=wayland --hwdec=auto-safe \
             --no-border --no-window-dragging \
             \"$frozen\""

	while ! hyprctl clients -j | jq -e '.[] | select(.class == "mpv")' >/dev/null; do
		sleep 0.01
	done

	hyprctl dispatch movetolayer "layer top" class:^mpv$

	if geom=$(slurp -d -b '#00000088' -c '#ffffff' -s '#00000000' -w 3); then
		pkill -f "mpv.*$frozen"

		IFS=' ,x' read -r gx gy gw gh <<<"$geom"

		cropped=$(mktemp /tmp/crop-XXXXXX.png)
		convert "$frozen" -crop "${gw}x${gh}+${gx}+${gy}" "$cropped"

		satty --filename "$cropped" \
			--output-filename "$out" \
			--save-after-copy \
			--early-exit \
			--disable-notifications

		[[ -f $out ]] && _notify "Region saved & copied"

		rm -f "$cropped"
	else
		pkill -f "mpv.*$frozen"
		echo "Selection cancelled"
	fi

	rm -f "$frozen"
	hyprctl keyword workspace "$tmpws" unkeyword 2>/dev/null || true
}

window() {
	local suffix=${1:-window}
	local tmp=$(_tmp) out=$(_out "$suffix")

	local mon=$(hyprctl monitors -j | jq -r '.[] | select(.focused)')
	local mx=$(echo "$mon" | jq .x) my=$(echo "$mon" | jq .y)
	local mw=$(echo "$mon" | jq .width) mh=$(echo "$mon" | jq .height)

	local geom=$(hyprctl activewindow -j | jq -r --argjson mx "$mx" --argjson my "$my" --argjson mw "$mw" --argjson mh "$mh" '
        .at[0] as $wx | .at[1] as $wy |
        .size[0] as $ww | .size[1] as $wh |
        ([$wx,$mx] | max) as $x | ([$wy,$my] | max) as $y |
        ([$ww, $mw - ($x-$mx)] | min) as $w | ([$wh, $mh - ($y-$my)] | min) as $h |
        "\($x),\($y) \($w)x\($h)"
    ') || {
		echo "No window"
		rm -f "$tmp"
		return 1
	}

	grim -g "$geom" "$tmp"
	satty --filename "$tmp" --output-filename "$out" --save-after-copy --early-exit --disable-notifications
	if [[ -f $out ]]; then
		_notify "Window saved & copied" "window-new"
	else
		echo "Edit cancelled"
	fi
	rm -f "$tmp"
}

case "${1:-}" in
full) full ;;
region) region ;;
window) window "${2:-}" ;;
*)
	echo "Usage: $0 {full|region|window} [suffix]"
	exit 1
	;;
esac
