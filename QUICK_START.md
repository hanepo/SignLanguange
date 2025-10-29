# 🚀 QUICK START - Get SIGNLINK Running Now!

## Current Status

✅ **App built successfully!** The APK was created and installed on your device.

🚨 **CRITICAL**: The app will crash on the Translation screen without the MediaPipe model file.

---

## 🔴 STEP 1: Download MediaPipe Model (REQUIRED)

### Option A: Direct Download (Windows)
Open PowerShell and run:

```powershell
# Create assets directory
New-Item -ItemType Directory -Force -Path "android\app\src\main\assets"

# Download the model file (10-20 MB)
Invoke-WebRequest -Uri "https://storage.googleapis.com/mediapipe-models/hand_landmarker/hand_landmarker/float16/1/hand_landmarker.task" -OutFile "android\app\src\main\assets\hand_landmarker.task"
```

### Option B: Manual Download
1. Click this link: [Download hand_landmarker.task](https://storage.googleapis.com/mediapipe-models/hand_landmarker/hand_landmarker/float16/1/hand_landmarker.task)
2. Save the file (10-20 MB)
3. Create folder: `android\app\src\main\assets\`
4. Move the downloaded file into that folder

### Option C: Using curl (Git Bash on Windows)
```bash
mkdir -p android/app/src/main/assets
curl -L -o android/app/src/main/assets/hand_landmarker.task "https://storage.googleapis.com/mediapipe-models/hand_landmarker/hand_landmarker/float16/1/hand_landmarker.task"
```

---

## ✅ STEP 2: Verify File Exists

**Windows PowerShell:**
```powershell
dir android\app\src\main\assets\hand_landmarker.task
```

**Expected output:**
```
Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---          10/27/2025  10:30 AM       14552472 hand_landmarker.task
```

File should be around **10-20 MB**.

---

## 🏃 STEP 3: Rebuild and Run

Since you already have the emulator running:

```powershell
# Stop the current app (Ctrl+C in the terminal where flutter run is running)

# Rebuild with the model file
flutter run
```

---

## 📱 STEP 4: Test the App

### On the Emulator/Device:

1. **Home Screen**
   - You should see "SIGNLINK" title
   - Two buttons: "Translate (BIM → Text)" and "Learn BIM"

2. **Learn Screen** (Test this first!)
   - Tap "Learn BIM"
   - Should show 6 gestures with images
   - This screen doesn't need the camera

3. **Translation Screen** (Requires camera)
   - Tap "Translate (BIM → Text)"
   - Grant camera permission when prompted
   - **NOTE**: Emulator camera may not work well for hand detection
   - Use a **real Android device** for best results

---

## 🔧 Troubleshooting

### Error: "hand_landmarker.task not found"

**Check file location:**
```powershell
ls android\app\src\main\assets\
```

You should see:
```
hand_landmarker.task
```

If missing, repeat Step 1.

### Error: Camera permission denied

**Solution**: Uninstall and reinstall the app:
```powershell
flutter clean
flutter run
```

Grant permission when prompted.

### App crashes on Translation screen

**Possible causes:**
1. MediaPipe model file missing → Add it (Step 1)
2. Camera not available on emulator → Use real device
3. Permission denied → Grant camera permission

### Emulator camera shows black screen

**This is normal** - Emulator cameras don't work well for hand detection.

**Solution**: Use a real Android device:
1. Enable USB debugging on your phone
2. Connect phone to computer
3. Run `flutter devices` to verify connection
4. Run `flutter run` and select your phone

---

## 📊 Expected Behavior

### ✅ App Working Correctly:

**Home Screen:**
```
┌─────────────────────┐
│     SIGNLINK        │
├─────────────────────┤
│                     │
│  ┌───────────────┐  │
│  │ Translate     │  │
│  │ (BIM → Text)  │  │
│  └───────────────┘  │
│                     │
│  ┌───────────────┐  │
│  │ Learn BIM     │  │
│  └───────────────┘  │
│                     │
└─────────────────────┘
```

**Translation Screen (with hand visible):**
```
┌─────────────────────┐
│ ← [Back]            │
│                     │
│                     │
│      HELLO          │ ← Stable text
│                     │
│                     │
│ detecting: HELLO    │ ← Raw detection
└─────────────────────┘
```

**Learn Screen:**
```
┌─────────────────────┐
│ ← Learn BIM Basics  │
├─────────────────────┤
│ [img] HELLO         │
│       Open hand...  │
├─────────────────────┤
│ [img] THANK YOU     │
│       Fingers from..│
├─────────────────────┤
│ ... (4 more)        │
└─────────────────────┘
```

---

## 🎯 Testing Gestures (Real Device Only)

Once you have a real device connected:

1. **Open Translation screen**
2. **Hold hand 30-50cm from camera**
3. **Try these gestures:**

   - ✋ **HELLO**: All 5 fingers open
   - ✊ **YES**: Closed fist
   - ✌️ **NO**: Peace sign (index + middle)
   - 🤟 **I LOVE YOU**: Thumb + index + pinky
   - 👍 **GOOD**: Thumbs up
   - 🤙 **THANK YOU**: Shaka sign (thumb + pinky)
   - 🍽️ **EAT**: Bring fingers to mouth

4. **Hold each gesture for 1 second**
5. **Text should appear after ~0.5-1 seconds**

---

## 🚀 Quick Command Reference

```powershell
# Download model (PowerShell)
New-Item -ItemType Directory -Force -Path "android\app\src\main\assets"
Invoke-WebRequest -Uri "https://storage.googleapis.com/mediapipe-models/hand_landmarker/hand_landmarker/float16/1/hand_landmarker.task" -OutFile "android\app\src\main\assets\hand_landmarker.task"

# Verify file
dir android\app\src\main\assets\hand_landmarker.task

# Run app
flutter run

# If issues, clean and rebuild
flutter clean
flutter pub get
flutter run
```

---

## 📞 Need Help?

1. **MediaPipe model issues**: See [SETUP_MEDIAPIPE.md](SETUP_MEDIAPIPE.md)
2. **Gesture detection problems**: See [GESTURE_GUIDE.md](GESTURE_GUIDE.md)
3. **General setup**: See [README.md](README.md)
4. **Build errors**: See [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md)

---

## ✅ Success Checklist

- [ ] MediaPipe model file downloaded
- [ ] File placed in `android\app\src\main\assets\hand_landmarker.task`
- [ ] File size is 10-20 MB
- [ ] App rebuilds without errors
- [ ] Home screen appears
- [ ] Learn screen works
- [ ] Translation screen opens (may need real device)
- [ ] Gestures detected (requires real device camera)

**Current Status**: App built ✅ | Model file needed 🚨 | Ready to test after Step 1 ✅
