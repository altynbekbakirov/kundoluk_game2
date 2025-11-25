# Google Play Store Deployment Guide

Complete guide to publish "Билим Саякатчысы (Knowledge Traveler)" on Google Play Store.

## 📋 Prerequisites

Before starting, ensure you have:

- ✅ Google Play Developer account ($25 one-time fee)
- ✅ Release-signed APK or App Bundle (.aab)
- ✅ App icons and screenshots
- ✅ Privacy policy URL
- ✅ App tested on multiple devices
- ✅ **API key secured** (see SECURITY.md)
- ✅ Google Cloud API restrictions configured

## 🔑 Step 1: Create Release Keystore

### Generate Keystore

```bash
keytool -genkey -v -keystore ~/bilim-release-key.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias bilim-key
```

You'll be asked for:
- Keystore password (choose a strong password)
- Key password (can be same as keystore)
- Name, organization, location details

### Store Keystore Information

Create `android/key.properties` (DO NOT commit this file):

```properties
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=bilim-key
storeFile=/home/ulan/bilim-release-key.jks
```

### Backup Keystore

**CRITICAL**: Make multiple backups of your keystore file!
- Cloud storage (encrypted)
- External drive
- Password manager (for passwords)

**If you lose this, you cannot update your app!**

## 🏗️ Step 2: Build Release Bundle

### Update Version

Edit `pubspec.yaml`:
```yaml
version: 1.0.0+1
# Format: major.minor.patch+buildNumber
# Increase buildNumber for each release
```

### Build App Bundle (Recommended)

**IMPORTANT:** Always include your API key via `--dart-define` for security:

```bash
# Read API key from .env file
API_KEY=$(grep "^GEMINI_API_KEY=" .env | cut -d '=' -f2)

# Build with secure API key compilation
flutter build appbundle --release --dart-define=GEMINI_API_KEY="$API_KEY"
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### Or Build APK (Alternative)

```bash
# Read API key from .env file
API_KEY=$(grep "^GEMINI_API_KEY=" .env | cut -d '=' -f2)

# Build with secure API key compilation
flutter build apk --release --dart-define=GEMINI_API_KEY="$API_KEY"
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

**Why `--dart-define`?**
- ✅ API key compiled into binary (secure)
- ✅ Not extractable from APK as plain text
- ❌ Without this, app will crash (key not found)

**Note**: Google Play recommends App Bundles (.aab) over APKs for smaller download sizes.

### Verify Build

```bash
# Check bundle size
ls -lh build/app/outputs/bundle/release/app-release.aab

# For APK
ls -lh build/app/outputs/flutter-apk/app-release.apk
```

## 🎨 Step 3: Prepare Store Listing Assets

### App Icon
- Size: 512 x 512 px
- Format: PNG (32-bit)
- No rounded corners (Google adds them)

### Feature Graphic
- Size: 1024 x 500 px
- Format: PNG or JPEG
- Required for featured placement

### Screenshots
Required for at least one device type:

**Phone Screenshots** (Required)
- Minimum: 2 screenshots
- Recommended: 4-8 screenshots
- Size: 1080 x 1920 px or higher
- Format: PNG or JPEG
- Show key features in Kyrgyz and Russian

**Tablet Screenshots** (Optional but recommended)
- Size: 1536 x 2048 px or higher
- Format: PNG or JPEG

### Promo Video (Optional)
- YouTube video URL
- Shows gameplay and features

### Tips for Screenshots:
1. Show the start screen with language selection
2. Show gameplay with Kyrgyz interface
3. Show gameplay with Russian interface
4. Show different scenarios
5. Show the energy system
6. Highlight educational content

## 📝 Step 4: Prepare Store Listing Content

### App Title
- **English**: Knowledge Traveler - Educational RPG
- **Kyrgyz**: Билим Саякатчысы - Билим берүүчү оюн
- **Russian**: Путешественник Знаний - Образовательная игра

Max: 50 characters

### Short Description (Max 80 characters)

**English:**
```
Learn science through adventure! AI-powered educational RPG in Kyrgyz & Russian
```

**Kyrgyz:**
```
Окуя аркылуу илимди үйрөн! Кыргызча жана орусча билим берүүчү оюн
```

**Russian:**
```
Учи науку через приключения! Образовательная RPG на кыргызском и русском
```

### Full Description (Max 4000 characters)

