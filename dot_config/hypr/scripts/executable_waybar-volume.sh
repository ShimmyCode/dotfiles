#!/bin/bash

# Get the current volume percentage from PipeWire (e.g., "Volume: 0.75")
RAW_VOLUME_LINE=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)

# Extract volume number, convert to an integer percentage (e.g., 0.75 becomes 75)
# Using awk to handle the floating-point multiplication cleanly
VOLUME_PERCENT=$(echo "$RAW_VOLUME_LINE" | awk '{print int($2 * 100)}')

# Get mute status
IS_MUTED=$(echo "$RAW_VOLUME_LINE" | grep -c MUTED)

# --- Determine the volume to DISPLAY (CAPPED at 100) ---
if [ "$VOLUME_PERCENT" -gt 100 ]; then
    DISPLAY_VOLUME=100
else
    DISPLAY_VOLUME=$VOLUME_PERCENT
fi

# Determine the icon
if [ "$IS_MUTED" -eq 1 ]; then
    # Output the Muted status
    echo " Muted"
    exit 0
fi

if [ "$VOLUME_PERCENT" -gt 50 ]; then
    ICON=""
elif [ "$VOLUME_PERCENT" -gt 0 ]; then
    ICON=""
else
    ICON=""
fi

# Output the final text format that Waybar will display
echo "$ICON $DISPLAY_VOLUME%"
