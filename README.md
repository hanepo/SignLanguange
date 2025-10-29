# SIGNLINK - Malaysian Sign Language (BIM) Translation App

A Flutter mobile app that translates Malaysian Sign Language (BIM) hand gestures to text using **MediaPipe Hands** for landmark detection and **rule-based classification** (no ML training required).

## Features

- **Real-time Translation**: Live camera feed translates BIM gestures to text
- **Learn BIM**: Educational screen with basic sign language gestures
- **No ML Training**: Uses MediaPipe HandLandmarker + pure code rules
- **Gesture Recognition**: Supports HELLO, THANK YOU, YES, NO, I LOVE YOU, EAT, and GOOD

## Architecture

### Flutter (Dart) Layer
- **UI Screens**: Home, Translation, Learn
- **Services**:
  - `HandStream`: MethodChannel communication with Android native
  - `GestureRules`: Rule-based gesture classification
  - `GestureSmoother`: Temporal smoothing to prevent flicker

### Android Native (Kotlin) Layer
- **CameraX**: Live camera stream processing
- **MediaPipe Tasks HandLandmarker**: 21-point hand landmark detection
- **MethodChannel**: Sends landmarks to Flutter

## Prerequisites

- Flutter SDK (>=3.3.0)
- Android Studio
- Android device with camera (Android 10+, minSdk 24)
- MediaPipe hand_landmarker.task file

## Setup Instructions

### 1. Install Dependencies

```bash
cd signlink_app
flutter pub get
```

### 2. Add MediaPipe Hand Landmark Model

**IMPORTANT**: You need to download the MediaPipe HandLandmarker task file:

1. Download `hand_landmarker.task` from [MediaPipe Solutions](https://developers.google.com/mediapipe/solutions/vision/hand_landmarker)
2. Create the directory: `android/app/src/main/assets/`
3. Place `hand_landmarker.task` in that directory

```bash
mkdir -p android/app/src/main/assets/
# Copy hand_landmarker.task to android/app/src/main/assets/
```

**Official MediaPipe model download**: Visit https://developers.google.com/mediapipe/solutions/vision/hand_landmarker#models and download the gesture recognizer task file.

### 3. Connect Android Device

- Enable USB debugging on your Android device
- Connect via USB
- Verify device connection:

```bash
flutter devices
```

### 4. Run the App

```bash
flutter run
```

Grant camera permissions when prompted.

## Project Structure

```
signlink_app/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── screens/
│   │   ├── translation_screen.dart  # Live gesture translation
│   │   └── learn_screen.dart        # Educational BIM reference
│   └── services/
│       ├── hand_stream.dart         # MethodChannel handler
│       ├── gesture_rules.dart       # Rule-based classifier
│       └── smoother.dart            # Temporal smoothing
├── android/
│   └── app/src/main/
│       ├── kotlin/.../MainActivity.kt        # CameraX + MediaPipe integration
│       ├── kotlin/.../YuvToRgbConverter.kt  # Image conversion
│       └── assets/
│           └── hand_landmarker.task         # MediaPipe model (YOU MUST ADD THIS)
└── assets/
    ├── hello.png
    ├── thankyou.png
    ├── yes.png
    ├── no.png
    ├── ily.png
    └── eat.png
```

## How It Works

### Gesture Recognition Flow

1. **Camera Capture**: CameraX captures live video frames
2. **YUV to Bitmap**: Convert camera frames to Bitmap format
3. **MediaPipe Processing**: HandLandmarker detects 21 hand landmarks
4. **MethodChannel**: Landmarks sent to Flutter as List<List<double>>
5. **Rule-Based Classification**: Analyze finger states, angles, positions
6. **Temporal Smoothing**: Debounce detections over 5 frames
7. **Display Result**: Show stable gesture text on screen

### Gesture Rules (Simplified)

The classification uses finger open/closed states and simple geometric checks:

- **HELLO**: All fingers open
- **YES**: All fingers closed (fist)
- **NO**: Index + middle fingers open
- **I LOVE YOU**: Thumb + index + pinky open
- **GOOD**: Thumb up (thumb open, others closed)
- **THANK YOU**: Thumb + pinky open
- **EAT**: Fingertips near mouth region

### Tuning Rules

Edit [lib/services/gesture_rules.dart](lib/services/gesture_rules.dart) to:
- Adjust finger open/closed thresholds
- Add angle-based detection
- Implement more complex BIM gestures

**Note**: Camera coordinate systems may vary. If gestures aren't detected correctly:
- Flip comparison operators in `_fingerStates()`
- Adjust handedness detection logic
- Increase `GestureSmoother.threshold` for stability

## Building for Release

```bash
flutter build apk --release
```

APK location: `build/app/outputs/flutter-apk/app-release.apk`

## Troubleshooting

### Camera permission denied
- Check AndroidManifest.xml has `<uses-permission android:name="android.permission.CAMERA" />`
- Grant camera permission in device settings

### MediaPipe model not found
```
Error: java.io.FileNotFoundException: hand_landmarker.task
```
**Solution**: Download and place `hand_landmarker.task` in `android/app/src/main/assets/`

### Gestures not detected correctly
- Try different lighting conditions
- Adjust thresholds in `gesture_rules.dart`
- Increase smoother threshold (e.g., 7-9 frames)
- Check camera preview orientation

### Build errors with Gradle
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

## No Machine Learning Required

This app **does not use**:
- Custom ML model training
- TensorFlow Lite
- On-device learning
- Training datasets

It uses MediaPipe's pre-built HandLandmarker model for landmark detection only. All gesture classification is done via if/else rules in Dart code.

## Client Summary (Malay)

**Aplikasi ini tidak menggunakan machine learning tradisional dan tidak memerlukan dataset latihan.**

Kami guna **MediaPipe Hands** untuk dapatkan 21 titik landmark tangan secara langsung, kemudian gunakan **peraturan kod (rule-based)** untuk kenal pasti isyarat (contoh: ibu jari naik = "GOOD", genggam = "YES", semua jari buka = "HELLO").

**Tiada model yang perlu dilatih** — lebih ringan, pantas, dan mudah dijelaskan.

## Future Enhancements

- Add more BIM gestures
- Implement angle-based detection for complex signs
- Add sentence building from multiple gestures
- Support two-handed gestures
- Add training mode with visual feedback

## License

This project is for educational purposes.

## Credits

- **MediaPipe**: Hand landmark detection
- **Flutter**: Cross-platform UI framework
- **CameraX**: Android camera API
