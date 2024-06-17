import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'location.dart';
import 'networking.dart';
import 'package:geocoding/geocoding.dart';

const String appid = '0338538b6391ee6fc210c5aef589ec40';

class WeatherModel {
  LocateLocation location = LocateLocation();

  Future<dynamic> getLocationWeather() async {
    await location.getCurrentLocation();
    NetworkHelper net = NetworkHelper(url: 'https://api.openweathermap.org/data/2.5/weather?lat=${location.latitude}&lon=${location.longitude}&appid=$appid&units=metric');
    var weatherData = await net.getData();
    return weatherData;
  }

  Future<dynamic> getCityWeather(String city) async {
    try{
      List<Location> l = await locationFromAddress(city);
      if (l.isNotEmpty) {
        final locate = l.first;
        NetworkHelper net = NetworkHelper(url: 'https://api.openweathermap.org/data/2.5/weather?lat=${locate.latitude}&lon=${locate.longitude}&appid=$appid&units=metric');
        var weatherData = await net.getData();
        return weatherData;
      } else {
        print("No weather data");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> getAirQuality() async {
    await location.getCurrentLocation();
    NetworkHelper net = NetworkHelper(url: 'https://api.openweathermap.org/data/2.5/air_pollution?lat=${location.latitude}&lon=${location.longitude}&appid=$appid');
    var airQualityData = await net.getData();
    return airQualityData;
  }

  Future<dynamic> getCityAirQuality(String city) async {
    try{
      List<Location> l = await locationFromAddress(city);
      if (l.isNotEmpty) {
        final locate = l.first;
        NetworkHelper net = NetworkHelper(url: 'https://api.openweathermap.org/data/2.5/air_pollution?lat=${locate.latitude}&lon=${locate.longitude}&appid=$appid');
        var airQualityData = await net.getData();
        return airQualityData;
      } else {
        print("No weather data");
      }
    } catch (e) {
      print(e);
    }
  }

  String getConditionMessage(int condition) {
    if (condition < 300) {
      return 'Thunderstorm';
    } else if (condition < 400) {
      return 'Drizzle';
    } else if (condition < 600) {
      return 'Rain';
    } else if (condition < 700) {
      return 'Snow';
    } else if (condition >= 701 && condition <= 781) {
      return 'Atmosphere';
    } else if (condition == 800) {
      return 'Clear';
    } else if (condition <= 804) {
      return 'Clouds';
    } else {
      return 'Unknown';
    }
  }

}

