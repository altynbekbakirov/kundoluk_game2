#!/bin/bash

# Билим Саякатчысы - Quick Run Script

echo "🚀 Starting Билим Саякатчысы..."
echo ""

# Check if .env file exists (for reading the key)
if [ ! -f ".env" ]; then
    echo "⚠️  Warning: .env file not found!"
    echo "Creating .env file from template..."
    echo "GEMINI_API_KEY=your_gemini_api_key_here" > .env
    echo ""
    echo "❗ Please edit .env and add your Gemini API key"
    echo "   Get your key from: https://ai.google.dev/"
    echo ""
    read -p "Press Enter to continue once you've added your API key..."
fi

# Extract API key from .env file
API_KEY=$(grep "^GEMINI_API_KEY=" .env | cut -d '=' -f2)

if [ -z "$API_KEY" ] || [ "$API_KEY" = "your_gemini_api_key_here" ]; then
    echo "❌ Error: GEMINI_API_KEY not set in .env file"
    echo "   Please edit .env and add your actual API key"
    exit 1
fi

# Check for connected devices
echo "📱 Checking for devices..."
DEVICES=$(flutter devices 2>&1 | grep "emulator\|device" | grep -v "No devices" | wc -l)

if [ "$DEVICES" -eq 0 ]; then
    echo "No Android device found. Starting emulator..."
    flutter emulators --launch Pixel_5 &
    echo "⏳ Waiting for emulator to boot (30 seconds)..."
    sleep 30
fi

# Run the app with API key compiled in (secure)
echo ""
echo "🎮 Launching app with secure API key..."
echo "   (API key will be compiled into binary, not extractable from APK)"
flutter run --dart-define=GEMINI_API_KEY="$API_KEY"

echo ""
echo "✅ App closed"

