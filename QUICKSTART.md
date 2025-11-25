# 🚀 Quick Start Guide

Get up and running in 5 minutes!

## Prerequisites

- Flutter SDK installed ([Install Flutter](https://docs.flutter.dev/get-started/install))
- Android Studio or VS Code with Flutter extension
- Android device or emulator

## Step-by-Step Setup

### 1. Check Flutter Installation

```bash
flutter doctor
```

Fix any issues shown.

### 2. Get Dependencies

```bash
cd /home/ulan/Education/билим-саякатчысы-(knowledge-traveler)
flutter pub get
```

### 3. Set Up API Key

Create `.env` file:

```bash
echo "GEMINI_API_KEY=your_actual_key_here" > .env
```

Get your Gemini API key from: https://ai.google.dev/

### 4. Connect Device or Start Emulator

**Physical Device:**
```bash
# Enable USB debugging on your Android phone
# Connect via USB
flutter devices
```

**Emulator:**
```bash
# In Android Studio: Tools > Device Manager > Create Device
# Or use command line:
flutter emulators --launch <emulator_id>
```

### 5. Run the App

```bash
# Use the convenience script (recommended)
./run_app.sh

# Or run manually with your API key
flutter run --dart-define=GEMINI_API_KEY=your_actual_key_here
```

That's it! The app should now launch on your device.

**Note:** The API key is now securely compiled into the app at build time, not bundled in the APK. See `SECURITY.md` for details.

## Common Issues

### "GEMINI_API_KEY not found"
Make sure `.env` file exists in the project root with your API key.

### "No devices found"
- Enable USB debugging on phone
- Or start an Android emulator

### Build fails
```bash
flutter clean
flutter pub get
flutter run
```

## Next Steps

- Read [FLUTTER_README.md](./FLUTTER_README.md) for detailed information
- See [PLAYSTORE_DEPLOYMENT.md](./PLAYSTORE_DEPLOYMENT.md) for publishing guide
- Add your app icons to `assets/icon/` directory
- Test on multiple devices

## Development Tips

```bash
# Hot reload (while app is running)
# Press 'r' in terminal

# Hot restart
# Press 'R' in terminal

# Quit app
# Press 'q' in terminal

# Analyze code
flutter analyze

# Format code
flutter format lib/

# Build release APK (secure)
API_KEY=$(grep "^GEMINI_API_KEY=" .env | cut -d '=' -f2)
flutter build apk --release --dart-define=GEMINI_API_KEY="$API_KEY"

# Build release App Bundle for Play Store (secure)
API_KEY=$(grep "^GEMINI_API_KEY=" .env | cut -d '=' -f2)
flutter build appbundle --release --dart-define=GEMINI_API_KEY="$API_KEY"
```

## Need Help?

Check the full documentation in [FLUTTER_README.md](./FLUTTER_README.md)

---

Happy coding! 🎉

