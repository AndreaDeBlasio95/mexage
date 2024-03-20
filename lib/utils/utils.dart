import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class Utils {
  static String formatNumber(int number) {
    if (number < 1000) {
      return number.toString();
    } else if (number < 1000000) {
      double result = number / 1000.0;
      return '${result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 2)} K';
    } else {
      double result = number / 1000000.0;
      return '${result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 2)} M';
    }
  }

  static String getUserCountry() {
    try {
      String locale = Platform.localeName;
      List<String> parts = locale.split('_');
      if (parts.length > 1) {
        String country = parts[1]; // Extract the country from the locale
        return country;
      } else {
        return ''; // Unable to extract country from locale
      }
    } catch (e) {
      print('Error getting user country: $e');
      return ''; // Return empty string in case of error
    }
  }

  static String timestampToDate(Timestamp timestamp) {
    try {
      DateTime dateTime = timestamp.toDate(); // Convert Timestamp to DateTime
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } catch (e) {
      print('Error converting timestamp to date: $e');
      return ''; // Return empty string in case of error
    }
  }

}