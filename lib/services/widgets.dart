import 'package:flutter/material.dart';
import 'dart:math';
import 'package:geekyants_flutter_gauges/geekyants_flutter_gauges.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:weather/utilities/constants.dart';
// import 'package:weather_icons/weather_icons.dart';
import 'weather.dart'; // Assuming this provides the getAqiColor function

class AqiSlider extends StatefulWidget {
  AqiSlider({required this.aqi});
  final int aqi;

  @override
  State<AqiSlider> createState() => _AqiSliderState();
}

class _AqiSliderState extends State<AqiSlider> {
  @override
  Widget build(BuildContext context) {
    WeatherModel model = WeatherModel();

    // Define the gradient colors for different air quality ranges
    final List<Color> gradientColors = [
      Colors.greenAccent,
      Colors.yellowAccent.withOpacity(0.8),
      Colors.orangeAccent.withOpacity(0.8),
      Colors.redAccent.withOpacity(0.8),
      Colors.purpleAccent.withOpacity(0.8),
      Color(0xFF7E0023)
          .withOpacity(0.8), // Adjust opacity for smoother transition
    ];
    return SfLinearGauge(
      minimum: 0,
      maximum: 5,
      animateAxis: true,
      animationDuration: 2000,
      showLabels: false,
      showTicks: false,
      axisTrackStyle: LinearAxisTrackStyle(
        // Apply the gradient to the axis track
        gradient: LinearGradient(
          colors: gradientColors,
          stops: [
            0.0,
            0.2,
            0.4,
            0.6,
            0.8,
            1.0
          ], // Define stops for color transitions
        ),
      ),
      markerPointers: [
        LinearShapePointer(
          value: widget.aqi.toDouble(),
          color: Colors.white54.withOpacity(0.8),
          shapeType: LinearShapePointerType.circle,
          borderColor: Colors.transparent,
          borderWidth: 0,
          position: LinearElementPosition.cross,
        ),
      ],
    );
  }
}

class TemperatureInfo {
  final String label;
  final String imageUrl; // Placeholder for the image URL
  final double temperature;

  TemperatureInfo({
    required this.label,
    required this.imageUrl,
    required this.temperature,
  });
}


class WeatherTemperatureWidget extends StatelessWidget {
  final double maxTemperature;
  final double minTemperature;
  final String icon;

  WeatherTemperatureWidget(
      {required this.maxTemperature, required this.minTemperature, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          maxTemperature > 30 ? Icons.sunny : Icons.cloud_outlined,
          color: Colors.orange,
          size: 35,
        ),
        SizedBox(width: 10),
        Text(
          ' Max: ${maxTemperature.toStringAsFixed(0)}°C',
          style: kHeadingStyle.copyWith(
            color: icon.endsWith('n') ? Colors.white70 : Colors.black87,
          ),
        ),
        SizedBox(width: 40),
        Icon(
          minTemperature < 10 ? Icons.snowing : Icons.cloud_outlined,
          color: Colors.blueAccent,
          size: 35,
        ),
        SizedBox(width: 10),
        Text(
          ' Min: ${minTemperature.toStringAsFixed(0)}°C',
          style: kHeadingStyle.copyWith(
            color: icon.endsWith('n') ? Colors.white70 : Colors.black87,
          ),
        ),
      ],
    );
  }
}


class SunRiseSet extends StatefulWidget {
  final int sunrise; // Sunrise time in Unix timestamp (UTC)
  final int sunset; // Sunset time in Unix timestamp (UTC)

  SunRiseSet({required this.sunrise, required this.sunset});

  @override
  _SunRiseSetState createState() => _SunRiseSetState();
}

class _SunRiseSetState extends State<SunRiseSet> {
  late double _currentTimeValue;
  late IconData _thumbIcon;
  late double _minValue;
  late double _maxValue;

  @override
  Widget build(BuildContext context) {
    int currentTime = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
    int nextSunrise = widget.sunrise + 86400; // Next day's sunrise
    _currentTimeValue = currentTime.toDouble();

    _minValue = widget.sunset.toDouble();
    _maxValue = widget.sunrise.toDouble();

    if (_currentTimeValue < widget.sunrise) { // 12am to sunrise
      _thumbIcon = Icons.nightlight_round;
      _minValue = widget.sunset.toDouble(); // previous sunset
      _maxValue = widget.sunrise.toDouble();
    } else if (_currentTimeValue > widget.sunset) { // Sunset to next day's sunrise
      _thumbIcon = Icons.nightlight_round_outlined;
      _minValue = widget.sunset.toDouble();
      _maxValue = nextSunrise.toDouble();
    } else {
      _thumbIcon = Icons.wb_sunny; // Sunrise to sunset
    }
// Swap values if necessary to ensure start < end
    if (_minValue > _maxValue) {
      double temp = _minValue;
      _minValue = _maxValue;
      _maxValue = temp;
    }
    // Ensure _currentTimeValue is within the gauge range
    if (_currentTimeValue < _minValue) {
      _currentTimeValue = _minValue;
    } else if (_currentTimeValue > _maxValue) {
      _currentTimeValue = _maxValue;
    }
    return Card(
      elevation: 0,
      color: Colors.white54.withOpacity(0.2), // Customize the card color
      margin: EdgeInsets.all(15),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _thumbIcon==Icons.nightlight_round ? 'Sunset' : _thumbIcon == Icons.wb_sunny ? 'Sunrise' : 'Sunset',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  _thumbIcon,
                  color: Colors.white,
                  size: 30,
                ),
                Text(
                  //oppostie of first text
                  _thumbIcon==Icons.nightlight_round ? 'Sunrise' : _thumbIcon == Icons.wb_sunny ? 'Sunset' : 'Sunrise',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: LinearGauge(
                start: _minValue,
                end: _maxValue,
                linearGaugeBoxDecoration: LinearGaugeBoxDecoration(
                  backgroundColor: Colors.white70.withOpacity(0.6),
                  borderRadius: 20,
                ),
                gaugeOrientation: GaugeOrientation.horizontal,
                enableGaugeAnimation: true,
                rulers: RulerStyle(
                  rulerPosition: RulerPosition.center,
                  showSecondaryRulers: false,
                  secondaryRulerColor: Colors.white,
                  primaryRulersHeight: 10,
                  showLabel: false,
                  showPrimaryRulers: false,
                ),
                pointers: [
                  Pointer(
                    value: _currentTimeValue,
                    shape: PointerShape.diamond,
                    showLabel: false,
                    width: 20,
                    height: 20,
                    color: Colors.white,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
