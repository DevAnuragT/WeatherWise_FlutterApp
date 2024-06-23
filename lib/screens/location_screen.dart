import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:weather/screens/city_screen.dart';
import 'package:weather/services/weather.dart';
import 'package:weather/utilities/constants.dart';
import 'package:weather/services/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather/services/database.dart';

class LocationScreen extends StatefulWidget {
  final weather;
  final airQuality;

  LocationScreen({required this.weather, this.airQuality});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  Database database = Database();
  String backgroundImage = 'assets/background/clearDay.jpg';
  WeatherModel model = WeatherModel();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    initialiseData(); // Load city data when the screen initializes
    updateUI(widget.weather, widget.airQuality);
  }

  double temp = 0.0, feelTemp = 0.0, maxTemp = 0.0, minTemp = 0.0;
  String city = '';
  int condition = 0, currentTime = 0, aqi = 0, sunrise = 0, sunset = 0;
  String airCondition = '', icon = '', date = '', windspeed = '', humidity = '', clouds = '', summary = '';

  void initialiseData() async {
    await database.getData(); // Load data from file
  }

  void updateUI(dynamic weather, dynamic airQuality) {
    setState(() {
      if (weather == null || airQuality == null) {
        temp = 0.0;
        feelTemp = 0.0;
        city = '';
        condition = 0;
        icon = '';
        windspeed = '0';
        humidity = '0';
        clouds = '0';
        aqi = 0;
        airCondition = 'Unknown';
        loading = false;
        return;
      }
      humidity = weather['main']['humidity'].toString();
      clouds = weather['clouds']['all'].toString();
      windspeed = weather['wind']['speed'].toString();
      date = DateFormat.yMMMd().format(DateTime.now());
      temp = (weather['main']['temp'] as num).toDouble();
      condition = weather['weather'][0]['id'];
      summary = weather['weather'][0]['description'];
      city = weather['name'];
      maxTemp = (weather['main']['temp_max']).toDouble();
      minTemp = (weather['main']['temp_min']).toDouble();
      feelTemp = (weather['main']['feels_like'] as num).toDouble();
      sunrise = weather['sys']['sunrise'] as int;
      sunset = weather['sys']['sunset'] as int;
      icon = weather['weather'][0]['icon'];
      updateBackground(icon);
      if (!database.isCity(city)) {
        database.addCity(city, icon, temp.toInt());
      } else {
        database.updateCity(city, icon, temp.toInt());
      }
      currentTime = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
      aqi = airQuality['list'][0]['main']['aqi'];
      if (aqi == 1)
        airCondition = 'Excellent';
      else if (aqi == 2)
        airCondition = 'Satisfactory';
      else if (aqi == 3)
        airCondition = 'Moderate';
      else if (aqi == 4)
        airCondition = 'Unhealthy for Sensitive Groups';
      else if (aqi == 5)
        airCondition = 'Very Unhealthy';
      else
        airCondition = 'Unknown';
      loading = false;
    });
  }

  void updateBackground(String icon) {
    String newBackgroundImage;
    bool isDayTime = icon.endsWith('d');

    if (icon.startsWith('01')) {
      newBackgroundImage = isDayTime
          ? 'assets/background/clearDay.jpg'
          : 'assets/background/clearNight.jpg';
    } else if (icon.startsWith('02') ||
        icon.startsWith('03') ||
        icon.startsWith('04')) {
      newBackgroundImage = isDayTime
          ? 'assets/background/sunnyDay.png'
          : 'assets/background/sunnyNight.png';
    } else if (icon.startsWith('09') || icon.startsWith('10')) {
      newBackgroundImage = isDayTime
          ? 'assets/background/rainDay.jpg'
          : 'assets/background/rainNight.jpg';
    } else {
      newBackgroundImage = isDayTime
          ? 'assets/background/clearDay.jpg'
          : 'assets/background/clearNight.jpg';
    }

    setState(() {
      backgroundImage = newBackgroundImage;
    });
  }

  Column property(String text, String img) {
    return Column(
      children: [
        Card(
          elevation: 0,
          color: Color.fromRGBO(190, 186, 186, 0.3176470588235294),
          child: Padding(
              padding: EdgeInsets.all(5),
              child: Image.asset('assets/icons/$img.png', scale: 2)),
        ),
        Text(
          img == 'windspeed' ? '$text km/h' : '$text %',
          style: GoogleFonts.lato(
            color: icon.endsWith('n') ? Colors.white70 : Colors.black54,
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                backgroundImage,
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2.8, sigmaY: 2.8),
                child: Container(
                  color: Colors.white.withOpacity(0.15),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          var weatherData = await model.getLocationWeather();
                          var airQuality = await model.getAirQuality();
                          updateUI(weatherData, airQuality);
                        },
                        child: Icon(
                          Icons.location_on_outlined,
                          size: 33.0,
                          color: icon.endsWith('n') ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      Text(
                        '$city',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.barlow(
                          fontSize: 27,
                          color: icon.endsWith('n') ? Colors.white : Colors.black,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          var typedName = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CityScreen(
                                database: database,
                              ),
                            ),
                          );
                          if (typedName != null) {
                            setState(() {
                              loading = true;
                            });
                            var weatherData =
                            await model.getCityWeather(typedName);
                            var airQuality =
                            await model.getCityAirQuality(typedName);
                            updateUI(weatherData, airQuality);
                          }
                        },
                        child: Icon(
                          Icons.search_outlined,
                          size: 33.0,
                          color: icon.endsWith('n')
                              ? Colors.white70
                              : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15, top: 5),
                    child: Text(
                      date,
                      textAlign: TextAlign.left,
                      style: kTextStyle.copyWith(
                        color: icon.endsWith('n') ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Image.asset(
                          'assets/weather/$icon.png',
                          scale: 1.2,
                          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                            // This widget will be used if the image is not found
                            return Icon(
                              Icons.cloud,
                              size: 80,
                            );
                          },
                        ),
                      ),

                      SizedBox(
                        width: 30,
                      ),
                      Row(
                        children: [
                          Text(
                            '${temp.toStringAsFixed(0)}°',
                            style: GoogleFonts.barlow(
                              color: icon.endsWith('n') ? Colors.white : Colors.black87,
                              fontSize: 80,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    'Feels like ${feelTemp.toStringAsFixed(0)}° - ${model.getConditionMessage(condition)}',
                    textAlign: TextAlign.center,
                    style: kTextStyle.copyWith(
                      color:
                      icon.endsWith('n') ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  Text(
                    '${summary[0].toUpperCase()}${summary.substring(1)}',
                    style: kTextStyle.copyWith(
                      color:
                      icon.endsWith('n') ? Colors.white70 : Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      property(windspeed, 'windspeed'),
                      property(humidity, 'humidity'),
                      property(clouds, 'clouds'),
                    ],
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                    height: 15,
                    child: Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 270,
                        child: Divider(
                          color: Colors.black12,
                          thickness: 1.5,
                        ),
                      ),
                    ),
                  ),
                  Card(
                    color: colour,
                    margin: EdgeInsets.all(15.0),
                    elevation: 0,
                    child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Text(
                            'Air Quality',
                            style: kHeadingStyle.copyWith(
                              color: icon.endsWith('n') ? Colors.white : Colors.black87,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          AqiSlider(aqi: aqi),
                          SizedBox(height: 10.0),
                          Text(
                            'AQI: ${airCondition}',
                            textAlign: TextAlign.center,
                            style: kTextStyle.copyWith(
                              color: icon.endsWith('n') ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  WeatherTemperatureWidget(
                      maxTemperature: maxTemp, minTemperature: minTemp, icon: icon),
                  SizedBox(height: 20),

                  SunRiseSet(sunrise: sunrise, sunset: sunset),

                  SizedBox(height: 20), // Adding some space at the bottom
                ],
              ),
            ),
            if (loading)
              Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
