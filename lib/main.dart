import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  String location = "Thrissur"; // Default location

  final String apiUrl =
      "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/Chennai?unitGroup=metric&key=7JWQMV9WC5JJBUQF22L83ERCB&contentType=json";

  Map<String, dynamic> weatherData = {};

  Future<void> fetchWeatherData() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      setState(() {
        weatherData = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Weather App'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      location = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Enter Location',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: fetchWeatherData,
                child: Text('Get Weather'),
              ),
              weatherData.isNotEmpty
                  ? WeatherDisplay(weatherData: weatherData)
                  : CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}

class WeatherDisplay extends StatelessWidget {
  final Map<String, dynamic> weatherData;

  WeatherDisplay({required this.weatherData});

  @override
  Widget build(BuildContext context) {
    final temperature = weatherData['currentConditions']['temp'];
    final condition = weatherData['currentConditions']['conditions'];
    final humidity = weatherData['currentConditions']['humidity'];
    final windSpeed = weatherData['currentConditions']['windspeed'];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Temperature: $temperature °C',
          style: TextStyle(fontSize: 24),
        ),
        Text(
          'Condition: $condition',
          style: TextStyle(fontSize: 18),
        ),
        Text(
          'Humidity: $humidity%',
          style: TextStyle(fontSize: 18),
        ),
        Text(
          'Wind Speed: $windSpeed km/h',
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}
