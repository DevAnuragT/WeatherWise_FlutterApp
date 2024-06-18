**WeatherWise: Your Personal Weather Companion**

WeatherWise keeps you prepared with accurate weather updates and forecasts. Search and save cities, access detailed reports, and stay informed about air quality. Enjoy dynamic backgrounds, a customizable dashboard, and easy navigation. WeatherWise ensures your data is always available, even offline.

## Overview
The Weather App is a feature-rich application designed to provide users with accurate and up-to-date weather information. It leverages a sleek and intuitive user interface to deliver real-time weather data, forecasts, and air quality information for cities around the world.

## Key Features
- **Current Weather Information**: Displays the current temperature, weather conditions, and other relevant details such as humidity, wind speed, and cloud cover.
- **City Search**: Users can search for and add cities to get weather updates for multiple locations.
- **Weather Forecast**: Provides detailed forecasts, including maximum and minimum temperatures for the day.
- **Air Quality Index**: Shows the Air Quality Index (AQI) and related health advisories.
- **Dynamic Backgrounds**: The app changes its background images based on the weather conditions and time of day, enhancing the user experience.

## Screenshots
1. **Home Screen**
   
   <img src="https://github.com/DevAnuragT/WeatherWise_FlutterApp/assets/97083108/979f38cb-8faa-4b00-913c-5f18d50da8cc" alt="Home Screen" width="300">

2. **City Search Screen**

   <img src="https://github.com/DevAnuragT/WeatherWise_FlutterApp/assets/97083108/987378a1-b8e0-4663-856a-4e3cc6a3d31e" alt="City Search Screen" width="300">

3. **More Screenshots**

<img src="https://github.com/DevAnuragT/WeatherWise_FlutterApp/assets/97083108/daf2be48-6919-4705-9948-2e263ec2ac21" alt="City Search Screen" width="300">
<img src="https://github.com/DevAnuragT/WeatherWise_FlutterApp/assets/97083108/43898897-2a9d-4e17-bac9-41d598691ac2" alt="City Search Screen" width="300">
<img src="https://github.com/DevAnuragT/WeatherWise_FlutterApp/assets/97083108/fa671b2c-a5d8-4e74-80b2-287f3dccaf4c" alt="City Search Screen" width="300">

   

## Video Demonstration

Watch the video below to see the app in action and understand its functionalities better.

[![Link to Video](https://github.com/DevAnuragT/WeatherWise_FlutterApp/assets/97083108/58e6a90e-ecbb-4323-b0fe-15477f0d09ad)

## Technical Implementation

### Use of APIs
The app utilizes multiple APIs to fetch and display weather data and air quality information.

1. **Weather API**: 
   - **Provider**: OpenWeatherMap API
   - **Endpoint**: `https://api.openweathermap.org/data/2.5/weather`
   - **Parameters**: 
     - `q` (city name)
     - `appid` (API key)
     - `units` (measurement units - metric/imperial)
   - **Data Retrieved**: Current temperature, weather conditions, wind speed, humidity, sunrise, and sunset times.

2. **Air Quality API**: 
   - **Provider**: OpenWeatherMap API
   - **Endpoint**: `https://api.openweathermap.org/data/2.5/air_pollution`
   - **Parameters**: 
     - `lat` (latitude)
     - `lon` (longitude)
     - `appid` (API key)
   - **Data Retrieved**: Air Quality Index (AQI), pollutant concentrations.

### Data Storage
The app uses local storage to save the list of cities added by the user. This ensures that users' preferences are maintained between sessions. The storage is managed using a combination of text files and shared preferences.

### Dynamic Backgrounds
Background images change based on the current weather conditions (clear, cloudy, rainy, etc.) and the time of day (day or night). This is determined by the weather condition codes and icon data provided by the weather API.

### User Interface
- **Home Screen**: Displays the current weather of the selected city, with options to refresh the data or search for a new city.
- **City Search Screen**: Allows users to search for cities and add them to their list.
- **Weather Details Screen**: Provides a detailed view of the weather conditions, including temperature variations and weather summaries.
- **Air Quality Screen**: Shows the AQI and related health recommendations.

### Development Tools and Libraries
- **Flutter**: The app is built using the Flutter framework, providing a smooth and responsive cross-platform experience.
- **Dart**: The programming language used for Flutter development.
- **Google Fonts**: For custom and stylish fonts.
- **Path Provider**: To access the file system for data storage.
- **Shared Preferences**: For simple key-value storage to save user preferences.

**Stay prepared, stay informed, and stay WeatherWise!**
