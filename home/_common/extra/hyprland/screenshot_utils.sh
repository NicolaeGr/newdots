# ================================
# Screenshot Functions for Hyprland
# ================================

_screenshot_tmpfile() {
	mktemp --suffix=.png
}

_screenshot_filename() {
	local suffix=${1:-screenshot} # default to "screenshot"
	echo ~/Pictures/Screenshots/$(date "+%F-%H%M%S")_"$suffix".png
}

screenshot_full() {
	set -euo pipefail
	tmpfile=$(_screenshot_tmpfile)
	trap 'rm -f "$tmpfile"' EXIT

	file=$(_screenshot_filename "screenshot")
	mkdir -p "$(dirname "$file")"

	focused_output=$(hyprctl monitors -j | jq -r '.[] | select(.focused==true).name')
	grim -o "$focused_output" "$tmpfile"

	swappy -f "$tmpfile" -o - | pngquant - --force -o "$file"

	notify-send "Screenshot saved" "$file"
	rm -f "$tmpfile"
}

screenshot_region() {
	set -euo pipefail
	tmpfile=$(_screenshot_tmpfile)
	trap 'rm -f "$tmpfile"' EXIT

	file=$(_screenshot_filename "region")
	mkdir -p "$(dirname "$file")"

	focused_output=$(hyprctl monitors -j | jq -r '.[] | select(.focused==true).name')
	grim -o "$focused_output" "$tmpfile"

	if ! region=$(slurp); then
		echo "Region selection cancelled."
		rm -f "$tmpfile"
		return 1
	fi
	grim -g "$region" "$tmpfile"
	swappy -f "$tmpfile" -o - | pngquant - --force -o "$file"
	notify-send "Screenshot saved" "$file"
	rm -f "$tmpfile"
}

screenshot_window() {
	set -euo pipefail
	local app_name=${1:-window}
	tmpfile=$(_screenshot_tmpfile)
	trap 'rm -f "$tmpfile"' EXIT

	file=$(_screenshot_filename "$app_name")
	mkdir -p "$(dirname "$file")"

	focused_monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused==true)')
	mon_x=$(echo "$focused_monitor" | jq '.x')
	mon_y=$(echo "$focused_monitor" | jq '.y')
	mon_w=$(echo "$focused_monitor" | jq '.width')
	mon_h=$(echo "$focused_monitor" | jq '.height')

	geom=$(hyprctl activewindow -j | jq -r --argjson mx "$mon_x" --argjson my "$mon_y" --argjson mw "$mon_w" --argjson mh "$mon_h" '
        .atX |= max($mx) | .atY |= max($my) |
        .sizeX |= min($mw) | .sizeY |= min($mh) |
        "\(.atX),\(.atY) \(.sizeX)x\(.sizeY)"
    ')
	if [[ -z $geom ]]; then
		echo "No focused window found"
		return 1
	fi

	grim -g "$geom" "$tmpfile"
	swappy -f "$tmpfile" -o - | pngquant - --force -o "$file"
	notify-send "Screenshot saved" "$file"
	rm -f "$tmpfile"
}

set -euo pipefail

case "${1:-}" in
full)
	screenshot_full
	;;
region)
	screenshot_region
	;;
window)
	screenshot_window
	;;
*)
	echo "Usage: $0 {full|region|window}"
	exit 1
	;;
esac
