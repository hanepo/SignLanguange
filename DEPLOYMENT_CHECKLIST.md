# SIGNLINK Deployment Checklist

## Pre-Deployment Steps

### ✅ Code Complete
- [x] Flutter app implemented (3 screens)
- [x] Android native code (CameraX + MediaPipe)
- [x] MethodChannel communication bridge
- [x] Rule-based gesture classifier
- [x] Temporal smoothing service
- [x] Tests passing (`flutter test`)

### 🚨 CRITICAL: MediaPipe Model
- [ ] **Download `hand_landmarker.task`**
  - URL: https://storage.googleapis.com/mediapipe-models/hand_landmarker/hand_landmarker/float16/1/hand_landmarker.task
  - Size: ~10-20 MB
  - See [SETUP_MEDIAPIPE.md](SETUP_MEDIAPIPE.md:1) for details

- [ ] **Create assets directory**
  ```bash
  mkdir android/app/src/main/assets
  ```

- [ ] **Place model file**
  ```
  android/app/src/main/assets/hand_landmarker.task
  ```

- [ ] **Verify file exists**
  ```bash
  # Windows
  dir android\app\src\main\assets\hand_landmarker.task

  # Linux/Mac
  ls -lh android/app/src/main/assets/hand_landmarker.task
  ```

### ✅ Dependencies
- [x] Flutter dependencies installed (`flutter pub get`)
- [x] Android Gradle dependencies configured
- [x] Camera plugin added
- [x] Provider plugin added

### ✅ Configuration
- [x] Android permissions (CAMERA)
- [x] minSdk 24, targetSdk 34
- [x] MultiDex enabled
- [x] CameraX dependencies
- [x] MediaPipe Tasks Vision dependency

### ✅ Assets
- [x] 6 placeholder images created
- [x] Assets declared in pubspec.yaml
- [x] Images accessible in app

### ✅ Documentation
- [x] README.md complete
- [x] SETUP_MEDIAPIPE.md created
- [x] GESTURE_GUIDE.md created
- [x] PROJECT_SUMMARY.md created

## Build Process

### 1. Clean Build
```bash
cd signlink_app
flutter clean
flutter pub get
```

### 2. Verify MediaPipe Model
```bash
# Ensure this file exists!
ls android/app/src/main/assets/hand_landmarker.task
```

### 3. Check Connected Device
```bash
flutter devices
```

Expected output:
```
Android SDK built for x86 • emulator-5554 • android-x86 • Android 10 (API 29) (emulator)
```
OR
```
[Device Name] • [Device ID] • android-arm64 • Android 11 (API 30) (mobile)
```

### 4. Build APK (Debug)
```bash
flutter build apk --debug
```

Output location: `build/app/outputs/flutter-apk/app-debug.apk`

### 5. Build APK (Release)
```bash
flutter build apk --release
```

Output location: `build/app/outputs/flutter-apk/app-release.apk`

## Testing Checklist

### Pre-Launch Testing
- [ ] App installs successfully
- [ ] App launches without crashes
- [ ] Camera permission prompt appears
- [ ] Camera permission can be granted

### UI Testing
- [ ] Home screen displays "SIGNLINK" title
- [ ] "Translate (BIM → Text)" button visible
- [ ] "Learn BIM" button visible
- [ ] Buttons are clickable
- [ ] Navigation works correctly
- [ ] Back button returns to home

### Translation Screen Testing
- [ ] Screen opens after clicking "Translate" button
- [ ] Camera initializes (may take 2-5 seconds)
- [ ] Black screen with text overlay appears
- [ ] Hand detection starts automatically
- [ ] Raw detection text shows at bottom
- [ ] Stable text shows at center

### Gesture Recognition Testing

Test each gesture in good lighting:

#### HELLO
- [ ] Show open hand with all 5 fingers extended
- [ ] Hold for 1 second
- [ ] "HELLO" appears as stable text

#### YES
- [ ] Make a fist (all fingers closed)
- [ ] Hold for 1 second
- [ ] "YES" appears as stable text

#### NO
- [ ] Extend index and middle fingers (peace sign)
- [ ] Hold for 1 second
- [ ] "NO" appears as stable text

#### I LOVE YOU
- [ ] Extend thumb, index, and pinky (ILY sign)
- [ ] Keep middle and ring fingers closed
- [ ] Hold for 1 second
- [ ] "I LOVE YOU" appears as stable text

#### GOOD
- [ ] Thumbs up gesture
- [ ] Hold for 1 second
- [ ] "GOOD" appears as stable text

#### THANK YOU
- [ ] Extend thumb and pinky (shaka sign)
- [ ] Hold for 1 second
- [ ] "THANK YOU" appears as stable text

#### EAT
- [ ] Bring fingertips to mouth
- [ ] Hold for 1 second
- [ ] "EAT" appears as stable text

