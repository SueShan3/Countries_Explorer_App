class FormatUtils {
  static String formatNumber(num number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );
  }

  static String formatArea(double area) {
    return '${formatNumber(area.round())} km²';
  }
}