```markdown
🎓 БИЛИМ САЯКАТЧЫСЫ / ПУТЕШЕСТВЕННИК ЗНАНИЙ

Интерактивдүү билим берүүчү оюн кыргыз жана орус тилдеринде!
Интерактивная образовательная игра на кыргызском и русском языках!

📚 ЭМНЕ БУЛ / ЧТО ЭТО?

Билим Саякатчысы - бул илимди кызыктуу кылган окуя стилиндеги оюн. 
Математика, Физика, Химия, Биология жана География сабактарын окуялар 
аркылуу үйрөнүңүз!

Knowledge Traveler - это приключенческая игра, делающая науку увлекательной.
Изучайте Математику, Физику, Химию, Биологию и Географию через истории!

✨ ӨЗГӨЧӨЛҮКТӨР / ОСОБЕННОСТИ

🌍 Эки тилде: Кыргызча жана орусча
   На двух языках: кыргызский и русский

🎯 6-11 класстар үчүн
   Для 6-11 классов

🎮 Үч окуя темасы:
   Три сценария:
   • Келечекке Саякат / Путешествие в будущее
   • Байыркы Кыргызстан / Древний Кыргызстан  
   • Аралда Аман Калуу / Выживание на острове

🤖 AI технологиясы - ар бир оюн уникалдуу!
   Технология AI - каждая игра уникальна!

⚡ Билим энергиясы системасы
   Система энергии знаний

📱 КИМ ҮЧҮН / ДЛЯ КОГО?

• Мектеп окуучулары (6-11 класс)
  Школьники (6-11 класс)
• Илимди жакшы көргөндөр
  Любители науки
• Кыргызча же орусча үйрөнгүсү келгендер
  Изучающие кыргызский или русский язык

🎓 КАНТИП ОЙНОЙБУЗ / КАК ИГРАТЬ

1. Тилди тандаңыз (кыргызча/орусча)
   Выберите язык (кыргызский/русский)
2. Классты тандаңыз
   Выберите класс
3. Окуяны тандаңыз
   Выберите сценарий
4. Илимий билимди колдонуп туура жоопторду тандаңыз!
   Используйте научные знания для правильных ответов!

🎯 МАКСАТ / ЦЕЛЬ

Мектеп окуучуларына илимди кызыктуу жана түшүнүктүү кылуу.
Сделать науку интересной и понятной для школьников.

🔒 КООПСУЗДУК / БЕЗОПАСНОСТЬ

• Балдар үчүн коопсуз контент
  Безопасный контент для детей
• Жарнамасыз
  Без рекламы
• Купуялуулукту коргоо
  Защита конфиденциальности

💡 ТЕХНОЛОГИЯ / ТЕХНОЛОГИЯ

Google Gemini AI аркылуу иштейт - бул ар бир окуяны уникалдуу 
жана кызыктуу кылат!

Работает на Google Gemini AI - это делает каждую историю 
уникальной и увлекательной!

📞 КОЛДОО / ПОДДЕРЖКА

Суроолоруңуз болсо, бизге кайрылыңыз!
Если есть вопросы, свяжитесь с нами!

🇰🇬 Кыргызстандын билим берүү системасы үчүн түзүлгөн
   Создано для образовательной системы Кыргызстана

#Билим #Илим #Окуу #Оюн #Кыргызча #Орусча
#Образование #Наука #Обучение #Игра
```

### Category
Select: **Education**

### Tags/Keywords
```
education, science, kyrgyz, russian, learning, math, physics, chemistry, 
biology, geography, RPG, adventure, AI, Kyrgyzstan, school, students
```

## 🏪 Step 5: Create Play Console App

### 1. Go to Play Console
Visit: https://play.google.com/console

### 2. Create New App

Click "Create app" and fill:
- **App name**: Билим Саякатчысы (Knowledge Traveler)
- **Default language**: Kyrgyz (or Russian)
- **App or game**: Game
- **Free or paid**: Free

### 3. Accept Declarations
- App follows Play policies
- App complies with US export laws

## 📱 Step 6: Complete Store Listing

### Main Store Listing

1. **App details**
   - App name
   - Short description
   - Full description

2. **Graphics**
   - Upload app icon
   - Upload feature graphic
   - Upload screenshots (phone)
   - Upload screenshots (tablet - optional)

3. **Categorization**
   - App category: Education
   - Tags: select relevant tags

4. **Contact details**
   - Email: your-email@example.com
   - Phone: (optional)
   - Website: (if available)

5. **Privacy policy**
   - Required: URL to your privacy policy
   - See Step 10 for creating one

## 🎮 Step 7: Set Up App Content

### 1. Privacy Policy
- URL required
- See Step 10 below

### 2. App Access
- Select "All functionality is available without special access"

### 3. Ads
- Select "No, my app does not contain ads"
- (Update if you add ads later)

### 4. Content Rating
Click "Start questionnaire"

