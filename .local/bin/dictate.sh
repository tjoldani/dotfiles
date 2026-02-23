#!/usr/bin/env bash
# Whisper.cpp toggle dictation script for Hyprland (Wayland)

set -e

# Configuration
MODEL="$HOME/.local/share/whisper/models/ggml-base.en.bin"
TEMP_DIR="/tmp/whisper-dictation"
AUDIO_FILE="$TEMP_DIR/recording.wav"
PID_FILE="$TEMP_DIR/recording.pid"

# Create temp directory
mkdir -p "$TEMP_DIR"

# Check if we're currently recording
if [ -f "$PID_FILE" ]; then
    # Stop recording
    RECORDING_PID=$(cat "$PID_FILE")

    # Kill the recording process
    kill "$RECORDING_PID" 2>/dev/null || true
    rm -f "$PID_FILE"

    # Wait a moment for the file to be written
    sleep 0.5

    # Check if we got any audio
    if [ ! -s "$AUDIO_FILE" ]; then
        notify-send "🎤 Dictation" "No audio recorded" -t 2000
        exit 1
    fi

    # Transcribe with whisper.cpp
    notify-send "🎤 Dictation" "Transcribing..." -t 2000

    TRANSCRIPTION=$(whisper-cli -m "$MODEL" -f "$AUDIO_FILE" --no-timestamps --output-txt --output-file "$TEMP_DIR/output" 2>/dev/null)

    # Read the output text file
    TEXT=$(cat "$TEMP_DIR/output.txt" 2>/dev/null || echo "")

    # Clean up
    rm -f "$AUDIO_FILE" "$TEMP_DIR/output.txt"

    # Type the transcribed text if we got something
    if [ -n "$TEXT" ]; then
        # Trim whitespace
        TEXT=$(echo "$TEXT" | xargs)

        # Type into focused window using wtype
        wtype "$TEXT"

        notify-send "🎤 Dictation" "Done!" -t 2000
    else
        notify-send "🎤 Dictation" "No speech detected" -t 2000
        exit 1
    fi
else
    # Start recording
    notify-send "🎤 Dictation" "Recording... (Press Super+D to stop)" -t 2000

    # Start recording in background and save PID
    parecord --channels=1 --rate=16000 --format=s16le "$AUDIO_FILE" 2>/dev/null &
    echo $! > "$PID_FILE"
fi
