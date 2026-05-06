import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../utils/weather_utils.dart';
import '../widgets/info_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final WeatherService _weatherService = WeatherService();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  WeatherModel? _weather;
  bool _isLoading = false;
  String? _errorMessage;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
    // Load default city on start
    _fetchWeather('Islamabad');
  }

  @override
  void dispose() {
    _animController.dispose();
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  Future<void> _fetchWeather(String city) async {
    if (city.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final weather = await _weatherService.fetchWeatherByCity(city.trim());
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
      _animController.reset();
      _animController.forward();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  void _onSearch() {
    _searchFocus.unfocus();
    _fetchWeather(_searchController.text);
  }

  List<Color> get _gradientColors {
    if (_weather == null) {
      return [const Color(0xFF1E3A5F), const Color(0xFF0D2137)];
    }
    return WeatherUtils.getGradientColors(_weather!.mainCondition);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _gradientColors,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Top Bar ──
              _buildSearchBar(),

              // ── Body ──
              Expanded(
                child: _isLoading
                    ? _buildLoader()
                    : _errorMessage != null
                        ? _buildError()
                        : _weather == null
                            ? _buildPlaceholder()
                            : _buildWeatherContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Search Bar ──────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.white.withOpacity(0.25),
                ),
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocus,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Search city...',
                  hintStyle: TextStyle(color: Colors.white54),
                  prefixIcon: Icon(Icons.search, color: Colors.white54),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                ),
                onSubmitted: (_) => _onSearch(),
                textInputAction: TextInputAction.search,
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _onSearch,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.arrow_forward, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // ── Loading ─────────────────────────────────────
  Widget _buildLoader() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 16),
          Text('Fetching weather...',
              style: TextStyle(color: Colors.white70, fontSize: 15)),
        ],
      ),
    );
  }

  // ── Error ────────────────────────────────────────
  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, color: Colors.white54, size: 64),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'Something went wrong.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _fetchWeather(_searchController.text),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Placeholder ──────────────────────────────────
  Widget _buildPlaceholder() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('🌍', style: TextStyle(fontSize: 64)),
          SizedBox(height: 16),
          Text(
            'Search for a city\nto get weather info',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
        ],
      ),
    );
  }

  // ── Main Weather Content ─────────────────────────
  Widget _buildWeatherContent() {
    final w = _weather!;
    return FadeTransition(
      opacity: _fadeAnim,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),

            // City & Country
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, color: Colors.white70, size: 18),
                const SizedBox(width: 4),
                Text(
                  '${w.cityName}, ${w.country}',
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
              _formatDate(w.dateTime),
              style: const TextStyle(color: Colors.white60, fontSize: 13),
            ),

            const SizedBox(height: 24),

            // Weather Icon from API
            Image.network(
              w.iconUrl,
              width: 110,
              height: 110,
              errorBuilder: (_, __, ___) => Text(
                WeatherUtils.getWeatherEmoji(w.mainCondition),
                style: const TextStyle(fontSize: 90),
              ),
            ),

            const SizedBox(height: 8),

            // Temperature
            Text(
              WeatherUtils.formatTemp(w.temperature),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 72,
                fontWeight: FontWeight.w200,
                letterSpacing: -2,
              ),
            ),

            // Condition
            Text(
              WeatherUtils.capitalize(w.description),
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
                  'H: ${WeatherUtils.formatTemp(w.tempMax)}',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(width: 16),
                Text(
                  'L: ${WeatherUtils.formatTemp(w.tempMin)}',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Divider
            Divider(color: Colors.white.withOpacity(0.2)),
            const SizedBox(height: 20),

            // Info Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.05,
              children: [
                InfoCard(
                  icon: Icons.thermostat,
                  label: 'Feels Like',
                  value: WeatherUtils.formatTemp(w.feelsLike),
                ),
                InfoCard(
                  icon: Icons.water_drop,
                  label: 'Humidity',
                  value: '${w.humidity}%',
                ),
                InfoCard(
                  icon: Icons.air,
                  label: 'Wind',
                  value: '${w.windSpeed.toStringAsFixed(1)} m/s',
                ),
                InfoCard(
                  icon: Icons.compress,
                  label: 'Pressure',
                  value: '${w.pressure} hPa',
                ),
                InfoCard(
                  icon: Icons.visibility,
                  label: 'Visibility',
                  value: '${(w.visibility / 1000).toStringAsFixed(1)} km',
                ),
                InfoCard(
                  icon: Icons.cloud,
                  label: 'Clouds',
                  value: '${w.clouds}%',
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Sunrise / Sunset
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _sunInfo('🌅', 'Sunrise',
                      WeatherUtils.formatTime(w.sunrise)),
                  Container(
                      width: 1, height: 40, color: Colors.white24),
                  _sunInfo('🌇', 'Sunset',
                      WeatherUtils.formatTime(w.sunset)),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _sunInfo(String emoji, String label, String time) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 22)),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(color: Colors.white54, fontSize: 11)),
        const SizedBox(height: 2),
        Text(time,
            style: const TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
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
