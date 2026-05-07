import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../utils/weather_utils.dart';

class WeatherCard extends StatelessWidget {
  final WeatherModel weather;

  const WeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // City & Country
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on, color: Colors.white70, size: 18),
            const SizedBox(width: 4),
            Text(
              '${weather.cityName}, ${weather.country}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),

        const SizedBox(height: 6),

        // Date
        Text(
          _formatDate(weather.dateTime),
          style: const TextStyle(color: Colors.white60, fontSize: 13),
        ),

        const SizedBox(height: 20),

        // Weather Icon
        Image.network(
          weather.iconUrl,
          width: 110,
          height: 110,
          errorBuilder: (_, __, ___) => Text(
            WeatherUtils.getWeatherEmoji(weather.mainCondition),
            style: const TextStyle(fontSize: 90),
          ),
        ),

        const SizedBox(height: 8),

        // Temperature
        Text(
          WeatherUtils.formatTemp(weather.temperature),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 72,
            fontWeight: FontWeight.w200,
            letterSpacing: -2,
          ),
        ),

        // Condition
        Text(
          WeatherUtils.capitalize(weather.description),
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 18,
            letterSpacing: 0.5,
          ),
        ),

        const SizedBox(height: 6),

        // Min / Max
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'H: ${WeatherUtils.formatTemp(weather.tempMax)}',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(width: 16),
            Text(
              'L: ${WeatherUtils.formatTemp(weather.tempMin)}',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    const days = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
    return '${days[dt.weekday - 1]}, ${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }
}
