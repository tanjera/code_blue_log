String formatTime(int seconds) {
  String hh = (seconds ~/ 3600).toString().padLeft(2, '0');
  String mm = ((seconds ~/ 60) % 60).toString().padLeft(2, '0');
  String ss = (seconds % 60).toString().padLeft(2, '0');
  return '$hh:$mm:$ss';
}