class GestureRules {
  static Map<String, bool> _fingerStates(List<List<double>> p) {
    // p: 21 x [x,y,z], normalized (0..1)
    bool indexOpen  = p[8][1] < p[5][1];
    bool middleOpen = p[12][1] < p[9][1];
    bool ringOpen   = p[16][1] < p[13][1];
    bool pinkyOpen  = p[20][1] < p[17][1];

    // crude handedness: compare x of pinky base vs index base
    bool rightHand = p[17][0] > p[5][0];

    bool thumbOpen;
    if (rightHand) {
      thumbOpen = p[4][0] > p[3][0];
    } else {
      thumbOpen = p[4][0] < p[3][0];
    }

    return {
      'thumb':  thumbOpen,
      'index':  indexOpen,
      'middle': middleOpen,
      'ring':   ringOpen,
      'pinky':  pinkyOpen,
      'right':  rightHand,
    };
  }

  static String classify(List<List<double>>? pts) {
    if (pts == null || pts.length < 21) return '';

    final f = _fingerStates(pts);
    final t = f['thumb']!, i = f['index']!, m = f['middle']!, r = f['ring']!, p = f['pinky']!;

    // Starter rules — tune thresholds per device & BIM shapes:

    // HELLO: all open (wave gesture; we just map to open hand)
    if (t && i && m && r && p) return 'HELLO';

    // YES: fist
    if (!t && !i && !m && !r && !p) return 'YES';

    // NO: index + middle open (simple approximation)
    if (!t && i && m && !r && !p) return 'NO';

    // I LOVE YOU: thumb + index + pinky open
    if (t && i && !m && !r && p) return 'I LOVE YOU';

    // GOOD/OK (thumbs up)
    if (t && !i && !m && !r && !p) return 'GOOD';

    // THANK YOU: similar to GOOD but detected differently
    // For now, using a variation where thumb + pinky are open
    if (t && !i && !m && !r && p) return 'THANK YOU';

    // EAT: fingertips near mouth (avg tip y close to wrist y)
    final wrist = pts[0];
    final avgTipY = (pts[8][1] + pts[12][1] + pts[16][1] + pts[20][1]) / 4.0;
    if (!t && (avgTipY > wrist[1] - 0.05)) return 'EAT';

    return '';
  }
}
