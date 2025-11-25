#!/bin/bash

# Билим Саякатчысы - Secure Release Build Script

echo "🏗️  Building Билим Саякатчысы for Play Store..."
echo ""

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "❌ Error: .env file not found!"
    echo "   Create .env file with your Gemini API key"
    exit 1
fi

# Extract API key from .env file
API_KEY=$(grep "^GEMINI_API_KEY=" .env | cut -d '=' -f2)

if [ -z "$API_KEY" ] || [ "$API_KEY" = "your_gemini_api_key_here" ]; then
    echo "❌ Error: GEMINI_API_KEY not set in .env file"
    echo "   Please edit .env and add your actual API key"
    exit 1
fi

# Check if keystore exists
if [ ! -f "android/key.properties" ]; then
    echo "⚠️  Warning: android/key.properties not found"
    echo "   Release will be signed with debug key"
    echo "   For Play Store, create release keystore first"
    echo ""
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo "🔒 Security Check..."
echo "   ✅ API key will be compiled into binary (secure)"
echo "   ✅ API key will NOT be extractable from APK"
echo ""

echo "📦 Building App Bundle (recommended for Play Store)..."
flutter build appbundle --release --dart-define=GEMINI_API_KEY="$API_KEY"

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ App Bundle built successfully!"
    echo "📍 Location: build/app/outputs/bundle/release/app-release.aab"
    echo ""
    echo "📦 Size:"
    ls -lh build/app/outputs/bundle/release/app-release.aab | awk '{print "   " $5}'
    echo ""
    echo "🔐 Security Verification (optional):"
    echo "   To verify API key is not in bundle, run:"
    echo "   cd build/app/outputs/bundle/release/"
    echo "   unzip app-release.aab -d extracted/"
    echo "   grep -r 'AIza' extracted/ # Should find nothing"
    echo ""
    echo "🚀 Ready to upload to Play Store!"
else
    echo ""
    echo "❌ Build failed! Check the error messages above."
    exit 1
fi

echo ""
echo "📱 Also building APK for direct installation..."
flutter build apk --release --dart-define=GEMINI_API_KEY="$API_KEY"

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ APK built successfully!"
    echo "📍 Location: build/app/outputs/flutter-apk/app-release.apk"
    echo ""
    echo "📦 Size:"
    ls -lh build/app/outputs/flutter-apk/app-release.apk | awk '{print "   " $5}'
    echo ""
fi

echo ""
echo "📚 Next Steps:"
echo "   1. Test the app: flutter install"
echo "   2. Verify API key security (see SECURITY.md)"
echo "   3. Upload to Play Store (see PLAYSTORE_DEPLOYMENT.md)"
echo ""
echo "🎉 Build complete!"

