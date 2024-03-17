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
}
