import 'package:intl/intl.dart';

customDateTime(DateTime datetime) {
  
  var currentTime = DateTime.now().toLocal();
  print("$datetime $currentTime");

  // check time in range

  if (datetime.isBefore(currentTime)) {
    if (currentTime.compareTo(datetime) == 0) {
      return "${DateFormat.m().format(datetime)} minute";
    }
    // if current hours > hours
    if (currentTime.hour > datetime.hour) {
      return "${DateFormat.H().format(datetime)} hours";
    }
  }
  return DateFormat.yMEd().format(datetime);

  // show min if hour = hour
}
