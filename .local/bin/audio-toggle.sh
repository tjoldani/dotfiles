#!/usr/bin/env bash
# Toggle the default audio sink between the ADAM D3V (USB) and the MOTU M4.
# Both feed the same speakers (D3V via USB, M4 via its monitor outs into the
# D3V's analog input), so only one should be the active output at a time.
set -euo pipefail

notify() {
	if command -v notify-send >/dev/null 2>&1; then
		notify-send -a audio -u low "Audio Output" "$1"
	else
		echo "$1"
	fi
}

card_name() { pactl list short cards | awk -v p="$1" 'index($2, p) {print $2; exit}'; }

# Highest-priority available output profile for a card (skips off/pro-audio/Direct).
# Works for both the ADAM (output:analog-stereo) and the MOTU (HiFi (...)) naming.
best_output_profile() {
	pactl list cards | awk -v target="$1" '
		/^Card #/ { incard = 0 }
		$1 == "Name:" { incard = ($2 == target) }
		incard && /Profiles:/ { inprof = 1; next }
		incard && /Active Profile:/ { inprof = 0 }
		incard && inprof && /available: yes/ && /sinks: [1-9]/ {
			line = $0; sub(/^[ \t]+/, "", line)
			if (line ~ /^(off|pro-audio|Direct):/) next
			print substr(line, 1, index(line, ": ") - 1); exit
		}'
}

# Sink for a device. Prefer one whose name contains $2 (e.g. the M4 monitor out),
# else fall back to the device's first sink.
device_sink() {
	local pat="$1" prefer="${2:-}" s
	if [ -n "$prefer" ]; then
		s="$(pactl list short sinks |
			awk -v p="$pat" -v q="$prefer" 'index($2, p) && index($2, q) {print $2; exit}')"
		[ -n "$s" ] && { printf '%s' "$s"; return; }
	fi
	pactl list short sinks | awk -v p="$pat" 'index($2, p) {print $2; exit}'
}

# Resolve a connected device's sink, enabling a profile if the card is "off".
ensure_sink() {
	local pat="$1" prefer="${2:-}" card prof
	card="$(card_name "$pat")"
	[ -n "$card" ] || return 0 # device not connected

	if [ -z "$(device_sink "$pat" "$prefer")" ]; then
		prof="$(best_output_profile "$card")"
		[ -n "$prof" ] && pactl set-card-profile "$card" "$prof" 2>/dev/null || true
		sleep 0.3
	fi
	device_sink "$pat" "$prefer"
}

current="$(pactl get-default-sink)"

# Default to ADAM unless ADAM is already active. For the M4, prefer Line1 (monitor out).
if printf '%s' "$current" | grep -qi ADAM; then
	target="$(ensure_sink MOTU Line1)"
	label="MOTU M4"
else
	target="$(ensure_sink ADAM)"
	label="ADAM D3V"
fi

if [ -z "$target" ]; then
	notify "$label not connected"
	exit 1
fi

pactl set-default-sink "$target"
while read -r id _; do
	[ -n "$id" ] && pactl move-sink-input "$id" "$target" 2>/dev/null || true
done < <(pactl list short sink-inputs)

notify "→ $label"
