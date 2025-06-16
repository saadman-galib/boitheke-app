## Running BoiTheke on Android

### Prerequisites
1. Ensure you have Flutter installed and configured
2. Have an Android device connected via USB with USB debugging enabled, OR
3. Have an Android emulator running

### Quick Start Commands

#### Check device connection:
```bash
flutter devices
```

#### Run on connected device/emulator:
```bash
flutter run
```

#### Build and install debug APK:
```bash
flutter build apk --debug
flutter install
```

#### Build release APK:
```bash
flutter build apk --release
```

### App Features to Test
1. **Splash Screen** - Beautiful animated logo with Bengali/English toggle
2. **Onboarding** - Swipeable introduction screens  
3. **Home Page** - Browse books by categories, search functionality
4. **Explore Page** - Filter books by type, language, rating
5. **Reader Page** - PDF-style reading with font controls and night mode
6. **Upload Page** - Mock book publishing interface
7. **User Dashboard** - Saved books, reading history, following authors
8. **Profile Pages** - Author and organization profiles with follow functionality

### App Configuration
- Package Name: `com.boitheke.app`
- App Name: `BoiTheke`
- Permissions: Internet access for image loading
- Target SDK: Latest Flutter default
- Minimum SDK: Flutter default (usually API 21+)

### Troubleshooting
- If build fails, run `flutter clean && flutter pub get`
- Ensure Android SDK and build tools are up to date
- Check device connection with `adb devices`
