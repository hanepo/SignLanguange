class GestureSmoother {
  String _last = '';
  int _count = 0;
  final int threshold; // frames

  GestureSmoother({this.threshold = 5});

  String update(String current) {
    if (current.isEmpty) { _last = ''; _count = 0; return ''; }
    if (current == _last) {
      _count++;
    } else {
      _last = current;
      _count = 1;
    }
    return _count >= threshold ? current : '';
  }
}
