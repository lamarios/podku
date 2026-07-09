const double pu = 4;
const double pu2 = pu*2;
const double pu3 = pu*3;
const double pu4 = pu*4;
const double pu5 = pu*5;
const double pu6 = pu*6;
const double pu7 = pu*7;
const double pu8 = pu*8;



String printDuration(Duration duration) {
  String negativeSign = duration.isNegative ? '-' : '';
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
  return "$negativeSign${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}