**Basic Info:**
- Email address: your-email@example.com
- App category: Education

**Content Questions:**
Answer questions about:
- Violence
- Sexual content
- Language
- Controlled substances
- Gambling
- User interaction
- Privacy policy

For educational app, most answers will be "No"

**Rating Received:**
Should receive: EVERYONE or PEGI 3

### 5. Target Audience
- **Age range**: 6-12, 13-17
- **Appeals to children**: Yes (educational content)

### 6. News App
- Select "No, my app is not a news app"

### 7. COVID-19 Contact Tracing
- Select "No"

### 8. Data Safety

**Data Collection:**
- Describe what data you collect
- For this app: Minimal data (API usage only)

**Example:**
```
Data collected:
- None personally identifiable

Data shared:
- None

Data security:
- All data transmitted over HTTPS
- No data stored on device
```

## 🚀 Step 8: Release Setup

### 1. Countries/Regions
- Select "Kyrgyzstan" (primary)
- Can add: Russia, Kazakhstan, Uzbekistan, etc.

### 2. Production Track

#### Create Release
1. Go to "Production"
2. Click "Create release"

#### Upload App Bundle
1. Upload: `app-release.aab`
2. Wait for processing (5-15 minutes)

#### Release Name
```
1.0.0 - Initial Release
```

#### Release Notes

**Kyrgyz:**
```
🎉 Биринчи версия!

✨ Эмне бар:
• Кыргызча жана орусча тилдер
• 6-11 класстар үчүн контент
• Үч кызыктуу окуя
• AI аркылуу уникалдуу суроолор
• Билим энергиясы системасы

🎓 Илимди үйрөнүү кызыктуу болсун!
```

**Russian:**
```
🎉 Первая версия!

✨ Что есть:
• Кыргызский и русский языки
• Контент для 6-11 классов
• Три увлекательных сценария
• Уникальные вопросы через AI
• Система энергии знаний

🎓 Пусть наука будет интересной!
```

### 3. Review and Roll Out

1. Review all information
2. Click "Save"
3. Click "Review release"
4. Click "Start rollout to Production"

## ⏱️ Step 9: Review Process

### Timeline
- **Review time**: 1-7 days (usually 2-3 days)
- **Status updates**: Via email and Play Console

### Status Types
- **Pending**: Waiting for review
- **In review**: Google is reviewing
- **Approved**: App is live!
- **Rejected**: Issues found (check email for details)

### Common Rejection Reasons
1. Missing privacy policy
2. App crashes on testing
3. Missing content rating
4. Permissions not justified
5. Incomplete store listing

### If Rejected
1. Read rejection email carefully
2. Fix issues mentioned
3. Create new release
4. Submit again

## 🔐 Step 10: Privacy Policy

Create a privacy policy page. Here's a template:

```markdown
# Privacy Policy for Билим Саякатчысы

Last updated: [Date]

## Overview
Билим Саякатчысы ("Knowledge Traveler") is an educational game for students.

## Data Collection
We collect minimal data:
- No personal information is collected
- No user accounts required
- No data stored on our servers

## Third-Party Services
We use:
- Google Gemini AI: For generating educational content
  - Requests are anonymous
  - No personal data shared
  - See: https://policies.google.com/privacy

## Internet Access
Internet required for:
- AI-generated educational content
- App updates

## Children's Privacy
This app is designed for children (ages 6-17):
- No data collection
- No advertisements
- No in-app purchases
- No social features

## Data Security
- All communication uses HTTPS
- No data stored locally
- No tracking or analytics

## Changes
We may update this policy. Check this page for updates.

## Contact
For questions: your-email@example.com

---

# Купуялуулук Саясаты

Билим Саякатчысы окуучулар үчүн билим берүүчү оюн.

## Маалыматтарды чогултуу
Биз минималдуу маалымат чогултабыз:
- Жеке маалымат чогултулбайт
- Аккаунт талап кылынбайт
- Биздин серверлерде маалымат сакталбайт

[Continue in Kyrgyz...]

---

# Политика Конфиденциальности

Билим Саякатчысы - образовательная игра для школьников.

## Сбор данных
Мы собираем минимум данных:
- Не собираем личную информацию
- Не требуется учетная запись
- Не храним данные на наших серверах

[Continue in Russian...]
```

Host this on:
- GitHub Pages (free)
- Your website
- Google Sites (free)

## 📊 Step 11: Post-Launch

### Monitor Performance

**Key Metrics:**
- Installations
- Ratings and reviews
- Crashes and ANRs (Application Not Responding)
- User retention

**Play Console Sections:**
- Dashboard: Overview
- Statistics: Detailed metrics
- Reviews: User feedback
- Crashes: Technical issues

