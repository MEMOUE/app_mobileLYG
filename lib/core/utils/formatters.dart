class Formatters {
  // Date and time formatters
  static String dateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
  
  static String date(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
  }
  
  static String time(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
  
  static String dateTimeShort(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCheck = DateTime(dateTime.year, dateTime.month, dateTime.day);
    
    if (dateToCheck == today) {
      return 'Aujourd\'hui ${time(dateTime)}';
    } else if (dateToCheck == yesterday) {
      return 'Hier ${time(dateTime)}';
    } else {
      return date(dateTime);
    }
  }
  
  // Currency formatter (CFA)
  static String currency(double amount) {
    return '${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]} ')} CFA';
  }
  
  // Phone formatter
  static String phone(String phone) {
    // Remove all non-digits
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    
    if (digits.length >= 9) {
      // Format: +221 XX XXX XX XX
      if (digits.startsWith('221')) {
        final remaining = digits.substring(3);
        if (remaining.length >= 8) {
          return '+221 ${remaining.substring(0, 2)} ${remaining.substring(2, 5)} ${remaining.substring(5, 7)} ${remaining.substring(7)}';
        }
      } else if (digits.length >= 9) {
        // Format: XX XXX XX XX
        return '${digits.substring(0, 2)} ${digits.substring(2, 5)} ${digits.substring(5, 7)} ${digits.substring(7)}';
      }
    }
    
    return phone;
  }
  
  // Distance formatter
  static String distance(double distanceInKm) {
    if (distanceInKm < 1) {
      return '${(distanceInKm * 1000).toInt()} m';
    } else {
      return '${distanceInKm.toStringAsFixed(1)} km';
    }
  }
  
  // Weight formatter
  static String weight(double weightInKg) {
    if (weightInKg < 1000) {
      return '${weightInKg.toStringAsFixed(1)} kg';
    } else {
      return '${(weightInKg / 1000).toStringAsFixed(1)} t';
    }
  }
  
  // Volume formatter
  static String volume(double volumeInM3) {
    return '${volumeInM3.toStringAsFixed(1)} m³';
  }
  
  // Capitalize first letter
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
  
  // Get initials from name
  static String getInitials(String firstName, String lastName) {
    String initials = '';
    if (firstName.isNotEmpty) {
      initials += firstName[0].toUpperCase();
    }
    if (lastName.isNotEmpty) {
      initials += lastName[0].toUpperCase();
    }
    return initials;
  }
}