### Learn Screen Testing
- [ ] Screen opens after clicking "Learn BIM" button
- [ ] 6 gesture items displayed
- [ ] Each item shows image, title, and description
- [ ] Images load correctly
- [ ] Scrolling works smoothly
- [ ] Back button returns to home

### Edge Case Testing
- [ ] No hand in view → displays "—"
- [ ] Multiple gestures in sequence → detects each
- [ ] Rapid gesture changes → no crashes
- [ ] Poor lighting → handles gracefully (may not detect)
- [ ] Hand partially out of frame → no false positives
- [ ] App backgrounded and resumed → continues working

### Performance Testing
- [ ] Camera feed responsive (no lag)
- [ ] Gesture detection < 500ms delay
- [ ] No memory leaks after 5 minutes of use
- [ ] Battery drain acceptable
- [ ] CPU usage reasonable

## Common Issues & Solutions

### Issue: MediaPipe model not found
**Symptom**: `java.io.FileNotFoundException: hand_landmarker.task`

**Solution**:
```bash
# Verify file exists
ls android/app/src/main/assets/hand_landmarker.task

# If missing, download it:
curl -O https://storage.googleapis.com/mediapipe-models/hand_landmarker/hand_landmarker/float16/1/hand_landmarker.task
mv hand_landmarker.task android/app/src/main/assets/
```

### Issue: Camera permission denied
**Symptom**: Black screen, no camera feed

**Solution**:
- Check AndroidManifest.xml has camera permission
- Uninstall app and reinstall
- Manually grant camera permission in device settings

### Issue: Gestures not detected
**Symptom**: "—" displayed even when making gestures

**Solution**:
- Ensure good lighting
- Hold hand 30-50cm from camera
- Hold gesture steady for 1-2 seconds
- Try adjusting finger positions
- Check [GESTURE_GUIDE.md](GESTURE_GUIDE.md:1) for tuning

### Issue: Build fails with Gradle errors
**Symptom**: `FAILURE: Build failed with an exception`

**Solution**:
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Issue: Tests fail
**Symptom**: Widget tests don't pass

**Solution**:
```bash
flutter pub get
flutter test
```

## Release Preparation

### Before Release
- [ ] Update version in pubspec.yaml
- [ ] Test on multiple devices
- [ ] Test in different lighting conditions
- [ ] Document known limitations
- [ ] Update README with actual device test results

### App Signing (Production)
If publishing to Play Store:

1. Generate keystore:
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. Update `android/app/build.gradle.kts` with signing config

3. Build signed APK:
```bash
flutter build apk --release
```

### APK Distribution
- **Debug APK**: For internal testing
  - Location: `build/app/outputs/flutter-apk/app-debug.apk`
  - Size: ~50-70 MB

- **Release APK**: For production
  - Location: `build/app/outputs/flutter-apk/app-release.apk`
  - Size: ~30-50 MB (optimized)

## QA Sign-Off

### Functional Requirements
- [ ] Real-time hand gesture detection
- [ ] 7 gestures recognized correctly
- [ ] Educational Learn screen
- [ ] No ML training required
- [ ] MediaPipe integration works

### Non-Functional Requirements
- [ ] Builds successfully on Android
- [ ] Runs on Android 7.0+ (API 24+)
- [ ] Camera permission handling
- [ ] Smooth UI interactions
- [ ] Acceptable performance

### Documentation Requirements
- [ ] README complete with setup instructions
- [ ] MediaPipe model download guide
- [ ] Gesture tuning documentation
- [ ] Troubleshooting guide
- [ ] Code comments present

## Final Verification

Run this command to verify everything:
```bash
# Clean and rebuild
flutter clean
flutter pub get

# Run tests
flutter test

# Analyze code
flutter analyze

# Build release APK
flutter build apk --release
```

All should complete without errors (except assets warnings - those are expected until MediaPipe model is added).

## Deployment Status

**Current Status**: ✅ **READY FOR TESTING**

**Blockers**:
- 🚨 **CRITICAL**: MediaPipe `hand_landmarker.task` must be added before running

**Next Steps**:
1. Download MediaPipe model
2. Add to `android/app/src/main/assets/`
3. Run `flutter run` on Android device
4. Test all gestures
5. Document results

## Sign-Off

### Developer
- [ ] Code complete and tested
- [ ] Documentation complete
- [ ] Known issues documented
- [ ] Ready for QA testing

Date: _______________
Signature: _______________

### QA Tester
- [ ] All functional tests passed
- [ ] All gestures working correctly
- [ ] Performance acceptable
- [ ] No critical bugs found

Date: _______________
Signature: _______________

### Client/Stakeholder
- [ ] App meets requirements
- [ ] Gestures accurately detected
- [ ] Educational content adequate
- [ ] Approved for release/deployment

Date: _______________
Signature: _______________

---

**Build Version**: 1.0.0+1
**Last Updated**: 2025-10-27
**Status**: ✅ Code Complete, Awaiting MediaPipe Model
