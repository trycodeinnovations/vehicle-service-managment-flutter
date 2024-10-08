import 'package:flutter_car_service/Api_integration/ServicedetailsGet.dart';
import 'package:intl/intl.dart';

 String daytime(String date) {
  
  
   DateTime parsedDate = DateTime.parse(date);

  // Get the day name using DateFormat with 'EEEE' pattern
  String dayName = DateFormat('EEEE').format(parsedDate);

  print('Day of the week: $dayName'); // Output: Tuesday
  return dayName;
}
