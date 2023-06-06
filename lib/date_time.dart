// return todays date formatted as yyyymmdd
import 'package:intl/intl.dart';

String todaysDateFormatted() {
  DateTime dateTimeObject = DateTime.now();

  String year = dateTimeObject.year.toString();
  String month = dateTimeObject.month.toString();
  if (month.length == 1) {
    month = "0$month";
  }

  String day = dateTimeObject.day.toString();
  if (day.length == 1) {
    day = "0$day";
  }

  String yyyymmdd = year + month + day;
  return yyyymmdd;
}

// convert yyyymmdd to DateTime
DateTime createDateTimeObject(String yyyymmdd) {
  int yyyy = int.parse(yyyymmdd.substring(0, 4));
  int mm = int.parse(yyyymmdd.substring(4, 6));
  int dd = int.parse(yyyymmdd.substring(6, 8));

  DateTime dateTimeObject = DateTime(yyyy, mm, dd);
  return dateTimeObject;
}

String convertDateTimeZToString(DateTime dateTimeZ) {
  // Format the date as a string without the time zone indicator
  String formattedDate =
      DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(dateTimeZ);
  return formattedDate;
}

// return todays date formatted as yyyymmdd
String convertDateTimeToString(DateTime dateTime) {
  DateTime dateTimeObject = dateTime;

  String year = dateTimeObject.year.toString();
  String month = dateTimeObject.month.toString();
  if (month.length == 1) {
    month = "0$month";
  }

  String day = dateTimeObject.day.toString();
  if (day.length == 1) {
    day = "0$day";
  }

  String yyyymmdd = year + month + day;
  return yyyymmdd;
}
