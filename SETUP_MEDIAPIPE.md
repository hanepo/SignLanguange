# MediaPipe Hand Landmarker Setup Guide

## Required File: hand_landmarker.task

The SIGNLINK app requires the MediaPipe HandLandmarker model file to detect hand landmarks. This file is **NOT** included in the repository and must be downloaded separately.

## Download Instructions

### Option 1: Direct Download (Recommended)

1. Visit the official MediaPipe Solutions page:
   https://developers.google.com/mediapipe/solutions/vision/hand_landmarker

2. Scroll to the **Models** section

3. Download the **hand_landmarker.task** file (approximately 10-20 MB)

### Option 2: Download from GitHub

```bash
# Download using wget
wget https://storage.googleapis.com/mediapipe-models/hand_landmarker/hand_landmarker/float16/1/hand_landmarker.task

# Or using curl
curl -O https://storage.googleapis.com/mediapipe-models/hand_landmarker/hand_landmarker/float16/1/hand_landmarker.task
```

## Installation

### Step 1: Create Assets Directory

```bash
cd signlink_app
mkdir -p android/app/src/main/assets
```

### Step 2: Copy Model File

Place the downloaded `hand_landmarker.task` file into:
```
android/app/src/main/assets/hand_landmarker.task
```

### Step 3: Verify

Check that the file exists:

**Windows:**
```cmd
dir android\app\src\main\assets\hand_landmarker.task
```

**Linux/Mac:**
```bash
ls -lh android/app/src/main/assets/hand_landmarker.task
```

You should see a file around 10-20 MB in size.

## Important Notes

- **File name must be exact**: `hand_landmarker.task` (not `hand-landmarker.task` or any variation)
- **Location must be exact**: `android/app/src/main/assets/` (this folder is bundled into the APK)
- **Do not modify the file**: Use the official MediaPipe model as-is

## Verification

After adding the file, rebuild the app:

```bash
flutter clean
flutter pub get
flutter run
```

If the file is missing or incorrectly placed, you'll see this error:
```
java.io.FileNotFoundException: hand_landmarker.task
```

## Model Information

- **Model**: MediaPipe HandLandmarker
- **Type**: Float16 (recommended for mobile)
- **Input**: RGB image frames
- **Output**: 21 hand landmarks (x, y, z coordinates)
- **Use case**: Real-time hand tracking and gesture recognition

## License

The MediaPipe HandLandmarker model is provided by Google under the Apache License 2.0. See:
https://github.com/google/mediapipe/blob/master/LICENSE

## Troubleshooting

### Error: Model file not found
- Ensure the file is in the correct directory
- Check file permissions (should be readable)
- Rebuild the app after adding the file

### Error: Model loading failed
- Verify the downloaded file is not corrupted
- Re-download the model from the official source
- Check that the file size matches (approximately 10-20 MB)

### Performance issues
- The float16 model is optimized for mobile devices
- If performance is poor, try:
  - Reducing camera resolution in MainActivity.kt
  - Increasing frame skip in the analyzer
  - Lowering confidence thresholds

## Alternative Models

MediaPipe also provides:
- **hand_landmarker_lite.task**: Lighter model, faster but less accurate
- **hand_landmarker_full.task**: Heavier model, more accurate but slower

To use an alternative model:
1. Download the desired model file
2. Rename it to `hand_landmarker.task` OR
3. Update the model path in [MainActivity.kt](android/app/src/main/kotlin/com/example/signlink_app/MainActivity.kt):
   ```kotlin
   val baseOptions = BaseOptions.builder()
       .setModelAssetPath("your_model_name.task")
       .build()
   ```

## Support

For MediaPipe-specific questions, visit:
- Official Docs: https://developers.google.com/mediapipe
- GitHub Issues: https://github.com/google/mediapipe/issues
