# Gesture Recognition Guide

## Supported Gestures

The SIGNLINK app currently recognizes 7 basic Malaysian Sign Language (BIM) gestures using rule-based classification.

### 1. HELLO
- **Description**: Open hand, gentle wave
- **Detection Rule**: All 5 fingers extended (thumb, index, middle, ring, pinky all open)
- **Use Case**: Greeting

### 2. YES
- **Description**: Fist nodding motion
- **Detection Rule**: All fingers closed (fist position)
- **Use Case**: Affirmation

### 3. NO
- **Description**: Index and middle fingers extended
- **Detection Rule**: Index and middle fingers open, thumb/ring/pinky closed
- **Use Case**: Negation, peace sign

### 4. I LOVE YOU
- **Description**: ILY sign (thumb, index, pinky extended)
- **Detection Rule**: Thumb, index, and pinky open; middle and ring closed
- **Use Case**: Expression of affection

### 5. GOOD / OK
- **Description**: Thumbs up
- **Detection Rule**: Thumb extended, all other fingers closed
- **Use Case**: Approval, agreement

### 6. THANK YOU
- **Description**: Modified hand position
- **Detection Rule**: Thumb and pinky extended, other fingers closed
- **Use Case**: Gratitude (simplified detection)

### 7. EAT
- **Description**: Fingertips near mouth
- **Detection Rule**: Fingers closed with fingertips near mouth region (detected via y-coordinate proximity to wrist)
- **Use Case**: Food, eating

## Hand Landmark Reference

MediaPipe HandLandmarker detects 21 landmarks:

```
WRIST = 0

THUMB:  1 (CMC), 2 (MCP), 3 (IP), 4 (TIP)
INDEX:  5 (MCP), 6 (PIP), 7 (DIP), 8 (TIP)
MIDDLE: 9 (MCP), 10 (PIP), 11 (DIP), 12 (TIP)
RING:   13 (MCP), 14 (PIP), 15 (DIP), 16 (TIP)
PINKY:  17 (MCP), 18 (PIP), 19 (DIP), 20 (TIP)
```

Where:
- **CMC**: Carpometacarpal joint
- **MCP**: Metacarpophalangeal joint (knuckle)
- **PIP**: Proximal interphalangeal joint
- **DIP**: Distal interphalangeal joint
- **IP**: Interphalangeal joint (thumb only)
- **TIP**: Fingertip

## How Detection Works

### Finger State Detection

Each finger is classified as **OPEN** or **CLOSED** based on simple coordinate comparisons:

**For Index, Middle, Ring, Pinky:**
- **OPEN** if: `fingertip.y < knuckle.y` (tip is above knuckle)
- **CLOSED** if: `fingertip.y >= knuckle.y` (tip is below knuckle)

**For Thumb:**
- Detection uses x-coordinate comparison
- Depends on handedness (left vs right hand)
- **Right hand**: OPEN if `tip.x > ip.x`
- **Left hand**: OPEN if `tip.x < ip.x`

### Handedness Detection

The system determines left vs right hand using:
```dart
rightHand = pinky_knuckle.x > index_knuckle.x
```

### Temporal Smoothing

To prevent flickering detections:
- Gestures must be held steady for **5 consecutive frames** (configurable)
- Only then will the stable text update
- Raw detection is still shown for debugging

## Tuning Gesture Detection

### Adjusting Sensitivity

Edit [lib/services/gesture_rules.dart](lib/services/gesture_rules.dart:1):

1. **Change finger thresholds**: Modify the y-coordinate comparisons
   ```dart
   bool indexOpen = p[8][1] < p[5][1] - 0.05; // Add margin
   ```

2. **Adjust smoothing**: Edit [lib/services/smoother.dart](lib/services/smoother.dart:1)
   ```dart
   GestureSmoother(threshold: 7); // Increase from 5 to 7 frames
   ```

3. **Add angle-based detection**: Calculate joint angles for more precision
   ```dart
   double angle = angleAt(p[6], p[7], p[8]); // PIP-DIP-TIP
   if (angle < 0.5) { /* finger is straight */ }
   ```

### Adding New Gestures

To add a new gesture:

1. Open [lib/services/gesture_rules.dart](lib/services/gesture_rules.dart:1)
2. Add a new condition in the `classify()` method:
   ```dart
   // NEW GESTURE: Pointing (index extended, others closed)
   if (!t && i && !m && !r && !p) return 'POINTING';
   ```
3. Add the corresponding image to `assets/pointing.png`
4. Update [lib/screens/learn_screen.dart](lib/screens/learn_screen.dart:1) with the new gesture

### Common Adjustments

**If gestures are not detected:**
- Flip coordinate comparisons (camera may be mirrored)
- Reduce threshold margins
- Increase temporal smoothing

**If wrong gestures are detected:**
- Add more specific conditions
- Use angle-based detection
- Add distance-based checks

**If detection is too sensitive:**
- Increase smoother threshold
- Add stricter margins to finger states

## Testing Tips

1. **Good Lighting**: Ensure adequate lighting for camera
2. **Hand Position**: Keep hand centered in camera view
3. **Distance**: Hold hand 30-50cm from camera
4. **Background**: Use plain background for better detection
5. **Speed**: Hold gestures steady for 0.5-1.0 seconds

## Limitations

Current rule-based system has limitations:

- **Static gestures only**: No motion-based signs
- **Single hand**: Only detects one hand at a time
- **Simplified rules**: May not match exact BIM specifications
- **No context**: Cannot build sentences or handle compound signs
- **Camera dependent**: Performance varies with device and lighting

## Future Improvements

To enhance detection accuracy:

1. **Add angle-based rules** for finger joints
2. **Implement distance normalization** (palm size)
3. **Add temporal patterns** for motion-based signs
4. **Support two-handed gestures**
5. **Add training mode** with visual feedback
6. **Implement gesture history** for sentence building

## Troubleshooting

### Gesture not detected
- Check lighting conditions
- Ensure hand is fully visible
- Try adjusting hand position
- Increase temporal smoothing threshold

### Wrong gesture detected
- Hold hand steady
- Ensure finger positions are distinct
- Check camera orientation
- Adjust detection rules

### Detection flickers
- Increase smoother threshold
- Add margin to coordinate comparisons
- Reduce camera FPS
- Ensure stable hand position

## References

- **MediaPipe Hand Landmarks**: https://developers.google.com/mediapipe/solutions/vision/hand_landmarker
- **BIM Resources**: Malaysian Sign Language references (to be added)
- **Code Location**: [lib/services/gesture_rules.dart](lib/services/gesture_rules.dart:1)
