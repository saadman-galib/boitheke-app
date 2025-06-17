# BoiTheke App Icon Setup

## Steps to Complete Icon Setup:

1. **Save your logo as app_icon.png**
   - Save the provided logo image as `app_icon.png` in the `assets/images/` folder
   - Recommended size: 1024x1024 pixels
   - Format: PNG with transparent background
   - The logo should be centered and sized appropriately with some padding

2. **Generate app icons**
   After placing the logo file, run this command to generate all platform-specific icons:
   ```bash
   flutter packages pub run flutter_launcher_icons:main
   ```

3. **Verify icon generation**
   The command will generate icons for:
   - Android (various sizes in android/app/src/main/res/mipmap-*)
   - iOS (various sizes in ios/Runner/Assets.xcassets/AppIcon.appiconset/)
   - Web (web/icons/)

## Current Configuration:

- **App Name**: BoiTheke (already configured)
- **Theme Color**: Deep Teal (#00695C)
- **Icon Background**: Deep Teal (#00695C)
- **Package**: flutter_launcher_icons v0.13.1 (installed)

## Files Updated:

✅ `pubspec.yaml` - Added flutter_launcher_icons configuration
✅ `android/app/src/main/AndroidManifest.xml` - App name already set to "BoiTheke"
✅ `ios/Runner/Info.plist` - App name updated to "BoiTheke"
✅ `lib/main.dart` - App title already set to "BoiTheke"

## Next Steps:

1. Place your logo file as `assets/images/app_icon.png`
2. Run the icon generation command
3. Test the app to see the new icons
