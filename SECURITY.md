# Security Implementation Guide

## 🔒 API Key Security

This app uses **secure build-time compilation** for the Gemini API key instead of bundling it in the APK.

### ✅ What We Implemented

**BEFORE (UNSAFE):**
- ❌ API key in `.env` file bundled in APK
- ❌ Anyone could extract: `unzip app.apk && cat assets/.env`
- ❌ Your API key exposed to all users

**AFTER (SECURE):**
- ✅ API key compiled into binary via `--dart-define`
- ✅ Not extractable as plain text from APK
- ✅ Key never stored on device filesystem

## 🚀 How to Use

### Development (Local Testing)

```bash
# Method 1: Use the convenience script (recommended)
./run_app.sh

# Method 2: Manual command
flutter run --dart-define=GEMINI_API_KEY=your_actual_key_here
```

The `run_app.sh` script automatically reads from your `.env` file and passes it securely via `--dart-define`.

### Production (Play Store Release)

```bash
# Build release APK
flutter build apk --release --dart-define=GEMINI_API_KEY=your_actual_key_here

# Build release App Bundle (recommended for Play Store)
flutter build appbundle --release --dart-define=GEMINI_API_KEY=your_actual_key_here
```

**Output locations:**
- APK: `build/app/outputs/flutter-apk/app-release.apk`
- Bundle: `build/app/outputs/bundle/release/app-release.aab`

## 🔐 Additional Security Measures

### 1. API Key Restrictions (Highly Recommended)

Restrict your Gemini API key in Google Cloud Console:

1. Go to: https://console.cloud.google.com/apis/credentials
2. Click on your Gemini API key
3. Under "Application restrictions":
   - Select "Android apps"
   - Click "Add an item"
   - Add package name: `kg.bilim.sayakatchysy`
   - Add SHA-1 fingerprint (see below)

**Get your SHA-1 fingerprint:**

```bash
# For debug builds (development)
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

# For release builds (Play Store)
keytool -list -v -keystore ~/bilim-release-key.jks -alias bilim-key
```

Copy the SHA-1 fingerprint and add it to your API key restrictions.

### 2. API Usage Restrictions

In Google Cloud Console, also set:
- **API restrictions**: Select only "Generative Language API"
- **Quota limits**: Set daily request limits
- **Billing alerts**: Set up alerts for unexpected usage

### 3. Monitor Usage

Regular monitoring:
- Check API usage: https://console.cloud.google.com/apis/dashboard
- Set up billing alerts
- Review quotas and limits
- Watch for unusual patterns

## 🔍 Verify Security

### Test that API key is NOT in APK:

```bash
# Build the release APK
flutter build apk --release --dart-define=GEMINI_API_KEY=your_key

# Extract APK contents
cd build/app/outputs/flutter-apk/
unzip app-release.apk -d extracted/

# Search for API key (should find NOTHING)
grep -r "AIza" extracted/
grep -r "GEMINI_API_KEY" extracted/assets/

# If nothing found, you're secure! ✅
```

## 📝 .env File Usage

The `.env` file is now **ONLY** used locally for convenience:
- ✅ Read by `run_app.sh` script
- ✅ In `.gitignore` (not committed to Git)
- ✅ NOT bundled in APK/AAB
- ✅ Only exists on your development machine

**Format:**
```
GEMINI_API_KEY=AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

## 🚨 Important Notes

### Never Do This:
- ❌ Don't commit `.env` to Git
- ❌ Don't share your API key in code
- ❌ Don't bundle secrets in assets
- ❌ Don't hardcode API keys in source code

### Always Do This:
- ✅ Use `--dart-define` for all builds
- ✅ Restrict API keys in Google Cloud Console
- ✅ Monitor API usage regularly
- ✅ Set up billing alerts
- ✅ Keep keystore secure

## 🏗️ Build Scripts

### Development Script

Create `dev_run.sh`:
```bash
#!/bin/bash
API_KEY=$(grep "^GEMINI_API_KEY=" .env | cut -d '=' -f2)
flutter run --dart-define=GEMINI_API_KEY="$API_KEY"
```

### Release Build Script

Create `build_release.sh`:
```bash
#!/bin/bash
API_KEY=$(grep "^GEMINI_API_KEY=" .env | cut -d '=' -f2)

if [ -z "$API_KEY" ]; then
    echo "Error: GEMINI_API_KEY not found in .env"
    exit 1
fi

echo "Building release App Bundle..."
flutter build appbundle --release --dart-define=GEMINI_API_KEY="$API_KEY"

echo "✅ Build complete!"
echo "Location: build/app/outputs/bundle/release/app-release.aab"
```

## 🛡️ For Production: Use Backend API (Advanced)

For maximum security in production apps, consider this architecture:

```
[Mobile App] → [Your Backend Server] → [Gemini API]
```

**Benefits:**
- API key never on client device
- Better rate limiting and monitoring
- User authentication
- Request logging and analytics
- Can change/rotate keys without app update

**Implementation:**
1. Create backend API (Node.js, Python, etc.)
2. Store Gemini API key on server
3. Mobile app calls your API with authentication
4. Your server validates and forwards to Gemini
5. Response returned to mobile app

## 📚 References

- [Flutter Environment Variables](https://dart.dev/guides/environment-declarations)
- [Google Cloud API Key Restrictions](https://cloud.google.com/docs/authentication/api-keys)
- [Android App Signing](https://developer.android.com/studio/publish/app-signing)

## ✅ Security Checklist

Before Play Store release:

- [ ] API key uses `--dart-define` (not bundled in APK)
- [ ] Verified key not in APK: `grep -r "AIza" extracted/`
- [ ] API key restricted in Google Cloud Console
- [ ] Package name restriction added
- [ ] SHA-1 fingerprint added
- [ ] API restrictions set to Generative Language API only
- [ ] Billing alerts configured
- [ ] Daily quota limits set
- [ ] Usage monitoring dashboard set up
- [ ] `.env` in `.gitignore`
- [ ] Keystore backed up securely
- [ ] `key.properties` in `.gitignore`

---

**Last Updated:** November 24, 2024
**Security Status:** ✅ Secure
**API Key Storage:** Compile-time via --dart-define