### Update Strategy

**When to Update:**
- Bug fixes: Immediately
- New features: Monthly/quarterly
- Security updates: Immediately

**Version Numbering:**
```
1.0.0+1 -> Initial release
1.0.1+2 -> Bug fix
1.1.0+3 -> New features
2.0.0+4 -> Major update
```

### Responding to Reviews

**Best Practices:**
1. Respond within 24-48 hours
2. Thank users for feedback
3. Address issues mentioned
4. Be professional and friendly
5. Use Kyrgyz/Russian based on review language

**Template Responses:**

*For Positive Reviews (Kyrgyz):*
```
Рахмат! Биз силердин кубанычтарыңызга абдан кубанабыз! 
🎓 Илимди үйрөнүү ар дайым кызыктуу болсун!
```

*For Positive Reviews (Russian):*
```
Спасибо! Мы очень рады вашей поддержке! 
🎓 Пусть изучение науки всегда будет интересным!
```

*For Bugs/Issues (Kyrgyz):*
```
Маалымдагандарыңыз үчүн рахмат. Биз бул маселени чечүү үчүн иштеп 
жатабыз. Жаңыртуу жакында чыгат!
```

*For Bugs/Issues (Russian):*
```
Спасибо за информацию. Мы работаем над решением этой проблемы. 
Обновление выйдет в ближайшее время!
```

### Marketing

**Promote your app:**
1. School presentations
2. Social media (Facebook, Instagram)
3. Education forums in Kyrgyzstan
4. Teacher communities
5. Parent groups

**QR Code:**
Generate a QR code linking to your Play Store page for easy sharing.

## 🎯 Optimization Tips

### ASO (App Store Optimization)

1. **Keywords**
   - Use Kyrgyz and Russian keywords
   - Include: билим, илим, оюн, окуу, образование, наука

2. **Screenshots**
   - Show actual gameplay
   - Add text overlays explaining features
   - Use both languages

3. **Regular Updates**
   - Updates improve Play Store ranking
   - Fix bugs promptly
   - Add new content regularly

4. **Encourage Reviews**
   - Ask satisfied users to rate
   - Respond to all reviews
   - Maintain 4+ star rating

### Technical Optimization

1. **App Size**
   - Keep under 50MB if possible
   - Use App Bundle (not APK)
   - Compress assets

2. **Performance**
   - Test on low-end devices
   - Optimize API calls
   - Monitor crash rate (keep < 1%)

3. **Battery Usage**
   - Minimize background activity
   - Optimize network requests

## ✅ Launch Checklist

Before submitting:

- [ ] App tested on multiple devices
- [ ] No crashes or critical bugs
- [ ] All strings translated (Kyrgyz & Russian)
- [ ] Privacy policy URL ready
- [ ] App icon (512x512) ready
- [ ] Feature graphic (1024x500) ready
- [ ] Phone screenshots (min 2) ready
- [ ] Release notes written
- [ ] Content rating completed
- [ ] Data safety form filled
- [ ] App signed with release keystore
- [ ] Version number updated
- [ ] Internet permission added
- [ ] ProGuard rules configured
- [ ] **🔒 API key security verified** (see SECURITY.md)
- [ ] **API key NOT extractable from APK**
- [ ] **Google Cloud API restrictions configured**
- [ ] **SHA-1 fingerprint added to API restrictions**
- [ ] **Billing alerts configured**
- [ ] Test on Android 5.0 (API 21) minimum

## 🆘 Troubleshooting

### Upload Issues

**"Invalid signature"**
- Ensure app is signed with release keystore
- Check key.properties file

**"Version code already used"**
- Increment version code in pubspec.yaml

**"Bundle too large"**
- Compress assets
- Remove unused resources
- Use App Bundle instead of APK

### Review Rejections

**"App crashes"**
- Test thoroughly on multiple devices
- Check crash reports in Play Console
- Fix and resubmit

**"Privacy policy missing"**
- Ensure URL is accessible
- URL must use HTTPS

**"Permissions not justified"**
- Remove unused permissions from AndroidManifest.xml
- Justify in privacy policy

## 📞 Support Resources

- **Play Console Help**: https://support.google.com/googleplay/android-developer
- **Flutter Documentation**: https://docs.flutter.dev
- **Play Policies**: https://play.google.com/about/developer-content-policy/

## 🎉 Success!

Once approved:
1. Share with schools and students
2. Gather feedback
3. Plan updates
4. Monitor performance
5. Celebrate! 🎊

---

**Good luck with your launch! Ийгилик каалайбыз! Удачи!**

