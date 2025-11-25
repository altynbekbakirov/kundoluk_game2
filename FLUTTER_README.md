# Билим Саякатчысы (Knowledge Traveler) - Flutter Mobile App

<div align="center">
  <h3>Кыргыз тилиндеги илимий-билим берүүчү интерактивдүү RPG оюну</h3>
  <h4>Educational Interactive RPG Game in Kyrgyz & Russian</h4>
</div>

## 📱 About

An AI-powered educational mobile game designed for Kyrgyz students (grades 6-11). Learn Math, Physics, Chemistry, Biology, and Geography through interactive storytelling powered by Google's Gemini AI.

### Features

- 🌍 **Bilingual Support**: Kyrgyz and Russian languages
- 🎓 **Grade Levels**: Supports grades 6 through 11
- 📚 **Multiple Subjects**: Math, Physics, Chemistry, Biology, Geography
- 🎮 **Three Themed Scenarios**:
  - Time Travel to the Future
  - Ancient Kyrgyzstan
  - Survival Island
- 🤖 **AI-Powered**: Dynamic story generation using Gemini AI
- ⚡ **Energy System**: Knowledge-based gameplay mechanics

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Android Studio or VS Code with Flutter extensions
- Dart SDK (included with Flutter)
- Android device or emulator (API level 21+)

### Installation

1. **Clone the repository**
   ```bash
   cd /home/ulan/Education/билим-саякатчысы-(knowledge-traveler)
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up environment variables**
   
   Create a `.env` file in the root directory:
   ```bash
   echo "GEMINI_API_KEY=your_actual_gemini_api_key_here" > .env
   ```
   
   Get your Gemini API key from: https://ai.google.dev/

4. **Generate app icons** (optional - add your icons first)
   ```bash
   flutter pub run flutter_launcher_icons:main
   flutter pub run flutter_native_splash:create
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## 🏗️ Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   ├── enums.dart           # Game enums (status, language, etc.)
│   └── game_models.dart     # Data models
├── providers/
│   └── game_provider.dart   # State management
├── screens/
│   ├── start_screen.dart    # Language & game setup
│   ├── game_screen.dart     # Main gameplay
│   └── loading_screen.dart  # Loading states
├── widgets/
│   ├── custom_button.dart   # Reusable button
│   └── energy_bar.dart      # Energy display
├── services/
│   └── gemini_service.dart  # AI service integration
└── utils/
    └── localization.dart    # UI text translations

android/                      # Android-specific code
├── app/
│   ├── src/main/
│   │   ├── AndroidManifest.xml
│   │   └── kotlin/...       # Kotlin code
│   ├── build.gradle         # App-level Gradle config
│   └── proguard-rules.pro   # Code obfuscation rules
├── build.gradle             # Project-level Gradle
├── gradle.properties        # Gradle properties
└── settings.gradle          # Gradle settings

assets/
├── icon/                    # App icons
└── splash/                  # Splash screen assets
```

## 🛠️ Development

### Running in Debug Mode

```bash
flutter run
```

### Building for Testing

```bash
# Debug APK
flutter build apk --debug

# Profile APK (for performance testing)
flutter build apk --profile
```

### Checking for Issues

```bash
# Analyze code
flutter analyze

# Run tests (if available)
flutter test

# Check dependencies
flutter pub outdated
```

## 📦 Building for Release

### 1. Prepare App Icons

Place your app icons in `assets/icon/`:
- `app_icon.png` (1024x1024 px)
- `app_icon_foreground.png` (432x432 px for adaptive icon)
- `splash_icon.png` (512x512 px)

Then run:
```bash
flutter pub run flutter_launcher_icons:main
flutter pub run flutter_native_splash:create
```

### 2. Create Keystore

```bash
keytool -genkey -v -keystore ~/bilim-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias bilim-key
```

**Important**: Save your keystore password and key password securely!

### 3. Configure Signing

Create `android/key.properties`:
```properties
storePassword=your_keystore_password
keyPassword=your_key_password
keyAlias=bilim-key
storeFile=/home/ulan/bilim-release-key.jks
```

**Never commit this file to version control!**

### 4. Update Version

Edit `pubspec.yaml`:
```yaml
version: 1.0.0+1  # Format: major.minor.patch+buildNumber
```

### 5. Build Release APK/Bundle

```bash
# Build APK
flutter build apk --release

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release
```

Output locations:
- APK: `build/app/outputs/flutter-apk/app-release.apk`
- Bundle: `build/app/outputs/bundle/release/app-release.aab`

## 🏪 Play Store Deployment

See [PLAYSTORE_DEPLOYMENT.md](./PLAYSTORE_DEPLOYMENT.md) for detailed instructions.

### Quick Checklist

- ✅ App signed with release keystore
- ✅ Version number updated
- ✅ App icons and splash screen added
- ✅ Tested on multiple devices
- ✅ Privacy policy created
- ✅ Store listing prepared (screenshots, descriptions)
- ✅ Content rating completed

## 🔧 Configuration

### Minimum SDK Version
- Minimum: Android 5.0 (API 21)
- Target: Android 14 (API 34)

### Permissions
- `INTERNET`: Required for Gemini API calls
- `ACCESS_NETWORK_STATE`: Check network connectivity

### ProGuard
Code obfuscation and shrinking are enabled in release builds. See `android/app/proguard-rules.pro`.

## 🐛 Troubleshooting

### Common Issues

**1. "GEMINI_API_KEY not found"**
- Ensure `.env` file exists in the root directory
- Check that the API key is valid

**2. Build fails with Gradle errors**
- Clean the build: `flutter clean && flutter pub get`
- Check Java version: `java -version` (should be Java 11 or higher)

**3. App crashes on startup**
- Check if API key is set correctly
- Ensure internet permission is in AndroidManifest.xml
- Check device API level (should be 21+)

**4. Icons not updating**
- Delete `android/app/src/main/res/mipmap-*` directories
- Run icon generator again: `flutter pub run flutter_launcher_icons:main`

## 📚 Dependencies

Main packages used:
- `provider`: State management
- `http`: HTTP requests to Gemini API
- `google_fonts`: Beautiful typography
- `loading_animation_widget`: Loading animations
- `flutter_dotenv`: Environment variables
- `shared_preferences`: Local storage

## 🔐 Security Notes

1. **API Keys**: Never commit `.env` file or `key.properties` to version control
2. **Keystore**: Keep your keystore file and passwords secure
3. **ProGuard**: Enabled by default to obfuscate code
4. **HTTPS**: All API calls use HTTPS

## 📄 License

This project is for educational purposes. Created for Kyrgyzstan's educational system.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📞 Support

For issues or questions:
- Create an issue in the repository
- Contact the development team

## 🎯 Roadmap

- [ ] iOS support
- [ ] Offline mode with cached questions
- [ ] Progress tracking and achievements
- [ ] Multiplayer mode
- [ ] More themed scenarios
- [ ] Audio narration support

---

Made with ❤️ for Kyrgyz students

