import 'package:flutter/material.dart';

class WeatherUtils {
  /// Returns gradient colors based on weather condition
  static List<Color> getGradientColors(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return [const Color(0xFF1E3A5F), const Color(0xFF2E86C1)];
      case 'clouds':
        return [const Color(0xFF4A5568), const Color(0xFF718096)];
      case 'rain':
      case 'drizzle':
        return [const Color(0xFF1A202C), const Color(0xFF2D3748)];
      case 'thunderstorm':
        return [const Color(0xFF1A1A2E), const Color(0xFF16213E)];
      case 'snow':
        return [const Color(0xFF2C3E50), const Color(0xFF4CA1AF)];
      case 'mist':
      case 'fog':
      case 'haze':
        return [const Color(0xFF536976), const Color(0xFF292E49)];
      default:
        return [const Color(0xFF1E3A5F), const Color(0xFF2E86C1)];
    }
  }

  /// Returns weather icon emoji
  static String getWeatherEmoji(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return '☀️';
      case 'clouds':
        return '☁️';
      case 'rain':
        return '🌧️';
      case 'drizzle':
        return '🌦️';
      case 'thunderstorm':
        return '⛈️';
      case 'snow':
        return '❄️';
      case 'mist':
      case 'fog':
      case 'haze':
        return '🌫️';
      default:
        return '🌤️';
    }
  }

  /// Format temperature string
  static String formatTemp(double temp) {
    return '${temp.round()}°C';
  }

  /// Format time from Unix timestamp
  static String formatTime(int timestamp) {
    final dt = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  /// Capitalize first letter of each word
  static String capitalize(String s) {
    return s.split(' ').map((w) {
      if (w.isEmpty) return w;
      return w[0].toUpperCase() + w.substring(1);
    }).join(' ');
  }
}
